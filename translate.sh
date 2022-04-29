#!/bin/bash

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
            *)
                INPUT="$1"
                shift
        esac
    done
else
    display_usage
	exit 1
fi

# extract meta from input file
extractmeta.sh $INPUT -o /tmp/meta.json

# search for lang in meta
SOURCE_LANG= $(cat /tmp/meta.json | jq 'with_entries(.key |= ascii_downcase ).lang')

# transform input to HTML

# ask for translation

# When using Curl in shell scripts, always pass -fsSL, which: 
#    Treats non-2xx/3xx responses as errors (-f).
#    Disables the progress meter (-sS).
#    Handles HTTP redirects (-L).


# wait for response

# get translated document

# convert to output (get output file as pandoc target and it automatically determines target format)
