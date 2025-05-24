#!/bin/bash

# Prompt the user to enter the table name
read -p "Please Enter Table Name: " TBName

# Check if the metadata file for the table exists
if [ ! -e "${TBName}MD" ]; then 
    echo "Table does not exist"
    exit 1
fi

# Read number of columns from the metadata file
Num_columns=$(awk -F: 'END{print NF}' "${TBName}MD")

# Extract column names, types, and conditions from metadata
columns_names=($(awk -F: 'NR==1{for(i=1;i<=NF;i++)print $i}' "${TBName}MD"))
columns_types=($(awk -F: 'NR==2{for(i=1;i<=NF;i++)print $i}' "${TBName}MD"))
columns_conditions=($(awk -F: 'NR==3{for(i=1;i<=NF;i++)print $i}' "${TBName}MD"))

# Display the content of the table
cat "$TBName"

# Prompt the user to enter the primary key of the row to update
read -p "Enter the primary key of the row to update: " old_pk_value

# Check if the row with the given primary key exists
if ! grep -q "^$old_pk_value:" "$TBName"; then
    echo "Cannot update with this primary key."
    exit 1
fi

# Find the column with primary key by checking the metadata conditions for "P"
pk_col=-1
for ((i=0; i<Num_columns; i++)); do
    if [ "${columns_conditions[i]}" == "P" ]; then
        pk_col=$i
        break
    fi
done

# If the table has a primary key, allow the user to enter a new one
if [ "$pk_col" -ge 0 ]; then
    read -p "Enter new primary key: " new_pk_value
    if [ -n "$new_pk_value" ] && grep -q "^$new_pk_value:" "$TBName"; then
        echo "Primary key already exists! Cannot update."
        exit 1
    fi
else
    echo "Table does not have a primary key."
fi

# Collect the new values for the columns
line=""
for ((i=0; i<Num_columns; i++)); do
    if [ "$i" -eq "$pk_col" ]; then
        continue  # Skip the primary key column
    fi
    while true; do
        read -p "Enter new value for ${columns_names[i]} (${columns_types[i]}): " value
        if [ "${columns_types[i]}" == "int" ] && ! [[ "$value" =~ ^[0-9]+$ ]]; then
            echo "Error: Please enter an integer for '${columns_names[i]}'."
            continue
        elif [ "${columns_types[i]}" == "string" ] && [[ "$value" =~ ^[0-9]+$ ]]; then
            echo "Error: Please enter a string for '${columns_names[i]}'."
            continue
        fi
        break
    done
    line+=":$value"
done

# Update the row in the table using sed
if [ -n "$new_pk_value" ]; then
    sed -i "s/^$old_pk_value:.*/$new_pk_value$line/" "$TBName"
else
    sed -i "s/^$old_pk_value:.*/$old_pk_value$line/" "$TBName"
fi

# Display success message
echo "Record updated successfully."


          



    
    

