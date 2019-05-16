#!/bin/bash
PROGRAM="lexparse"
OUTPUT="lexstats"
TESTFILE="in.c"
clear

if [ ! -e "$PROGRAM.l" ]; then
    echo -e "\n"
    read -p " Err [No *.l file]  Press any key [Exit]" DONE
    clear
    exit 0
fi


lex $PROGRAM.l

if [ ! -e "lex.yy.c" ]; then
    echo -e "\n"
    read -p " Err [No exe gen'd]  Press any key [Exit]" DONE
    clear
    exit 0
fi

make

chmod 700 ./$OUTPUT.exe

echo -e "\n"
read -p "     Press any key [Run .exe]" DONE

cat $TESTFILE | ./$OUTPUT.exe

echo -e "\n"
read -p "     Press any key [Done]" DONE


rm ./$OUTPUT.exe
rm ./lex.yy.c

clear
exit 1
