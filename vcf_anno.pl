=pod

this script write for the database(wes_annotation_filter_1205update2.txt)file info extract
Models：
LU-01-1004
LU-01-1008
LU-01-1013
LU-01-1017
找出以上模型中EGFR的非同义突变信息，要包含（外显子信息，转录本信息和氨基酸信息）

=cut
#!/usr/bin/perl
#use strict;
use warnings;

my $VCF_file = shift @ARGV;
my $out_file = shift;

open FH1, "$VCF_file", or die "can not open it\n";
open OUT,">$out_file", or die "can not open it\n";
readline FH1;
#
my $Gene;
my $G1000;
my $Filter;
my $Modle_ID;
my $m = "LU-01-1004";
my $n = "EGFR";
my $i = "PASS";
#print OUT "$i\n";
while (<FH1>){
      my @info = split /\t/;
        #       chomp $info;
                $Modle_ID = $info[0];
                 $Filter = $info[6];
                 $G1000 = $info[8];
                 $Gene = $info[11];
                                        #print $Gene;
                 if(($Gene eq $n) && ($Modle_ID eq $m)){
                                print OUT "$info[0]\t$info[6]\t$info[8]\t$info[11]\t$info[-1]\n";}
                        #print OUT "$info[0]\t$info[6]\t$info[8]\t$info[11]\t$info[-1]\n";}
}
