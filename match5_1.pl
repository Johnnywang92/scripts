#!/usr/bin/perl -w   #######鎵惧嚭涓や釜涓€鏍风殑######
use strict;
use warnings;
my $filename=$ARGV[0];
my $annot;
my $annot1;
open(ANN,"$filename") or die $!;
while(<ANN>){
chomp($_);
        my @record=split(/\t/);
        if ($record[6] eq ""){
                $record[6] = "N";
}	#print "$record[6]\n";
	#print scalar(@record);
        $annot->{$record[0]}->{$record[2]}->{$record[3]}->{$record[6]} ="$_";
        $annot1->{$record[0]}->{$record[2]}->{$record[3]}->{$record[6]}->{exist}=0;
        
}
close ANN;
#__END__
my $blast_file=$ARGV[1];
my $total_info='';
my $error_info='';
open(BLAST,"$blast_file") or die $!;
while(<BLAST>){
        chomp($_);
        my @record=split(/\t/);
        if ($record[5] eq "-"){
                $record[5] = "N";
		#print "$record[5]\n"; 
}
                if(exists $annot->{$record[0]}->{$record[2]}->{$record[3]}->{$record[5]}){
	#		print "ok";
                        $total_info.="$record[0]\t$record[11]\t$record[2]\t$record[3]\t$record[3]\t$record[4]\t$record[5]\t$record[8]\t$record[9]\t$record[12]\t$record[7]\t$record[14]\t$record[15]\t$record[17]\n";
                        $annot1->{$record[0]}->{$record[2]}->{$record[3]}->{$record[5]}->{exist}=1;
        }
#               else{
#}
#                       $error_info.="$record[0]\t$record[2]\t$record[3]\t$record[5]\tNA\n";
#                       }
        }
close BLAST;
	foreach my $key1 (keys %{$annot1}){
 		foreach my $key2 (keys %{$annot1->{$key1}}){
			foreach my $key3(keys %{$annot1->{$key1}->{$key2}}){
				foreach my $key4(keys %{$annot1->{$key1}->{$key2}->{$key3}}){
						if($annot1->{$key1}->{$key2}->{$key3}->{$key4}->{exist} == 0){
							$error_info.="$key1\t$key2\t$key3\t$key4\n";
							open(ERR,">error.txt");
							print ERR $error_info;
									}		
								}		
							}
						}					
        				}

open(OUT,">results.txt");
#open(ERR,">error.txt");
print OUT $total_info;
#print ERR $error_info;
close OUT;

exit;
