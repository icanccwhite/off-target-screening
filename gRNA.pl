#!/usr/bin/perl -w
#use strict;


#$inpeak = @ARGV;
open(FNA, "Homo_data/GRCh38.p13.genome.fa")or die "can't open the fasta:$!\n";
print "The file fasta has been opened.\n";
my ($id, %seq);
my $origin=$/;
$/=">";

while(my $line=<FNA>){
	if($line=~/^chr(.*?)\s.*?\n(.*?)$/xs){
		$id = $1;
		$seq{$id} = $2;
		$seq{$id} =~ s/[\n\r]*//g;
		#print "$line\n";
		#print "$id:$seq{$id}\n";
	}else{
		next;
	}
}
close FNA;
$/=$origin;

open(IN, "/dellfsqd2/ST_LBI/USER/zhouxiaoyu/DNBseq/peak/501/bed.cut")or die "can't open the file:$!\n";
print "bed.cut opened!\n";
my ($chr, $before, %query, %gRNA);
while (<IN>){
        chomp;
        my @t=split /\s+/;
        $chr = $t[0];
        $before = $t[1];
        my $q1 = $before - 6;
        my $q2 = $before + 5;
	#print "$chr:$seq{$chr}\n";
	$query{$chr} = substr($seq{$chr}, $q1, $q2);
        if ($query{$chr} =~ /[(GG)|(CC)]/i){
        	my $g1 = $before - 20;
        	my $g2 = $before + 19;
        	$gRNA{$before} = substr($seq{$chr}, $g1, $g2);
        	$len = length($gRNA{$before});
        	print ">chr$chr:$g1-$g2|chr$chr:$before|\n";
        	#print OUT "$gRNA{$before}\n";
        	print "$len\n";
        }else{
        	next;
        }
        #print "@t\t\n";
}
close IN;
