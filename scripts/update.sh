#! /bin/bash

function genList {
    if [ -d $1 ] # directory만 수행한다.
    then
        echo "Enter [$1]"
        cd $1

        ls -1 -d *.dir *.md > list.txt 2> /dev/null

        echo "Leave [$1]"
        cd ..
    fi
}

# 파일 버전 생성.
cd ../cooks
date +%s > version.txt

# cook list.txt 작성.
ls -1 -d *.dir *.md > list.txt 2> /dev/null

while read dir; do

genList $dir

done < "list.txt"