###################################
# Author: Xiaoyu Zhou
# Email:  xyzh@biomed.au.dk
###################################

awk '{print $10}' filtered_gencode.gtf|sed "s/\.[0-9]\+//g" - >new.gtf 
/share/app/bedtools/bin/bedtools bamtobed -i subbam/5.bam >5.bed
sort -k1,1 -k2,2n 5.bed > 5.sort.bed
/share/app/bedtools/bin/bedtools map -s -c 3 -o collapse -a hg38.gene.gff -b 5.sort.bed >end.anno
awk '{print $(NF)}' end.anno | paste 5.anno - >5_all.anno
