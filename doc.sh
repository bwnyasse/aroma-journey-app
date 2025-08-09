#!/bin/bash

# Store the current working directory
ORIGINAL_DIR=$(pwd)

output="$ORIGINAL_DIR/aroma_journey_app_code.md"
echo "# this one is an export of the lib/ of a previous project in which I used FlutterFlow and FlutterModular to build a coffee app : Code Source Bellow" >"$output"

# Append the tree structure of lib and routes directories
echo "## Directory Structure" >>"$output"
echo "\`\`\`" >>"$output"
tree lib -I '*.g.dart' >>"$output"
#tree routes -I '*.g.dart' >>"$output"
echo "\`\`\`" >>"$output"
echo "" >>"$output"

process_file() {
    local file=$1
    local indent=$2
    local spaces=$(printf ' %.0s' {1..$indent})
    local filename=$(basename "$file")

    if [[ "$filename" == *.g.dart ]]; then
        return
    fi

    echo "${spaces}### $filename" >>"$output"
    echo "${spaces}\`\`\`dart" >>"$output"
    cat "$file" >>"$output"
    echo "${spaces}\`\`\`" >>"$output"
    echo "" >>"$output"
}

process_directory() {
    local directory=$1
    local indent=$2
    local spaces=$(printf ' %.0s' {1..$indent})
    local dirname=$(basename "$directory")

    echo "${spaces}## $dirname" >>"$output"

    for item in "$directory"/*; do
        if [ -d "$item" ]; then
            process_directory "$item" $((indent + 1))
        elif [ -f "$item" ]; then
            process_file "$item" $((indent + 1))
        fi
    done
}

process_directory "lib" 0
#process_directory "routes" 0

echo "Documentation generated in $output"
