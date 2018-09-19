#!/usr/bin/perl -w
use Getopt::Long;
my $help;
my $infile="";
my $outfile="";
my $oddlenfile="";

GetOptions(
	"help|h"	=> \&USAGE,
	"infile:s"	=> \$infile,
	"outfile:s"	=> \$outfile,
	"oddlenfile:s"	=> \$oddlenfile,
);

open IN,"$infile"||die;
open OUT,">$outfile"||die;
open ODD,">$oddlenfile"||die;

my $i=0;
my $seqID='';
my $sequence='';
my $len_S=0;
my $len_Q=0;
my $mark='';
my $qual='';

while(<IN>){
	chomp;
	if($i%4 == 0){
	$seqID=$_;}
		if($i%4 == 1){
		$sequence=$_;
		$len_S=length($sequence);}
			if($i%4 == 2){
			$mark=$_;}
				if($i%4 == 3){
				$qual=$_;
				$len_Q=length($qual);
					if($len_S ==$len_Q){
						print OUT "$seqID\n$sequence\n$mark\n$qual\n";} else {
							print ODD "$seqID\n$sequence\n$mark\n$qual\n";}
				}
	$i=$i+1			
}

sub USAGE{
	my $usage=<<"USAGE";
Program: fa_filter.pl
Date: 2018-07-19
Usage:
		-infile		<fastq format> infile 
		-outfile	<fastq format> outfile
		-oddlenfile	<fastq format> oddlenfile 
		 -h          help
Example1: perl thir_test.pl -infile data.fastq -outfile out.fastq -oddlenfile odd.fastq
Example2: perl thir_test.pl -h
USAGE
	print $usage;
	exit;
}
