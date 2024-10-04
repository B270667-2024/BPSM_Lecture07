#!/bin/bash
while read myfilename
do
echo -e "Processing ${myfilename}..."
linesinfile=$(wc -l ${myfilename} | cut -d ' ' -f1)
echo -e "\thas ${linesinfile} lines in it"
done <  myfiles.list
