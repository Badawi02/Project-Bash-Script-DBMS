#!/bin/bash

shopt -s extglob
export LC_CoLLATE=C

while [ true ]; do
    read -p "Please enter the database name ( characters only ) : " name

    if [[ $name = +([a-zA-Z]) ]]; then
        while [ true ]; do
            if [ -d ./databases/$name ]; then
                read -p ">>> ($name) exists. Enter another name or back to main menu by write (back) : " ok
                if [[ $ok = 'back' && ! -z $ok ]]; then
                    . ./maindb.sh $1
                else
                    continue 2
                fi
            else
                mkdir -p databases/$name
                echo ">>> ( $name ) database created <<<"

                select choice in "Create new database " "Go back to main menu" "Exit"; do
                    case $REPLY in
                    1) . ./createdb.sh ;;
                    2) . ./maindb.sh ;;
                    3) exit ;;
                    esac
                done

            fi
        done
    fi
done