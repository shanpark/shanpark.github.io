#! /bin/bash

cd ../langs
date "+%Y%m%d%H%M%S" > version.txt

ls -1 -d */ | cut -f1 -d'/' | cut -f2 -d'.' > list.txt
echo >> list.txt
ls -1 -d */ | cut -f1 -d'/' >> list.txt
