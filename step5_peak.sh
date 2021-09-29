#!/bin/bash -
list="DNBseq"
echo "sh *.sh chr sort.bed"
bed=$list/bed/$2
#mkdir $deb
chr=$1
peak="${chr}_discontinuity"
grep "^$chr[^0-9]" $bed > chr.bed
awk '{print $3}' chr.bed |sort -|uniq -c - |sort -r - > end_n.txt
awk '{print $2}' chr.bed |sort -|uniq -c - |sort -r - > start_n.txt
#cat Xs_starts.txt Xs_ends.txt >Xs_start_end.txt
#sort Xs_start_end.txt |uniq -d -|sort -n ->Xs_peak.txt
perl peak.pl end_n.txt >end
perl peak.pl start_n.txt >start
cat start |while read line;do echo $(($line-1)); done >start_1
cat end |while read line;do echo $(($line+1)); done >end_1 
cat start_1 end |awk '{print $1}' - |sort -|uniq -d -|sort -n|while read line;do echo $line-$(($line+1)); done >start_1_end
cat start end_1 |awk '{print $1}' - |sort -|uniq -d -|sort -n|while read line;do echo $(($line-1))-$line; done >start_end_1
#cat start_1 end |awk '{print $1}' - |sort -|uniq -d -|sort -n > start_1_end
#cat start end_1 |awk '{print $1}' - |sort -|uniq -d -|sort -n > start_end_1
cat start_1_end start_end_1|while read line;do echo $chr $line;done |sort -u - |sort -n - >./$peak
