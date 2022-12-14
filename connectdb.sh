#!/bin/bash

while [ true ]; do
    if [[ $# == 0 ]]; then
        if [ -d databases ];then
            ls -l databases | grep '^d' 2>/dev/null
            echo "------------------------------------------------------"
            read -p "Enter the database name : " dbname
        else
            echo ">>> No Databases created <<<"
            select choice in "Try again" "Go back to main menu "; do
                case $REPLY in
                1) . ./connectdb.sh ;;
                2) . ./maindb.sh ;;
                esac
            done
        fi
    else
        dbname=$1
    fi

    if [[ -d ./databases/$dbname && ! -z $dbname ]]; then
        echo ">>> Current database is ( $dbname ) <<<"
        select choice in 'Create table' 'List tables' 'Insert into table' 'Drop table' 'Select from table' 'List table data' 'Update record' 'Delete from record' 'Choose another database' 'Go to main menu'; do
            case $REPLY in
            1)
                . ./CreateTable.sh $dbname
                ;;
            2)
                . ./listtables.sh $dbname
                ;;
            3)
                . ./insertintotable.sh $dbname
                ;;
            4)
                . ./droptable.sh $dbname
                ;;
            5)
                . ./selectrec.sh $dbname
                ;;
            6)
                . ./listtabledata.sh $dbname
                ;;
            7) . ./update.sh $dbname ;;
            8) . ./Delrec.sh $dbname ;;
            9)
                ./connectdb.sh
                ;;
            10)
                . ./maindb.sh
                ;;
            *) echo ">>> invalid choice, pick again please <<<" ;;
            esac
        done

    else
        echo ">>> ( $dbname ) database Doesn't exist <<<"

        select choice in "Try again" "Go back to main menu "; do
            case $REPLY in
            1) . ./connectdb.sh ;;
            2) . ./maindb.sh ;;
            esac
        done
    fi
done