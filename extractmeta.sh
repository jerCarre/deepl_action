#!/bin/bash
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
        *)
            INPUT="$1"
            shift
    esac
    done
else if (($# == 1)); then
       INPUT=$1
     else
       echo "usage: extractmeta yourfile.md / extractmeta yourfile.md -o result.json"
     fi
fi

echo '$meta-json$' > /tmp/metadata.pandoc-tpl

if [ -z "$OUTPUT" ]; then
  pandoc --template=/tmp/metadata.pandoc-tpl $INPUT
else
  pandoc --template=/tmp/metadata.pandoc-tpl $INPUT > $OUTPUT
fi
rm -f /tmp/metadata.pandoc-tpl
