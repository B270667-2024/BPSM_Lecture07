rm *.bn
cut -f1,12 blastoutput2.out | grep -v "#" |
while read bn1 bn2
do
bn2=$(printf %0.f ${bn2})
# Evaluation step
if test ${bn2} -ge 300
then
   echo "HSP bit score ${bn2} is truly excellent"
   echo -e "${bn1}\t${bn2}" >> good.blastn
else
   echo "HSP bit score ${bn2} is not excellent"
   echo -e "${bn1}\t${bn2}" >> bad.blastn
fi
done
