#!/usr/bin/bash
rm -f *.exercise.out
# Initial variable values at start
goodlines=$(grep -v "#" ${inputfile} | wc -l | cut -d ' ' -f1)
unset IFS
unset dataline
shortHSP=0; 
hspcounter=0;
echo -e "We have ${goodlines} data lines for processing...\n"
group1cut=150
group2cut=250
group3cut=350
outfile1="HSPscore.${group1cut}.exercise.out"
outfile2="HSPscore.${group2cut}.exercise.out"
outfile3="HSPscore.${group3cut}.exercise.out"
outfile4="HSPscore.morethan.${group3cut}.exercise.out"
rm -f ${outfile1} ${outfile2} ${outfile3} ${outfile4}
while read wholeline
do
# echo "Line is ${wholeline}"
if test ${wholeline:0:1} != "#"
 then
 dataline=$((dataline+1))
 # echo "Line ${dataline} starts with ${wholeline:0:1}"
read Q_acc S_acc pc_identity alignment_length mismatches gap_opens Q_start Q_end S_start S_end evalue bitscore <<< ${wholeline}
bitscore=$(printf "%.0f\n" ${bitscore})
echo -e "${dataline}\t${Q_acc}\t${S_acc}" >> Subject_accessions.exercise.out
echo -e "${dataline}\t${alignment_length}\t${pc_identity}" >> al_leng_pcID.exercise.out
if test ${alignment_length} -lt 100 && test ${mismatches} -gt 20
 then
 echo -e "${dataline}\tHSP shorter than 100aa, more \
       than 20 mismatches:\t${alignment_length}\t${mismatches}"
fi
if test ${mismatches} -lt 20 
 then
 hspcounter=$((hspcounter+1))
 if test ${hspcounter} -le 20
  then
  hsp_array+=${wholeline}
  echo -e "${dataline}\t${hspcounter}\t${wholeline}" >> Fewer.than20MM.exercise.out
 fi
fi
if test ${alignment_length} -lt 100 
 then
 shortHSP=$((shortHSP+1))
fi

if test ${dataline} -le 10
 then
 echo -e "${dataline}\t${wholeline}" >> Top10.HSPs.exercise.out
fi

if [[ ${S_acc} == *"AEI"* ]]; then
 echo -e "${dataline}\t${S_acc} contains AEI: \
    Subject starts at ${S_start}, Query starts at ${Q_start}" \
    >> AEIinSubjectAcc.starts.exercise.out 
fi     

if test ${S_acc} == ${pre_acc}  
 then
 dupecount=$((dupecount+1))
 if [[ dupecount == 1 ]]; then
  dupS_acc=${S_acc}
 fi
 
 if [[ $dupS_acc == *${S_acc}* ]]; then 
  echo ""
  else
  dupS_acc+=(${S_acc})
 fi  

fi    
pre_acc=${S_acc}

MMpercent=$((100*${mismatches}/${alignment_length}))
echo -e "${dataline}\t${alignment_length}\t${mismatches}\t${MMpercent}" \
   >> Mismatchpercent.exercise.out
   
   scorebin=1
if [ ${bitscore} -gt ${group3cut} ]; then 
     scorebin=4
fi
if [ ${bitscore} -le ${group3cut} ] && [ ${bitscore} -gt ${group2cut} ]; then 
     scorebin=3
fi
if [ ${bitscore} -le ${group2cut} ] && [ ${bitscore} -gt ${group1cut} ]; then 
     scorebin=2
fi

scoregroupdetails=$(echo -e "${dataline}\t${Q_acc}\t${S_acc}\t${bitscore}")
case $scorebin in
  4) 
    echo -e "${scoregroupdetails}" >> ${outfile4}
    ;;
  3) 
    echo -e "${scoregroupdetails}" >> ${outfile3}
    ;;
  2) 
    echo -e "${scoregroupdetails}" >> ${outfile2}
    ;;
  1) 
    echo -e "${scoregroupdetails}" >> ${outfile1}
    ;;
esac

if test ${dataline} -eq ${goodlines}
 then
 echo -e "\n\nENDBLOCK\n\nThere were ${shortHSP} HSPs shorter than 100 amino acids"
 echo -e "There were ${#dupS_acc[@]} Subjects with multiple HSPs"
fi
fi  # was not a commented line in the blast data



