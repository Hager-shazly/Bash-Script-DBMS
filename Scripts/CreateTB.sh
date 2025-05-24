#!/bin/bash

read -p "Please Enter Table Name: " TBName

# Check if the table already exists
if [ -f "$TBName" ]; then
    echo "Table already exists!"
elif ! [[ "$TBName" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
    echo "Invalid Table Name!"
elif [[ "$TBName" == *" "* || "$TBName" == "" ]]; then
    echo "Table name cannot have spaces!"
elif [[ "$TBName" =~ ^[0-9] ]]; then
    echo "Table name cannot start with a number!"
elif [[ "$TBName" =~ ^[^a-zA-Z0-9] ]]; then
    echo "Table name cannot start with symbols!"
else
    # Create table file and metadata file
    touch "$TBName"
    TBNameMD="${TBName}MD"
    touch "$TBNameMD"

    # Prompt for the number of columns
    while true; do
        read -p "Enter Number of Columns: " Num_columns
        if ! [[ "$Num_columns" =~ ^[0-9]+$ ]]; then
            echo "Invalid Number of columns!"
        else
            break
        fi
    done

    # Loop to check column name, column type, and column condition
    pk_flag=false
    metadata=""
    for ((i=1; i<=Num_columns; i++)); do
        while true; do
            read -p "Enter name of column $i: " column_name
            if ! [[ "$column_name" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
                echo "Invalid column name!"
            elif [[ "$column_name" == *" "* ]]; then
                echo "Column name cannot have spaces!"
            elif [[ "$column_name" == "" ]]; then
                echo "Column name cannot be empty!"
            else
                break
            fi
        done

        metadata+="$column_name"

        while true; do
            read -p "Enter Column DataType (int/string): " column_type
            if [[ "$column_type" == "int" || "$column_type" == "string" ]]; then
                column_type="${column_type,,}"
                break
            else
                echo "Invalid Data Type!"
            fi
        done
        metadata+=":$column_type"

        if [ "$pk_flag" == false ]; then
            while true; do
                read -p "Is it a primary key? (Y/N): " column_cond
                if [[ "$column_cond" =~ ^[Yy]$ ]]; then
                    metadata+=":P"
                    pk_flag=true
                    break
                elif [[ "$column_cond" =~ ^[Nn]$ ]]; then
                    metadata+=":N"
                    break
                else
                    echo "Invalid input!"
                fi
            done
        else
            metadata+=":N"
        fi

        # Add line break except for the last column
        if [ "$i" -lt "$Num_columns" ]; then
            metadata+="\n"
        fi
    done

    # Check if there's a primary key set
    if [ "$pk_flag" == false ]; then
        echo "Warning: No primary key specified for the table."
    fi

    # Write the metadata to the metadata file
    echo -e "$metadata" > "$TBNameMD"
    echo "Table $TBName with metadata $TBNameMD created successfully."
fi

  