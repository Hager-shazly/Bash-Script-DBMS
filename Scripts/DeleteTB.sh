#!/bin/bash

read -p "Please Enter Table Name to Delete: " TBName

# Check if metadata file exists
if [ -f "${TBName}MD" ]; then
    read -p "Do you want to delete all data or a specific row? (all/specific): " delete_option
    
    if [ "$delete_option" == "all" ]; then
        # Delete all data
        > "$TBName"
        echo "All data deleted successfully from table '$TBName'."
    elif [ "$delete_option" == "specific" ]; then
        read -p "Enter the primary key value of the row to delete: " primary_key_value
        
        # Delete the specific row
        if [ -f "$TBName" ]; then
            # Extract the primary key column number from metadata
            pk_col=$(awk -F: '$3 == "P" {print NR; exit}' "${TBName}MD")
            if [ -n "$pk_col" ]; then
                # Find and delete the row with the matching primary key value
                sed -i "/^\([^:]*:*\)\{$((pk_col-1))\}$primary_key_value:/d" "$TBName"
                echo "Row with primary key '$primary_key_value' deleted successfully from table '$TBName'."
            else
                echo "Primary key not found in metadata."
            fi
        else
            echo "Data file $TBName not found for table '$TBName'."
        fi
    else
        echo "Invalid option."
    fi
else
    echo "No table with this name!"
fi
