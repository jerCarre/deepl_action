#!/bin/bash
set -e
# set -xe

OUTPUT=""
INPUT=""
TARGET_LANG=""

declare -A ConversionExtensionArray=( [md]=html [markdown]=html [rst]=html [html]=html [docx]=docx [pptx]=pptx [pdf]=pdf [txt]=txt )

# gen UUID
UUID=$(cat /proc/sys/kernel/random/uuid)

display_usage() {
    echo "Usage: $0 [arguments] <source_file>"
    echo " -h or --help: display this message"
    echo " -o or --output <file>: the target translated file" 
    echo " -l or --lang <language>: the target language for the translation" 
    echo " <source_file>: the file to translate"
}

convert() {
    input_file=$1
    output_file=$2

    meta_out_option=""
    if [ "$#" -eq 3 ]; then
        meta_out_option="--metadata-file=$3"
    fi

    input_extension=${input_file##*.}
    output_extension=${output_file##*.}

    if [ "$input_extension" != "$output_extension" ]; then

        # before conversion actions
        pandoc_output_options=""
        case ${output_extension,,} in
            md|markdown)
                pandoc_output_options="-s --wrap=none -t markdown-header_attributes --markdown-headings=atx "${meta_out_option}
                ;;
            rst)
                pandoc_output_options="-s --wrap=none "${meta_out_option}
                ;;
            *)
                pandoc_output_options="-s "${meta_out_option}
                ;;
        esac

        # conversion
        pandoc $pandoc_output_options ${input_file} -o ${output_file}

        # after conversion actions
        case ${output_extension,,} in
            md|markdown)
                sed -i '/^:::/d' ${output_file}
                sed -i 's/^``` {.sourceCode .\([a-z]*\).*}/``` \1/g' ${output_file}
                sed -i 's/{translate="no"}/ /g' ${output_file}
                ;;
            html|htm)
                sed -i 's/<code>/<code translate="no">/ g' ${output_file}
                sed -i 's/<div class="sourceCode"/<div class="sourceCode" translate="no"/g' ${output_file}
                ;;
            *)
                ;;
        esac

    else
        cp $input_file $output_file > /dev/null
    fi
}

# check args : input, target_lang, output
if (($# == 5)); then
    while [[ $# -gt 0 ]]; do
        case $1 in
            -o|--output)
                OUTPUT="$2"
                shift
                shift
                ;;
            -l|--lang)
                TARGET_LANG=$(echo "${2^^}")
                shift
                shift
                ;;
            -h|--help)
                display_usage
                exit 0
                ;;
            *)
                INPUT="$1"
                shift
                ;;
        esac
    done
else
    display_usage
    exit 1
fi

# check target lang
if [ "$TARGET_LANG" = "EN" ]; then
    TARGET_LANG="en-US"
else
    TARGET_LANG=$(/bcp47 $TARGET_LANG)
    if [ "$TARGET_LANG" = "" ]; then
        echo "Target language is empty or not respects the correct encoding"
        exit 1
    fi
fi


INPUT_EXTENSION=${INPUT##*.}

# check input extension support
if [ ! -v "ConversionExtensionArray[$INPUT_EXTENSION]" ]; then
    echo "file extension not supported"
    exit 1
fi

# check output is folder or file
[[ "${OUTPUT}" == */ ]] && OUTPUT="${OUTPUT}${INPUT##*/}" || OUTPUT="${OUTPUT}"

# check deepl quota
curl -fsSL ${DEEPL_FREE_URL}/usage -d auth_key=$DEEPL_FREE_AUTH_TOKEN -o /tmp/${UUID}.usage.json
character_count=$(cat "/tmp/${UUID}.usage.json" | jq -r '.character_count')
character_limit=$(cat "/tmp/${UUID}.usage.json" | jq -r '.character_limit')

if [ "$character_count" -ge "$character_limit" ]; then
 echo "You have exceeded your Deepl Free quota (${character_count} / ${character_limit})"
 exit 2
else
 echo "Your current consumption on Deepl Free (before this translation) : ${character_count} / ${character_limit}"
fi

# extract meta from input file
/extractmeta.sh $INPUT -o /tmp/${UUID}.meta.json
SOURCE_LANG=$(cat "/tmp/${UUID}.meta.json" | jq -r 'with_entries(.key |= ascii_downcase ).lang')
SOURCE_LANG=$(/bcp47 $SOURCE_LANG)

# edit original meta to insert/update target lang
jq .lang='"'${TARGET_LANG}'"' /tmp/${UUID}.meta.json > /tmp/${UUID}.meta_out.json

# transform input to deepl available format
CONVERSION_EXTENSION=${ConversionExtensionArray[${INPUT_EXTENSION,,}]}
convert $INPUT /tmp/${UUID}.${CONVERSION_EXTENSION}

# ask for translation
if [ "${SOURCE_LANG^^}" == "NULL" ]; then
  curl --silent -fSL -X POST ${DEEPL_FREE_URL}/document -F "file=@/tmp/${UUID}.${CONVERSION_EXTENSION}" -F "auth_key=$DEEPL_FREE_AUTH_TOKEN" -F "target_lang=${TARGET_LANG}" -o /tmp/${UUID}.response.json
else
  curl --silent -fSL -X POST ${DEEPL_FREE_URL}/document -F "file=@/tmp/${UUID}.${CONVERSION_EXTENSION}" -F "auth_key=$DEEPL_FREE_AUTH_TOKEN" -F "target_lang=${TARGET_LANG}" -F "source_lang=${SOURCE_LANG^^}" -o /tmp/${UUID}.response.json
fi

DOC_ID=$(cat /tmp/${UUID}.response.json | jq -r '.document_id')
DOC_KEY=$(cat /tmp/${UUID}.response.json | jq -r '.document_key')

# wait for response
translation_end=false
until [ "$translation_end" = true ]
do
    rm -f /tmp/${UUID}.status.json > /dev/null
    curl -fsSL ${DEEPL_FREE_URL}/document/$DOC_ID -d auth_key=$DEEPL_FREE_AUTH_TOKEN -d document_key=$DOC_KEY -o /tmp/${UUID}.status.json
    if [ $(cat /tmp/${UUID}.status.json | jq '.status | contains("error")') = true ]; then
        translation_end=true
        echo "$(cat /tmp/${UUID}.status.json | jq '.message')"
        exit 1
    else if [ $(cat /tmp/${UUID}.status.json | jq '.status | contains("done")') = true ]; then
            translation_end=true
            break            
         fi
    fi
    sleep 2
done

# get translated document
curl --silent -fSL ${DEEPL_FREE_URL}/document/$DOC_ID/result -d auth_key=$DEEPL_FREE_AUTH_TOKEN -d document_key=$DOC_KEY -o /tmp/${UUID}.result.${CONVERSION_EXTENSION}

# convert to output
OUTPUT_EXTENSION=${OUTPUT##*.}

convert /tmp/${UUID}.result.${CONVERSION_EXTENSION} /tmp/${UUID}.ouput.$OUTPUT_EXTENSION /tmp/${UUID}.meta_out.json

# publish output file
mkdir -p ${OUTPUT%/*} > /dev/null
cp /tmp/${UUID}.ouput.$OUTPUT_EXTENSION $OUTPUT

# output generated file
echo "::set-output name=generated_file::$(echo $OUTPUT)"

# clean tmp files
rm -rf /tmp/${UUID}.* > /dev/null