#!/bin/bash

echo "List of Tables in ${CurrDB}"

# Check if the directory is empty
if [ -z "$(ls -A .)" ]; then
    echo "No tables found in the database."
else
    # Loop through the files in the current directory
    for table_file in ./*; do
        # Check if it's a file and not a metadata file
        if [ -f "$table_file" ] && [[ "$table_file" != *"MD" ]]; then
            table_name=$(basename "$table_file")
            echo "- $table_name"
        fi
    done
fi
