#!/bin/bash
read -p "Please Enter Database to Connect: " DBName
            if [ -d "$DBName" ]; then
                cd "$DBName"
                if [ $? -eq 0 ]; then
                    echo "Database $DBName is connected."
                else
                    echo "Failed to navigate to database $DBName."
                fi
            else
                echo "Database $DBName does not exist."
            fi