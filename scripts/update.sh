#! /bin/bash

cd ../langs
date "+%Y%m%d%H%M%S" > version.txt

ls -1 -d */ | cut -f1 -d'/' > list.txt
echo >> list.txt
ls -1 -d */ | cut -f1 -d'/' | cut -f2 -d'.' >> list.txt

while read dir; do

if [ -z "$dir" ]
then
    break;
fi

cd $dir

ls -1 *.md | cut -f1 -d'.' > list.txt

cd ..

echo [$dir]

done < list.txt