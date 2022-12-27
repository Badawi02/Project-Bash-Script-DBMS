#!/bin/bash

shopt -s extglob
export LC_CoLLATE=C

read -p "Table Name: " tblname

if  [[ ! -f ./databases/$1/$tblname ]]; then
  echo ">>> Table $tblname isn't existed <<<"
  select x in "insert another Table" "go to table menu"; do
    case $REPLY in
    1) . ./insertintotable.sh $1 ;;
    2) . ./connectdb.sh $1 ;;
    *) echo"invalid choice pick again " ;;
    esac
  done
fi

coln=$(awk 'END{print NR}' ./databases/$1/.$tblname)
sep=":"
lsep="\n"

for ((i = 2; i <= $coln; i++)); do

  colname=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' ./databases/$1/.$tblname)
  coltype=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' ./databases/$1/.$tblname)
  colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./databases/$1/.$tblname)

  read -p "$colname ($coltype) = " data

    if [[ $coltype == "int" ]]; then
      while [ true ]; do
        case $data in
          +([0-9]))
            if [[ "$colKey" == "PK" ]]; then
              
              duplicated=0
              while [[ true ]]; do
                  duplicated=$(awk 'BEGIN{FS=":"} { if ('$data'==$(('$i'-1))) {print '$data';exit} }' ./databases/$1/$tblname)
                  if [[ -z $duplicated ]];then
                    duplicated=0
                  fi
                  if ! [[ $duplicated -eq 0 ]]; then
                    echo ">>> Error! PK already exists <<<"
                    read -p "Enter unique Primary key $colname (int) = " data
                    duplicated=0
                    continue 2
                  else
                    break
                  fi
              done

            fi
            #######
            break
            ;;
          *)
            read -p "Enter valid Value pls, $colname (int)= " data
            ;;
        esac
      done
    fi


    if [[ $coltype == "string" ]]; then
      while true; do
        case $data in
          +([A-Za-z-_]))
            if [[ "$colKey" == "PK" ]]; then
              duplicated=0
              while [[ true ]]; do
                  duplicated=$(awk 'BEGIN{FS=":"} { if ('$data'==$(('$i'-1))) {print '$data';exit} }' ./databases/$1/$tblname)
                  if [[ -z $duplicated ]];then
                    duplicated=0
                  fi
                  if ! [[ $duplicated = '0' ]]; then
                    echo ">>> Error! PK already exists <<<"
                    read -p "Enter unique Primary key $colname (string) = " data
                    duplicated=0
                    continue 2
                  else
                    break
                  fi
              done
            fi
            #######
            break
            ;;
          *)
            read -p "Enter valid Value pls, $colname (string)= " data
            ;;
        esac
      done
    fi

    #inserting rows into table
    if [[ $i == $coln ]]; then
      row=$row$data
    else
      row=$row$data$sep
    fi
done
# end of for loop!

echo -e $row >>./databases/$1/$tblname
if [[ $? == 0 ]]; then # check on the process of entering rows
  echo " >>> Data Inserted Successfully <<<"
else
  echo "Error Inserting Data into Table $tblname"
fi
row=""

select x in "insert new data" "go to table menu"; do
  case $REPLY in
  1) . ./insertintotable.sh $1 ;;
  2) . ./connectdb.sh $1 ;;
  *) echo "invalid choice pick again" ;;
  esac
done















              # if [[ $data = '0' ]];then
              #   echo "PK can't be zero"
              #   read -p "Enter anthor value : " data
              #   continue
              # fi