while read myfilename
do
echo -e "Processing ${myfilename}..."
wc_lines=$(wc -l ${myfilename})
now=$(date)
echo -e "${now} \t ${wc_lines}" >> howmanylines.txt
linesinfile=$(wc -l ${myfilename} | cut -d ' ' -f1)
echo -e "\thas ${linesinfile} lines in it"
done < myfiles.list
