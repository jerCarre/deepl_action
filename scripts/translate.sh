#!/bin/bash
set -e

OUTPUT=""
INPUT=""
TARGET_LANG=""

# gen UUID
UUID=$(cat /proc/sys/kernel/random/uuid)

display_usage() {
    echo "Usage: $0 [arguments] <source_file>"
    echo " -h or --help: display this message"
    echo " -o or --output <file>: the target translated file" 
    echo " -l or --lang <language>: the target language for the translation" 
    echo " <source_file>: the file to translate"
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
                TARGET_LANG="$2"
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
PARAM_SOURCE_LANG=$([ ! -z "$SOURCE_LANG" ] && echo '-F "source_lang=${SOURCE_LANG^^}"' || echo "")

# transform input to HTML
pandoc -t html $INPUT -o /tmp/${UUID}.html

# ask for translation
curl -fsSL -X POST ${DEEPL_FREE_URL}/document -F "file=@/tmp/${UUID}.html" -F "auth_key=$DEEPL_FREE_AUTH_TOKEN" -F "target_lang=$TARGET_LANG" $PARAM_SOURCE_LANG -o /tmp/${UUID}.response.json

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
curl -fsSL ${DEEPL_FREE_URL}/document/$DOC_ID/result -d auth_key=$DEEPL_FREE_AUTH_TOKEN -d document_key=$DOC_KEY -o /tmp/${UUID}.result.html

# convert to output
OUTPUT_EXTENSION=${OUTPUT##*.}

# edit original meta to insert/update target lang
jq .lang='"'${TARGET_LANG}'"' /tmp/${UUID}.meta.json > /tmp/${UUID}.meta_out.json

# define pandoc options
PANDOC_OUTPUT_OPTIONS="-s --metadata-file=/tmp/${UUID}.meta_out.json --wrap=none"

if [ "${OUTPUT_EXTENSION^^}" = "MD" ]; then

  # add extra options
  PANDOC_OUTPUT_OPTIONS="${PANDOC_OUTPUT_OPTIONS} -t markdown-header_attributes --markdown-headings=atx"

  pandoc $PANDOC_OUTPUT_OPTIONS /tmp/${UUID}.result.html -o /tmp/${UUID}.ouput.$OUTPUT_EXTENSION

  # clean output markdown : remove ::: , modify code block header
  sed -i '/^:::/d' /tmp/${UUID}.ouput.$OUTPUT_EXTENSION
  sed -i 's/^``` {.sourceCode .\([a-z]*\).*}/``` \1/g' /tmp/${UUID}.ouput.$OUTPUT_EXTENSION
else
  pandoc $PANDOC_OUTPUT_OPTIONS /tmp/${UUID}.result.html -o /tmp/${UUID}.ouput.$OUTPUT_EXTENSION
fi

# publish output file
cp /tmp/${UUID}.ouput.$OUTPUT_EXTENSION $OUTPUT

# clean tmp files
rm -rf /tmp/${UUID}.* > /dev/null
