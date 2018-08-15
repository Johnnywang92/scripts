#!usr/bin/perl -w
use strict;
use File::Basename;
die "Usage:perl $0 <a.txt><b.txt>\n" if @ARGV!=2;

my ($p,$q)=@ARGV;
open IN1,$p||die;
open IN2,$q||die;

chomp (my @p=<IN1>);
chomp (my @q=<IN2>);
close IN1;
close IN2;

my $p = map{$_,1} @p;
my $q = map{$_,1} @q;

my @inter = grep{$p{$_}} @q;
my @merge = map{$_,1} @p,@q;
my @merge = keys %merge;
my @q_u = grep {!$p{$_}} @merge;
my @p_u = grep {!$q{$_}} @merge;
my $p_name=basename$p;
my $q_name=basename$q;
open OUT1,">",$p_name.".uniq.txt";
print OUT1 "$_\n" foreach sort{$a cmp $b}@p_u;
close OUT1;
open OUT2,">",$q_name.".uniq.txt";
print OUT2 "$_\n" foreach sort{$a cmp $b}@q_u;
close OUT2;
open OUT3,">","${p_name}_$q_name.inter.txt";
print OUT3 "$_\n" foreach sort{$a cmp $b}@inter;
close OUT3;
open OUT4,">","${p_name}_$q_name.merge.txt";
print OUT4 "$_\n" foreach sort{$a cmp $b}@merge;
close OUT4;
