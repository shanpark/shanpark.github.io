#! /bin/bash

# 파일 버전 생성.
cd ../langs
date +%s > version.txt

# language list.txt 작성. path 먼저쓰고 한줄 띠고 name쓰고...
ls -1 -d */ | cut -f1 -d'/' > list.txt
echo >> list.txt
ls -1 -d */ | cut -f1 -d'/' | cut -f2 -d'-' >> list.txt

while read dir; do

if [ -z "$dir" ]
then
    break;
fi

echo "Enter [$dir]"
cd $dir

ls -1 *.md | cut -f1 -d'.' | cut -f2 -d'-' > list.txt

echo "Leave [$dir]"
cd ..

done < list.txt