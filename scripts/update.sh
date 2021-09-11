#! /bin/bash

# 파일 버전 생성.
cd ../langs
date +%s > version.txt

# language list.txt 작성.
ls -1 -d */ | cut -f1 -d'/' > list.txt

while read dir; do

echo "Enter [$dir]"
cd $dir

ls -1 *.md | cut -f1 -d'.' > list.txt

echo "Leave [$dir]"
cd ..

done < list.txt