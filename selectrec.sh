#!/bin/bash

while [ true ]; do
    read -p "Enter the table name : " name

    while [ true ]; do
        FILE=./databases/$1/$name
        if [ -f $FILE ]; then

            while [ true ]; do
                read -p "Please enter ColumnName : " coln

                FIELDN=$(awk 'BEGIN{FS=":"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)
                if [[ -z $FIELDN ]]; then
                    echo '>>> column name not found <<<'
                    select choice in 'Select new Column ?' 'Go back to table menu'; do
                        case $REPLY in
                        1) break ;;
                        2) . ./connectdb.sh $1 ;;
                        *) echo ">>> invalid choice, pick again please <<<" ;;
                        esac
                    done
                
                else
                    while [ true ]; do

                        read -p "Select column value requird : " colv

                        while [[ -z $colv ]]; do
                            read -p "You cant search with null value, select col value requird : " colv
                        done
                        matching=$(awk 'BEGIN{FS=":"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") print $0}' ./databases/$1/$name)
                        if [[ ! -z $matching ]]; then
                            echo "Records :"
                            echo "----------"
                            awk 'BEGIN{FS=":"}{ if(NR==1) {print $0}}' ./databases/$1/$name
                            echo "-----------------------------"
                            awk 'BEGIN{FS=":"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print $0}}' ./databases/$1/$name
                            echo "-----------------------------"
                            select choice in 'Select new record?' 'Go back to table menu'; do
                                case $REPLY in
                                1) . ./selectrec.sh $1 ;;
                                2) . ./connectdb.sh $1 ;;
                                *) echo ">>> invalid choice, pick again please <<<" ;;
                                esac
                            done
                        else
                            echo " >>> Not match with ( $colv ) <<<"
                            select choice in 'Enter new column value ?' 'Go back to table menu'; do
                                case $REPLY in
                                1) break ;;
                                2) . ./connectdb.sh $1 ;;
                                *) echo ">>> invalid choice, pick again please <<<" ;;
                                esac
                            done
                        fi
                    done
                fi
            done

        else
            echo " >>> This table doesnt exist <<<"
            select choice in 'Select new table ?' 'go back to table menu'; do
                case $REPLY in
                1) break ;;
                2) . ./connectdb.sh $1 ;;
                *) echo " invalid choice, pick again please" ;;
                esac
            done
            break
        fi
    done
done
