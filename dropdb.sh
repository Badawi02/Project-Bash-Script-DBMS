#!/bin/bash
if [ -d databases ]; then
    if [[ `ls -l databases | grep '^d' | wc -l 2> /dev/null` -eq 0 ]];then
        echo ">>> No databases to Delete it <<<"
        . ./maindb.sh
    fi
else
    echo ">>> No databases to Delete it <<<"
    select choice in "Go back to main menu " "Try again"; do
            case $REPLY in
            1) . ./maindb.sh ;;
            2) . ./dropdb.sh ;;
            esac
    done
fi

while [ true ]; do
    ls -l databases | grep '^d'
    echo "------------------------------------------------------"
    read -p "Enter the database name : " dbname

    if [[ -d ./databases/$dbname && ! -z $dbname ]]; then
        rm -ir ./databases/$dbname
        echo ">>> ( $dbname ) database Deleted ! <<<"
        select choice in "Go back to main menu" "Drop another database" "Exit"; do
            case $REPLY in
            1) . ./maindb.sh ;;
            2) . ./dropdb.sh ;;
            3) exit ;;
            esac
        done

    else
        echo ">>> ( $dbname ) database Doesn't exist <<<"
        select choice in "Go back to main menu " "Try again"; do
            case $REPLY in
            1) . ./maindb.sh ;;
            2) . ./dropdb.sh ;;
            esac
        done
    fi
done
