#!/bin/bash
read -p "Please Enter Database Name to Delete: " DBName
            if [ -d "$DBName" ]; then
                rm -r "$DBName"
                echo "Database $DBName has been deleted."
            else
                echo "Database $DBName does not exist."
            fi