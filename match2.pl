#!/usr/bin/perl -w   #######找出两个一样的######
use strict;
my $filename=$ARGV[0];
my %annot=();
open(ANN,"$filename") or die $!;
while(<ANN>){
chomp($_);
		my @record=split(/\t/);
		$annot{$record[1]}="$_";
	}

close ANN;

my $blast_file=$ARGV[1];
my $total_info='';
open(BLAST,"$blast_file") or die $!;
while(<BLAST>){
	chomp($_);
	my @record=split(/\t/);
		if(exists $annot{$record[1]}){
			$total_info.="$record[1]\t$_\n";
		}
		#	else{$total_info.="$record[1]\tNA\n"
		#	}
	
	}
close BLAST;

open(OUT,">results.txt");
print OUT $total_info;
close OUT;

exit;
