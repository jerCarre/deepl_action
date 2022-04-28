#!/bin/bash

# check args : input, target_lang, output
OUTPUT=""
INPUT=""
TARGET_LANG=""

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
        *)
            INPUT="$1"
            shift
    esac
    done
fi

# extract meta from input file
extractmeta.sh $INPUT -o /tmp/meta.json

# search for lang in meta
SOURCE_LANG= $(cat /tmp/meta.json | jq 'with_entries(.key |= ascii_downcase ).lang')

# transform input to HTML

# ask for translation

# wait for response

# get translated document

# convert to initial format

# copy to output
