#!/bin/bash

shopt -s extglob
export LC_CoLLATE=C


while [ true ]; do
  read -p "Enter the table name : " tblname
  
  while [ true ]; do
    FILE=./databases/$1/$tblname
    if [ -f $FILE ]; then

      while true; do
        read -p "Please enter Column name : " coln

        FIELDN=$(awk 'BEGIN{FS=":"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$tblname)
        if [[ -z $FIELDN ]]; then
          echo '>>> invalid column name <<<'
          select choice in 'Select new Column ?' 'Go back to table menu'; do
            case $REPLY in
            1) break ;;
            2) . ./connectdb.sh $1 ;;
            *) echo ">>> invalid choice, pick again please <<<" ;;
            esac
          done

          break
        else
          while true; do
            read -p "select column value requird : " colv

            while [[ -z $colv ]]; do
              read -p "you cant search with null value, select col value requird : " colv
            done

            matching2=$(awk 'BEGIN{FS=":"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") print $0}' ./databases/$1/$tblname)
            if [[ ! -z $matching2 ]]; then

              read -p "Insert new value for the current column value: " NewV
              
              ####################### New value validation checking either its string or int also checking on pk as new value
              HN=$FIELDN+1

              coltype=$(awk 'BEGIN{FS=":"}{if(NR=='$HN'){print $2}}' ./databases/$1/.$tblname)
              colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$HN'){print $3}}' ./databases/$1/.$tblname)

              if [[ $coltype == "int" ]]; then
                while true; do
                  case $NewV in

                  +([0-9]))
                    if [[ "$colKey" == "PK" ]]; then
                      duplicated=0
                      while [[ true ]]; do
                        if [[ -z "$NewV" ]]; then
                          echo ">>> Error! PK can't be NULL ! <<<"
                          read -p "Enter valid Primary key : " NewV

                        else
                          duplicated=$(awk -F':' '{if('$NewV'==$('$HN'-1)) {print $('$HN'-1);exit}}' ./databases/$1/$tblname)
                          if ! [[ $duplicated -eq 0 ]]; then
                            echo ">>> Error!PK already exists <<<"
                            read -p "Enter unique Primary key : " NewV
                            duplicated=0
                          else
                            break
                          fi
                        fi
                      done
                    fi
                    break
                    ;;
                  *)
                    echo ">>> Error! Invalid data type! <<<"
                    read -p "enter valid data type (int)" NewV
                    ;;
                  esac
                done
              fi

              if [[ $coltype == "string" ]]; then
                while true; do
                  case $NewV in

                  +([A-Za-z-_]))
                    if [[ "$colKey" == "PK" ]]; then
                      duplicated=0
                      while [[ true ]]; do
                        if [[ -z "$NewV" ]]; then
                          echo ">>> Error! PK can't be NULL ! <<<"
                          read -p "Enter valid Primary key : " NewV

                        else
                          duplicated=$(awk -F':' '{if('$NewV'==$('$HN'-1)) {print $('$HN'-1);exit}}' ./databases/$1/$tblname)
                          if ! [[ $duplicated -eq 0 ]]; then
                            echo ">>> Error!PK already exists <<<"
                            read -p "Enter unique Primary key" NewV
                            duplicated=0
                          else
                            break
                          fi
                        fi
                      done
                    fi
                    break
                    ;;
                  *)
                    echo ">>> Error! Invalid data type! <<<"
                    read -p "enter valid data type (string) : " NewV
                    ;;
                  esac
                done
              fi


              ####################################################
              RECORDN=$(awk 'BEGIN{FS=":"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR;exit}}' ./databases/$1/$tblname)

              OldV=$(awk 'BEGIN{FS=":"}{if(NR=='$RECORDN'){for(i=1;i<=NF;i++){if(i=='$FIELDN') {print $i;exit }}}}' ./databases/$1/$tblname)

              sed -i ''$RECORDN's/'$OldV'/'$NewV'/g' ./databases/$1/$tblname

              echo ">>> Row Updated Successfully <<<"
              . ./connectdb.sh $1
            else
              echo "not match with $colv"
              select choice in 'Insert new column value ?' 'Go back to table menu'; do
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
      echo ">>> this table doesnt exist <<<"
      select choice in 'Update new table ?' 'Go back to table menu'; do
        case $REPLY in
        1) break ;;
        2) . ./connectdb.sh $1 ;;
        *) echo ">>> invalid choice, pick again please <<<" ;;
        esac
      done
      break
    fi
  done
done
