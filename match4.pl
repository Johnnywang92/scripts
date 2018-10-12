#!/usr/bin/perl -w   #######找出两个一样的######
use strict;
my $filename=$ARGV[0];
my $annot;
open(ANN,"$filename") or die $!;
while(<ANN>){
chomp($_);
                my @record=split(/\t/);
                $annot->{$record[0]}->{$record[2]}->{$record[3]}->{$record[6]} ="$_";
        }

close ANN;

my $blast_file=$ARGV[1];
my $total_info='';
open(BLAST,"$blast_file") or die $!;
while(<BLAST>){
        chomp($_);
        my @record=split(/\t/);
                if(exists $annot->{$record[0]}->{$record[2]}->{$record[3]}->{$record[5]}){
                        $total_info.="$record[0]\t$record[11]\t$record[2]\t$record[3]\t$record[3]\t$record[4]\t$record[5]\t$record[8]\t$record[9]\t$record[12]\t$record[7]\t$record[14]\t$record[15]\t$record[17]\n";
                }
                        else{$total_info.="$record[1]\tNA\n"
                        }

        }
close BLAST;

open(OUT,">results.txt");
print OUT $total_info;
close OUT;

exit;
