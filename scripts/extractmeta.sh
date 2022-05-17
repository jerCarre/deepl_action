#!/bin/bash

display_usage() {
    echo "Usage: $0 [arguments] <source_file>"
    echo "\t-h or --help: display this message"
    echo "\t-o or --output <file>: json file to store metadat" 
    echo "\t<source_file>: the file to extract metadata"
}

OUTPUT=""
INPUT=""

if (($# > 1)); then
    while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT="$2"
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
else if (($# == 1)); then
       INPUT=$1
     else
       display_usage
             exit 1
     fi
fi

echo '$meta-json$' > /tmp/metadata.pandoc-tpl

if [ -z "$OUTPUT" ]; then
  pandoc --template=/tmp/metadata.pandoc-tpl $INPUT
else
  pandoc --template=/tmp/metadata.pandoc-tpl $INPUT > $OUTPUT
  echo "with output $OUTPUT"
  cat $OUTPUT
fi
rm -f /tmp/metadata.pandoc-tpl