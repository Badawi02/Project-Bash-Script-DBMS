#!/bin/bash

shopt -s extglob
export LC_COLLATE=C

while [ true ]; do

  read -p "Enter table name: " tblname
  
  if [[ $tblname = +([a-zA-Z_-]) ]]; then
    if [[ -f ./databases/$1/$tblname ]]; then
      read -p ">>> Table already exists , Choose another name or back to main table by write (back) <<< : " ok
      if [[ $ok = 'back' && ! -z $ok ]]; then
        . ./connectdb.sh $1
      else
        continue
      fi
    fi
  else
    continue
  fi

  while true; do
    read -p "How many columns in your table? " coln
    if [[ $coln = +([0-9]) ]]; then
      if [ $coln -eq 0 ]; then
        continue
      fi
      break
    fi
  done

  counter=1
  PK=""
  sep=":"
  lsep="\n"
  hdata="ColName"$sep"Type"$sep"Null"$sep"key"
  temp=""

  while [ $counter -le $coln ]; do
    while [ true ]; do
      echo "Column No $counter name:"
      read colname
      if [[ $colname = +([a-zA-Z_-]) ]]; then
        break
      fi
    done

    echo "Column No $counter Type:"
    select T in "int" "string"; do
      case $T in
      int)
        coltype="int"
        break
        ;;
      string)
        coltype="string"
        break
        ;;
      *) echo "invalid choice, pick again " ;;
      esac
    done

    echo "Column No $counter can be (Null):"
    select N in "yes" "no"; do
      case $N in
      yes)
        colnull="yes"
        break
        ;;
      no)
        colnull="no"
        break
        ;;
      *) echo "invalid choice, pick again " ;;
      esac
    done


    if [[ $PK == "" ]]; then
      echo "Make this col a PrimaryKey ? "
      select var in "yes" "no"; do
        case $var in
        yes)
          PK="PK"
          hdata+=$lsep$colname$sep$coltype$sep$colnull$sep$PK
          break
          ;;
        no)
          hdata+=$lsep$colname$sep$coltype$sep$colnull$sep""
          break
          ;;
        *) echo "Wrong Choice, pick again " ;;
        esac
      done
    else
      hdata+=$lsep$colname$sep$coltype$sep$colnull$sep""
    fi


    if [[ $counter == $coln ]]; then
      temp=$temp$colname
    else
      temp=$temp$colname$sep
    fi
    
    let counter++

  done



  echo -e $hdata >>./databases/$1/.$tblname

  echo $temp >>./databases/$1/$tblname


  if [[ $? == 0 ]]; then
    echo ">>> Table Created succesefully <<<"
    select x in "Create new table " "Go to table menu "; do
      case $REPLY in
      1) . ./CreateTable.sh $1 ;;
      2) . ./connectdb.sh $1 ;;
      *) echo "Invalid choice pick again " ;;
      esac
    done

  else

    echo "Error creating table "
    select x in "Try again " "go to table menu "; do
      case $REPLY in
      1) . ./CreateTable.sh $1 ;;
      2) . ./connectdb.sh $1 ;;
      *) echo "invalid choice pick again " ;;
      esac
    done
  fi

done
