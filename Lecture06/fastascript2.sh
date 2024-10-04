#list the subject accession for all HSPs
grep "NC" blastoutput2.out | awk -F'\t' '{print $2}'

#list the alignment length and percent ID for all HSPs
grep "NC" blastoutput2.out | awk -F'\t' '{print $3}{print $4}'

#show the HSPs with more than 20 mismatches
grep "NC" blastoutput2.out | awk -F'\t' '$5>20{print $5}'

#show the HSPs shorter than 100 amino acids and with more than 20 mismatches
grep "NC" blastoutput2.out | awk -F'\t' '$5 > 20 && $4 < 100 {print $4, $5}'

#list the first 20 HSPs that have fewer than 20 mismatches
grep "NC" blastoutput2.out | awk -F'\t' 'BEGIN {count = 0} $5 < 20 {if (count < 20) {print $4, $5; count++}}'

#how many HSPs are shorter than 100 amino acids?
grep "NC" blastoutput2.out | awk -F'\t' 'BEGIN {count = 0} {if($4 < 100) {print count;count++}}'

#list the top ten highest (best) HSPs.
grep "NC" blastoutput2.out | sort -k12,12nr | head -n 10

#list the start positions(q.start,q.start) of all matches where the HSP Subject accession includes the letters string "AEI"
cut -f2,7 blastoutput2.out| grep "AEI" | cut -f2

#how many subject sequences have more than one HSP?
cut -f2 blastoutput2.out | \ sort | \ uniq -c | \ awk '($1 > 1)' | \ wc -l

#cut -f2 blastoutput2.out | \ sort | \ uniq -c | \ awk '($1 > 1)' | \ wc -l
grep -v "#" blastoutput2.out | \ awk '{ HSP_mm_pc = ($5/$4) * 100 ; print HSP_mm_pc; }' | more
