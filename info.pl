#!/usr/bin/perl
=head
        perl  vcf.filter.sample.pl -vcf vcf.file
=cut
#use strict;
#use warnings;
use Getopt::Long;

my @filter;

GetOptions(
    "vcf:s"=>\$vcf,         #$vcf is the vcf file

);

###########Read from the vcf file#################################
open IN1,"$vcf"|| die "$vcf can not open!";
open OUT1,">$vcf.marked"|| die "outputfile can not open!";

print OUT1 "CHROM\tPOS\tREF\tALT\tAC\tAF\tAN\tAF_eas\tHOM\tAF_popmax\n";

while(my $line=<IN1>){
    chomp($line);
    my $filter="";
    if($line=~/^##/){}
    elsif($line=~/^#CHROM/){
#        print OUT1 "CHROM\tPOS\tREF\tALT\tAC\tAF\tAN\tHOM\tAF_eas\tAF_popmax\n";                ###save title###
    }
    else{
        my @inf=split(/\s+/,$line);
        my @snpinf=@inf;
#       print $snpinf[7];

########### looking for mutation #########CHROM:0；POS:1；REF:3；ALT:4；        AC；AF；AN；nhomalt;AF_eas;AF_popmax;
#my $ac;
#my $af;
#my $an;
#
my @info;
#my $info;
my $info = $snpinf[7];
#$info =~ /AC=(.*?);.*AF=(.*?);.*AN=(.*?);.*nhomalt=(.*?);.*AF_eas=(.*?);.*AF_popmax=(.*?);/;

if ($info =~ /AC=/){
	$info =~ /AC=(.*?);/;
#	print "$1\n";
push @info, $1;
	}else{
#print "NA\n"
}

if ($info =~ /AF=/){
        $info =~ /AF=(.*?);/;
#        print "$1\n";
push @info,$1;
}else{
#print "NA\n"
}


if ($info =~ /AN=/){
        $info =~ /AN=(.*?);/;
#        print "$1\n";
push @info,$1;
}else{ }

if ($info =~ /nhomalt=/){
        $info =~ /nhomalt=(.*?);/;
#        print "$1\n";
push @info,$1;
}else{ }

if ($info =~ /AF_eas=/){
        $info =~ /AF_eas=(.*?);/;
#        print "$1\n";
push @info,$1;
}else{ }

if ($info =~ /AF_popmax=/){
        $info =~ /AF_popmax=(.*?);/;
#        print "$1\n";
push @info,$1;
}else{ }

#print "@info\n";

#print OUT1 "$snpinf[0]\t$snpinf[1]\t$snpinf[3]\t$snpinf[4]\t$1\t$2\t$3\t$4\t$5\t$6\n";
print OUT1 "$snpinf[0]\t$snpinf[1]\t$snpinf[3]\t$snpinf[4]\t$info[0]\t$info[1]\t$info[2]\t$info[4]\t$info[3]\t$info[5]\n";
    }
}
close IN1;
close OUT1;
