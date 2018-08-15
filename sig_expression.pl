=pod
this script is write for get the expression level 

##gene_symbol   classA  classB  classC  ##logFC
=cut

#!/usr/bin/perl
use strict;
use warnings;

my $A_file = shift @ARGV ;
my $B_file = shift @ARGV;
my $tmp_file =shift;
#my $C_file;

open FHA,"$A_file",or die "can not open";
open OUT,">$tmp_file",or die "can not open";

my %hasha;

while (<FHA>){
next if /EnsemblGene_GeneSymbol/;
chomp;
        my ($id,$loga)=split(/\s/);
         $hasha{$id}=$loga;  #id--log
}
close FHA;

open FHB,"$B_file",or die "can not open";
#next if /EnsemblGene_GeneSymbol/;
        while (<FHB>){
                chomp;
        my ($id,$logb) = (split /\s/);
        if (exists $hasha{$id}){
        print OUT "$id\t$hasha{$id}\t$logb\n";}
                }
close FHB;
