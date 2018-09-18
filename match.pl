#!/usr/bin/perl -w
use strict;
my $filename=$ARGV[0];
my %annot=();
open(ANN,"$filename") or die $!;
while(<ANN>){
chomp($_);
		my @record=split(/\t/);
		$annot{$record[1]}="$record[0]\t$record[1]";
	}

close ANN;

my $blast_file=$ARGV[1];
my $total_info='';
open(BLAST,"$blast_file") or die $!;
while(<BLAST>){
	chomp($_);
	my @record=split(/,/);
	
	$total_info ="$_\t$annot{$record[1]}\n";

	
	}
close BLAST;

open(OUT,">results.txt");
print OUT $total_info;
close OUT;

exit;
