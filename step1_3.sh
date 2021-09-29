#!/bin/bash -
list="DNBseq/removePCR"
DNB="USER/DNBseq"
        for file in `ls $list`
        do
                #echo $dir
                name=`basename $file`
                #echo `basename $file`
                if [ `echo $name | grep -e _2.clean.uniq.fastq` ];then
                part="${name%_2.clean.uniq.fastq}"
                #fq1="${part}_1.clean.uniq.fastq"
                fq2="${part}_2.clean.uniq.fastq"
                #fq2=$part
                echo $part
                reads="${part}_r2" 
                bed="${part}_2.sortn.bed"
                echo $reads
                else
                        echo "$name isn't fq2."
                fi
                if [ -f $list"/"$fq2 ]
                then
                        sam="${name}_2.clean.uniq.sam"
                        bam="${part}_2.clean.uniq_sort.bam"
                        bowtie2-2.2.5/bowtie2 -p 8 -x database/hg38-bowtie/hg38 -U $list/$fq2 -S ./sam/$sam`
                        `samtools sort -l 9 -m 10G -o ./bam/$bam -@ 8 ./sam/$sam`
                        `macs2 callpeak -t ./bam/$bam -n $reads -g hs -f BAM --nomodel -B`
                        bedtools/bin/bedtools bamtobed -i $DNB/bam/$bam|sort -k1,1 -k2,2n - > $DNB/bed/$bed
                        echo "$fq1 $fq2" >> ./step4.txt
                        #`date` >> ./tmp.txt
                else
                        echo "The $fq2 isn't exist."            
                fi
        done
        #`multiqc ./*.zip`
