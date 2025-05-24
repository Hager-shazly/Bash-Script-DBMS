#!/bin/bash

read -p "Enter Table Name: " TBName

if [ -z "$TBName" ]; then
    echo "Please Enter Table Name"
elif [ ! -e "${TBName}MD" ]; then
    echo "Table Does Not Exist"
else
    line=""
    # Get number of columns by reading the first line of metadata
    Num_columns=$(awk -F: 'END {print NR}' "${TBName}MD")

    # Loop through each column in the metadata
    for ((i=1; i<=Num_columns; i++)); do
        column_name=$(awk -v i="$i" -F: '{if (NR==i) print $1}' "${TBName}MD")
        column_type=$(awk -v i="$i" -F: '{if (NR==i) print $2}' "${TBName}MD")
        column_cond=$(awk -v i="$i" -F: '{if (NR==i) print $3}' "${TBName}MD")

        # Input validation for each column
        while true; do
            read -p "Enter your ${column_name}: " value
            if [ -z "$value" ]; then
                echo "Please Enter your ${column_name}"
            elif [[ "$column_type" == "int" && ! "$value" =~ ^[0-9]+$ ]]; then
                echo "Invalid Type. Expected Type ${column_type}"
            elif [[ "$column_type" == "string" && ! "$value" =~ ^[a-zA-Z0-9]+$ ]]; then
                echo "Invalid Type. Expected Type ${column_type}"
            else
                # Check if column is a primary key and handle duplicate values
                if [ "$column_cond" == "P" ]; then
                    if grep -q "^$value:" "$TBName"; then
                        echo "Value already exists in the primary key column '$column_name'. Please enter a unique value."
                    else
                        break
                    fi
                else
                    break
                fi
            fi
        done

        # Append the value to the line
        if [ "$i" -eq "$Num_columns" ]; then
            line+="$value"
        else
            line+="$value:"
        fi
    done

    # Append the new record to the table file
    echo "$line" >> "$TBName"
    echo "Inserted Successfully"
fi
