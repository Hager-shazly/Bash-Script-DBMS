#!/bin/bash
read -p "Please Enter Table Name to Drop: " TBName
            if [ -f "$TBName" ]; then
                rm "$TBName" "${TBName}MD"
                echo "Table $TBName and its metadata were deleted."
            else
                echo "Table $TBName does not exist."
            fi
            