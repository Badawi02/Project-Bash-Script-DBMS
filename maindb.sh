#!/bin/bash

PS3="please choose: "
echo "#############################"
echo "WELCOME TO OUR DBMS"
echo "#############################"

select choice in 'Create Database' 'List Database' 'Conncet to Database' 'Drop Database' 'Exit!'; do
    case $REPLY in
    1)
        . ./createdb.sh
        ;;
    2)
        . ./listdb.sh
        ;;s
    3)
        . ./connectdb.sh
        ;;
    4)
        . ./dropdb.sh
        ;;
    5)
        echo '>>> Hope to see you soon again <<<'
        echo ">>> Bye! <<<"
        exit
        ;;
    *)
        echo ">>> Invalid choice, pick again please <<<"
        ;;
    esac
done