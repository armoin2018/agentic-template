#!/bin/bash

SRC_DIR="../.github/copilot/chatmodes"
TEMPLATE_DIR="../templates/copilot/copilot/chatmodes"

for src_file in $(find ${SRC_DIR} -type f -name "*.md"); do
    filename=$(basename "$src_file")
    template_file="$TEMPLATE_DIR/$filename"

    if [[ -f "$template_file" ]]; then
        if cmp -s "$src_file" "$template_file"; then
            echo "Identical: $filename - removing $src_file"
            rm "$src_file"
        else
            echo "Different: $filename"
        fi
    else
        echo "Template missing for: $filename"
    fi
done
