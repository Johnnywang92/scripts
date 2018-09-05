#!/usr/bin/perl
use warnings;
use strict;

my $group=shift;
#my $sgfile=shift;
my $outfile=shift;
#my $tmpfile=shift;

open Gen, "$group" || die "can not open$!";
open SG,"/onc/home/wang_yifan0102/05.database/00.Gene_info/Mus_musculus.gene_info";
open Out,">$outfile";
open Tmp,">$tmpfile";
#my %hash;
my $num;
my $gene1;
my $gene2;
my $line;
my $Synonyms;
my %test_hash;
my $test_hash;

while (<Gen>) {
        chomp;
        my @inf1 = split /\s+/;
        $num = $inf1[0];
        $gene1 = $inf1[1];
        $test_hash->{$gene1}->{num} = $num;
        $test_hash->{$gene1}->{search} = 0;
}

while (<SG>){
        chomp;
        my @inf2 = split /\t/;
        $gene2 = $inf2[2];
        $Synonyms = $inf2[4];
 if(exists($test_hash->{$gene2})){

        $test_hash->{$gene1}->{search} = 1;
        print Out "$gene2\n";
#        next;
 }
my @Synonyms = split (/|/,$Synonyms);
foreach my $syno (@Synonyms){
        if(defined $test_hash->{$syno}){
                $test_hash->{$syno}->{search} = 1;
                print Out "$gene2\n";
                }
        }
}
