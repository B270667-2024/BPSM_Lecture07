#!/bin/bash

count=0
IFS=$'\t'
while read name email city birthday_day birthday_month birthday_year country
do
if test -z ${name} 
 then
 echo -e "X\tBlank line found"
 else
 if test ${country} == "country"
  then
  echo -e "X\tHeader line found"
  else
   count=$((count+1))
   echo -e "${count}\t${country}"
 fi  # a real country
fi   # a blank line
done <  example_people_data.tsv

count=0; IFS=$'\t';
while read name email city birthday_day birthday_month birthday_year country
do
if test -z ${name} || test ${country} == "country"
 then
  count=count;# a meaningless action, it does nothing useful
 else
 echo "outputfile1 will be ${country}.details";
 
 echo "outputfile2 will be ${country// /}.details" 
fi
done <  example_people_data.tsv | head -10

count=0; IFS=$'\t';
rm  -f *.details
while read name email city birthday_day birthday_month birthday_year country
do
if test -z ${name} || test ${country} == "country"
 then
 echo "Ignoring"
 else
 count=$((count+1));
 echo -e "${count}\t${name}\t$city\t${country}" >> ${country// /}.details 
fi
done < example_people_data.tsv


count=0; IFS=$'\t';
rm  -f *.details
while read name email city birthday_day birthday_month birthday_year country
do
if test -z ${name} || test ${country} == "country"
 then
 continue
 else
 count=$((count+1));

outputfile=${country// /}.younger.details
 if test ${birthday_year} -le 1980
   then 
   outputfile=${country// /}.older.details
 fi # birthday before 1980, so "older" person
echo -e "${count}\t${name}\t${birthday_year}\t${country}" >> ${outputfile} 
fi  
done <  example_people_data.tsv

count=0; IFS=$'\t';
month=10
outputfile="Month.$month.details"
rm  -f *.details
while read name email city birthday_day birthday_month birthday_year country
do
if test -z ${name} || test ${country} == "country"
 then
 echo "Ignoring"
 else
 count=$((count+1));
 
 if test ${birthday_month} -eq $month
   then 
   echo -e "${count}\t${name}\t${birthday_month}\t${country}" >> ${outputfile}
 fi # birthday month
fi  
done <  example_people_data.tsv

count=0; fnr=0; IFS=$'\t';
wantedcountry="Mozambique"
inputfile="example_people_data.tsv"
inputfilelength=$(wc -l ${inputfile} | cut -d ' ' -f1)
outputfile="Country.${wantedcounty}.details"

rm  -f *.details
unset my_array
declare -A my_array

while read name email city birthday_day birthday_month birthday_year country
do
fnr=$((fnr + 1))
# echo "Line number: ${fnr}"
if test -z ${name} || test ${country} == "country" 
 then
 echo "" > /dev/null
 else
 if test ${country} == ${wantedcounty}
   then
   count=$((count+1));
   my_array[${count}]="${fnr}\t${name}\t${country}"
   # echo -e "${my_array[${count}]}"
 fi
fi  
# End of the file
if test ${fnr} -eq ${inputfilelength}
 then
 echo -e "\n### Here are the end of file results for ${wantedcounty}:" > ${outputfile} 
 for i in "${my_array[@]}"; do echo -e "$i" >> ${outputfile}; done
 fi
done <  ${inputfile}











