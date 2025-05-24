#!/bin/bash
read -p "Please Enter DataBase Name : " DBName
if [ -z "$DBName" ]; then
        echo "Please Enter Database Name"
elif ! [[ "$DBName" =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]; then
        echo "Invalid DataBase Name"
elif [ -d "$DBName" ]; then
        echo "This DataBase already exist"
else
        mkdir "$DBName"
        echo "DataBase Created Successfully"
fi


