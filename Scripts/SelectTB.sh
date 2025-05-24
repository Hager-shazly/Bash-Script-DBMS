#!/bin/bash

read -p "Enter table name: " table

# Check if the metadata file exists for the table
if [ -f "${table}MD" ]; then
    # Read the number of columns and column details
    n_cols=$(awk -F: 'END{print NF}' "${table}MD")
    columns_names=($(awk -F: 'NR==1{for(i=1;i<=NF;i++)print $i}' "${table}MD"))
    columns_types=($(awk -F: 'NR==2{for(i=1;i<=NF;i++)print $i}' "${table}MD"))
    columns_conditions=($(awk -F: 'NR==3{for(i=1;i<=NF;i++)print $i}' "${table}MD"))

    line=""
    for ((i=1; i<=n_cols; i++)); do
        while true; do
            read -p "Enter value for ${columns_names[i-1]} (${columns_types[i-1]}): " value

            # Check for ":" in the entered value
            if [[ "$value" == *":"* ]]; then
                echo "Error: Values cannot contain ':'. Enter the values again."
                continue
            fi

            # Check for data type (int, string)
            if [ "${columns_types[i-1]}" == "int" ]; then
                if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                    echo "Error: Invalid data type. Please enter an integer for '${columns_names[i-1]}'."
                    continue
                fi
            elif [ "${columns_types[i-1]}" == "string" ]; then
                if [[ "$value" =~ ^[0-9]+$ ]]; then
                    echo "Error: Invalid data type. Please enter a string for '${columns_names[i-1]}'."
                    continue
                fi
            else
                echo "Error: Unknown data type for '${columns_names[i-1]}'."
                continue 2
            fi

            break
        done

        line+=":$value"
    done

    line=${line#:}
    pk_col=""
    for ((i=0; i<n_cols; i++)); do
        if [ "${columns_conditions[i]}" == "P" ]; then
            pk_col="$i"
            break
        fi
    done

    # Check for duplicate primary key
    if [ -n "$pk_col" ]; then
        pk_value=$(echo "$line" | cut -d':' -f$((pk_col+1)))
        if grep -q "^$pk_value:" "${table}"; then
            echo "Error: Duplicate value for primary key."
            exit 1
        fi
    fi

    # Insert values into the table
    echo "$line" >> "$table"
    echo "Values inserted successfully."

else
    echo "No table with this name! Available tables are: "
    for t in ./*MD; do
        tname="${t#./}"
        tname="${tname%MD}"
        echo "$tname"
    done
fi

