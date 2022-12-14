#!/bin/bash

if [ -d databases ]; then
  if [[ `ls -l databases | grep '^d' | wc -l` -eq 0 ]];then
    echo ">>> No databases to be shown <<<"
  fi
  echo "Databases:"
  echo "-----------"
  ls -l databases | grep '^d'
  echo "------------------------------------------------------"
else
  echo ">>> No databases to be shown <<<"
fi

select choice in "Go back to main menu" "Exit"; do
  case $REPLY in
  1) . ./maindb.sh ;;
  2) exit ;;
  esac
done
