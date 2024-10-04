while read day numb month time timezone year linesfound filename
do
echo -e "${day}\t${timezone}\t${linesfound}"
done < howmanylines.txt
