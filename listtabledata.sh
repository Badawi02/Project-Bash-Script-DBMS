#!/bin/bash

while [ true ]; do
    read -p "Enter the table name : " tblname

    if [[ -f ./databases/$1/$tblname ]]; then
        echo "-----------------------------"
        awk 'BEGIN{FS=":"}{ if(NR==1) {print $0}}' ./databases/$1/$tblname
        echo "-----------------------------"
        awk 'BEGIN{FS=":"}{ if(NR>1) {print $0}}' ./databases/$1/$tblname
        echo "-----------------------------"
        . ./connectdb.sh
    else
        echo ">>> Table doesn't exist <<<"
        select choice in 'List new Table?' 'Go back to table menu'; do
            case $REPLY in
            1) break ;;
            2) . ./connectdb.sh $1 ;;
            *) echo " invalid choice, pick again please" ;;
            esac
        done

    fi
done
