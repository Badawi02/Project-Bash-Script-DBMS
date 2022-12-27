#!/bin/bash

while [ true ]; do
     read -p "Enter Table Name : " tName

     #echo $tName - $1
     if [[ -f ./databases/$1/$tName && ! -z $tName ]]; then
          rm -ir ./databases/$1/$tName
          if ! [[ -f ./databases/$1/$tName ]];then
               rm -r ./databases/$1/.$tName
               if [[ $? == 0 ]]; then
                    echo ">>> Table Dropped Successfully <<<"
                    select x in "Drop new table?" "Go to table menu"; do
                         case $REPLY in
                         1) . ./droptable.sh $1 ;;
                         2) . ./connectdb.sh $1 ;;
                         *) echo "invalid choice pick again" ;;
                         esac
                    done
               else
                    echo ">>> Error Dropping Table $tName <<<"
                    break
               fi
          else
               echo ">>> We didn't delete Table $tName  <<<"
               break
          fi
     else
          echo ">>> Table doesn't exist <<<"
          select x in "Try again?" "Go to table menu"; do
               case $REPLY in
               1) . ./droptable.sh $1 ;;
               2) . ./connectdb.sh $1 ;;
               *) echo "invalid choice pick again" ;;
               esac
          done
     fi
done

. ./connectdb.sh $1
