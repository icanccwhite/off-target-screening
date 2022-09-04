#!/usr/bin/perl -w
###################################
# Author: Xiaoyu Zhou
# Email:  xyzh@biomed.au.dk
###################################

#use strict;

#my $inpeak = @ARGV;
$inpeak = "DNBseq/peak/501/bed.cut";
open(IN, $inpeak)or die "can't open the file:$!\n";
print "The file bed.cut has been opened.\n";
my ($key, @peak, %unalign, %left, %right, %cut_A, $cut_B);
while (<IN>){
        chomp;
        my @t = split /\s+/;
        my $chr =  $t[0];
        my $before = $t[1];
        my $after = $t[2];
        $key = "$chr\:$after";
        $left{$key} = $after - 149;
        $right{$key} = $after + 148;
        push @{$peak{$chr}}, $after;
        $unalign{$key} = 0;
        $cut_A{$key} = 0;
        $cut_B{$key} = 0;
        #print "@t\t\n";
}
close IN;

my @chr = (1..22, X, Y);
my @sort_peak;
foreach (@chr){
		@{$sort_peak{$_}} = sort { $a <=> $b } @{$peak{$_}};
}

open(IN, "./V300046125_L04_501_2.sort.bed")or die "can't open the file:$!\n";
my ($chr, $start, $end);
while (<IN>){
        chomp;
        my @t=split /\s+/;
        $chr = $t[0];
        $start = $t[1];
        $end = $t[2];
	foreach my $pos(@{$sort_peak{$chr}}){
		#print "$chr\t$_\n";
		$key = "$chr\:$pos";
		if ($start eq $pos){
			$cut_A{$key} += 1;
		}elsif ($end eq $pos){
			$cut_B{$key} += 1;
		}elsif (($start >= $left{$key})&&($end <= $right{$key})){
			$unalign{$key} += 1;
        	}else{
			next;
		}
	}
}
close IN;

open (OUT, '>', "DNBseq/peak/501/reads.txt");
print OUT "chr\tgRNA_st\tgRNA_end\tcut\tpos\tunalign\talign_before\talign_after\n";

foreach my $chrom(@chr){
	foreach my $pos (@{$sort_peak{$chrom}}){
		my $key = "$chrom\:$pos";
		my $pos_1 = $pos - 1;
		my $g1 = $pos - 30;
		my $g2 = $pos + 30;
		print OUT "$chrom\t$g1\t$g2\t$pos_1\t$pos\t$unalign{$key}\|$cut_B{$key}\|$cut_A{$key}\n";
	}
}
close OUT;
exit;

