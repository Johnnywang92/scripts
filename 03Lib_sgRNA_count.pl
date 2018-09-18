#!/usr/bin/perl
use warnings;
use strict;

my $library=shift;
my $fafile=shift;
my $outfile=shift;

open Lib, "$library";
open FA,"$fafile";
open Out,">$outfile";

my $name;
my @seq;
my $seq;
my $count;
my @line;
my @count;

while (<Lib>){
chomp;
my @info=split /\t/;
        $name=$info[0];
        $seq=$info[1];
        push @seq,$seq;
}
#close Lib;
#print Out "@info\n";

while (@line = <FA>){
#chomp;
#my @inf=split /\t/;
                foreach $seq (@seq){
                $count = grep /$seq/i, @line;
                        #print Out "$seq\t$count\n";
                push @count,$count;
                        print Out "$seq\t$count\n";
                                        }
                        #print Out "$seq\t$count\n";
}
