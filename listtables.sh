#!/bin/bash

if [[ `ls -l databases/$dbname | grep '^-' | wc -l 2> /dev/null` -eq 0 ]];then
    echo ">>> No Tables to List them <<<"
    . ./connectdb.sh
else
    echo "Tables :"
    echo "--------"
    ls -l databases/$dbname | grep '^-'
    echo "---------------------------------------------"
fi


select choice in "Go back to table menu" "Go back to main menu "; do
    case $REPLY in
        1) . ./connectdb.sh ;;
        2) . ./maindb.sh ;;
    esac
done