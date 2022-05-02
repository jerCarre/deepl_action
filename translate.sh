#!/bin/bash

set -x

display_usage() {
    echo "Usage: $0 [arguments] <source_file>"
    echo "\t-h or --help: display this message"
    echo "\t-o or --output <file>: the target translated file" 
    echo "\t-l or --lang <language>: the target language for the translation" 
    echo "\t<source_file>: the file to translate"
}

OUTPUT=""
INPUT=""
TARGET_LANG=""

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

# extract meta from input file
SOURCE_LANG=$(./extractmeta.sh $INPUT | jq -r 'with_entries(.key |= ascii_downcase ).lang')
PARAM_SOURCE_LANG=""
if [ -z "$SOURCE_LANG" ]; then PARAM_SOURCE_LANG=""; else PARAM_SOURCE_LANG='-F "source_lang=$SOURCE_LANG" '; fi

# transform input to HTML
pandoc -t html $INPUT -o /tmp/$INPUT.html

# ask for translation
curl -fsSL -X POST $DEEPL_FREE_URL -F "file=@/tmp/$INPUT.html" -F "auth_key=$DEEPL_FREE_AUTH_TOKEN" -F "target_lang=$TARGET_LANG" $PARAM_SOURCE_LANG -o /tmp/response.json

DOC_ID=$(cat /tmp/response.json | jq -r '.document_id')
DOC_KEY=$(cat /tmp/response.json | jq -r '.document_key')

# wait for response
sleep 2

# get translated document
curl -fsSL $DEEPL_FREE_URL/$DOC_ID/result -d auth_key=$DEEPL_FREE_AUTH_TOKEN -d document_key=$DOC_KEY -o /tmp/result.html


# convert to output (get output file as pandoc target and it automatically determines target format)