!/bin/bash

if [ ! -d DataBases ]; then
mkdir Databases
fi
cd DataBases

    select option in CreateDB ListDB ConnectDB DropDB Exit
    do
        if [ -n "$option" ]; then
            case $option in
                "CreateDB") ../bash_project/CreateDB.sh
                    ;;
                "ListDB") ../bash_project/ListDB.sh
                    ;;
                "ConnectDB") ../bash_project/ConnectDB.sh
                    ;;
                "DropDB") ../bash_project/DropDB.sh
                    ;;
                "Exit") break
                    ;;
                *) echo "Invalid Option"
                    ;;
            esac
        else
            echo "Invalid Option"
        fi
    done

Main

