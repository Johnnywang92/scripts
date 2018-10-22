use warnings;
use strict;


#Thu Oct 10 08:29:46 CST 2018 by huang_dawei

use warnings;
use strict;
use Getopt::Long;

my %opts;
GetOptions(\%opts,
"readcount_dir:s",
"readcount_fileExtension:s",
"filter_libNo:s",
"filter_tissue:s",
"filter_week:s",
"readcount:s",
"readcount_percent:s",
"readcount_percent_mean:s",
"baseline_compare:s"
);
my $usage= <<"USAGE";
	Program: $0
	INPUT:
			-readcount_dir	            ./readcount/
			-readcount_fileExtension	readcount

			-filter_libNo               lib01,lib31,lib32,lib33
			-filter_tissue              Brain,Kidney
			-filter_week                W1,W2

			-readcount_percent          1 or 0
			-readcount_percent          1 or 0
			-readcount_percent_mean     1 or 0
			-baseline_compare       	1 or 0
			

	FILES REQUIRED:none

	OUTPUT:
	
USAGE
die $usage unless ($opts{readcount_dir});
die $usage unless ($opts{readcount_fileExtension});

$opts{readcount}              = 0 if(!defined $opts{readcount}              );
$opts{readcount_percent}      = 0 if(!defined $opts{readcount_percent}      );
$opts{readcount_percent_mean} = 0 if(!defined $opts{readcount_percent_mean} );
$opts{baseline_compare}       = 0 if(!defined $opts{baseline_compare}       );

my $startTime=localtime();

my $filter_tissue;
if(defined $opts{filter_tissue}){
	my @r = split /,/,uc($opts{filter_tissue});
	foreach(@r){
		$filter_tissue->{$_} = 1;
	}
}

my $filter_week;
if(defined $opts{filter_week}){
	my @r = split /,/,uc($opts{filter_week});
	foreach(@r){
		$filter_week->{$_} = 1;
	}
}


my $filter_libNo;
if(defined $opts{filter_week}){
	my @r = split /,/,uc($opts{filter_libNo});
	foreach(@r){
		$filter_libNo->{$_} = 1;
	}	
}
open I, "< sgRNA_seq_libIndex.txt";

#defined a output order/sequence according to seq order in the result table (excel)
my @seqs;
my $lib_seq;
while(<I>){
	chomp;
	#Lib01   AACAATCAGAATACCAACACGGCTCCTACTGCAGGAACC
	my @r = split /\t/,$_;
	$lib_seq->{by_lib}->{uc($r[0])} = $r[1];
	$lib_seq->{by_seq}->{$r[1]}     = uc($r[0]);
}
close I;

open I, "< condition.conf.all.txt";
#read in the condition info and set a order for column in the output
my $file_group;
my $file_group_by_tissue;
my $wgc_id_info;
my $weeks;
while(<I>){
#R18055872LD01   W4-LN-807       ref
#
=cut
#time phase
baseline
Sample
W1
W2
W4

#tissue
Brain
Heart
Kidney
Lib
Liver
LN
Lung
Muscle
Spleen

=cut

	next if(!/R.*/);
	chomp;
	my @r = split /\t/,$_;
	my @time = split /-/,$r[1];
	#W4-LN-807
	#R18055862LD01	W4-Kidney-806	ref
	my $time_tag = $time[0]. "-". uc($time[1]);
	my $wgc_id = $r[0];
	my $week   = $time[0];
	my $tissue = $time[1];
	
	next if(defined $filter_tissue->{uc($tissue)});
	next if(defined $filter_week->{uc($week)});
	$weeks->{$week} = 1;
	
	$wgc_id_info->{$wgc_id}->{week} = $week;
	$wgc_id_info->{$wgc_id}->{tisu} = $tissue;
	$wgc_id_info->{$wgc_id}->{file} = 0;
	
	
	#print $r[0], "\t", $time_tag, "\n";
	$file_group->{$time_tag}->{$wgc_id} = 1;
}


my $count;
my @rec_files;
# read and store seq count in each file.
opendir(DIR, $opts{readcount_dir});
while (defined(my $file = readdir(DIR)))
{
        next if ($file!~/\.$opts{readcount_fileExtension}$/);

		my $week  ;
		my $tissue;
        if($file =~ /^(.*)\.$opts{readcount_fileExtension}$/){
        	my $wgc_id = $1;
        	if(!defined $wgc_id_info->{$wgc_id}){



#        		print "unknown wgc id: $wgc_id\n";



        	}else{
				$wgc_id_info->{$wgc_id}->{file} = 1;
				$week   = $wgc_id_info->{$wgc_id}->{week};
				$tissue = $wgc_id_info->{$wgc_id}->{tisu};

        open I,"< $opts{readcount_dir}/$file";
		my ($wgc_id, $extension) = split /\./,$file;
		next if(!defined $wgc_id_info->{$wgc_id});
        push @rec_files, $wgc_id;
        while (<I>)
        {
                chomp;
                if(/^[A|T|C|G]+.*\d+$/){

                        my @r = split /\t/,$_;
                        #AACTTGCAGCAAACCAATACAGGGCCTATTGTGGGAAAT	87268
                        my $seq   = $r[0];
                        my $libNo = $lib_seq->{by_seq}->{$seq};
                        #reset abnormal libNo's readcount as none.
                        $r[1] = 0 if(defined $filter_libNo->{$libNo});
                        
                        #store each data point of wgc id;
                        $count->{$wgc_id}->{eahr}->{$r[0]}->{cont} = $r[1];
                        $count->{$wgc_id}->{summ}         += $r[1];
#						print "$tissue\t$week\t$seq\t$wgc_id\n";
						$file_group_by_tissue->{$tissue}->{$week}->{data}->{$seq}->{repe}->{$wgc_id}->{rec}->{count} = $r[1];
                        
                }
        }
        close I;


        	}
        }
}
closedir DIR;


foreach my $wgc_id (keys %{$wgc_id_info}){
	print $wgc_id if($wgc_id_info->{$wgc_id}->{file} == 0);
}


# cal percent for each sgRNA for each repeat.
foreach my $wgc_id (keys %{$count}){
foreach my $sgRNA (keys %{$count->{$wgc_id}->{eahr}}){
#	print "$count->{$wgc_id}->{summ}\n";
	$count->{$wgc_id}->{eahr}->{$sgRNA}->{pcnt} = $count->{$wgc_id}->{eahr}->{$sgRNA}->{cont} / $count->{$wgc_id}->{summ};
	
}}


sub Mean{
	my $string = 0;
	my $cnt = 1;
	foreach(@_){
		if($_ ne "NA"){
			$string += $_;
			$cnt += 1;
		}
	}
	my $mean = $string/$cnt;
	return $mean;
}

#BASELINE
#R18048294LD01	baseline-Lib-mix	ref
foreach my $sgRNA      (sort keys %{$file_group_by_tissue->{Lib}->{baseline}->{data}                  }){
	my @pcnt = ();
	foreach my $wgc_id (sort keys %{$file_group_by_tissue->{Lib}->{baseline}->{data}->{$sgRNA}->{repe}}){
		push @pcnt, $count->{$wgc_id}->{eahr}->{$sgRNA}->{pcnt};
	}
	my $mpnt = Mean(@pcnt);
	$file_group_by_tissue->{Lib}->{baseline}->{data}->{$sgRNA}->{stas}->{mpnt} = $mpnt;
}

foreach my $tissue   (sort keys %{$file_group_by_tissue                                              }){
foreach my $week     (sort keys %{$file_group_by_tissue->{$tissue}                                   }){
foreach my $sgRNA    (sort keys %{$file_group_by_tissue->{$tissue}->{$week}->{data}                  }){
	my @pcnt = ();
foreach my $wgc_id   (sort keys %{$file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{repe}}){
	push @pcnt, $count->{$wgc_id}->{eahr}->{$sgRNA}->{pcnt};
}
	my $mpnt = Mean(@pcnt);
	$file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{stas}->{mpnt} = $mpnt;
	if(
		$mpnt
		> 
		$file_group_by_tissue->{Lib}->{baseline}->{data}->{$sgRNA}->{stas}->{mpnt}
	){
		$file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{stas}->{tORf} = 1;
	}else{
		$file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{stas}->{tORf} = 0;
	}
#	print $mpnt, "\n";
}
}
}

#print table column name/header
my @tissues = sort keys %{$file_group_by_tissue};
print "lib\tseq\t";
foreach my $week   (sort keys %{$weeks}){
foreach my $tissue (sort keys %{$file_group_by_tissue}){

	next if(defined $filter_tissue->{uc($tissue)});
	next if(defined $filter_week->{uc($week)});


if($opts{readcount}==1){
foreach my $wgc_id (sort keys %{$wgc_id_info}){
	if($wgc_id_info->{$wgc_id}->{week} eq $week &&
	$wgc_id_info->{$wgc_id}->{tisu} eq $tissue){
	if(defined $file_group_by_tissue->{$tissue}->{$week}->{data}){
		print "$week-$tissue-$wgc_id\t";
	}
	}	
}
}

print "$week-$tissue-p1\tp2\tp3\t"    if($opts{readcount_percent}==1);
print "aveP\t"          if($opts{readcount_percent_mean}==1);
print "baselineCheck\t" if($opts{baseline_compare}==1);
}}
print "\n";




foreach my $lib (sort keys %{$lib_seq->{by_lib}}){
	my $sgRNA = $lib_seq->{by_lib}->{$lib};
	print "$lib\t$sgRNA\t";	
foreach my $week   (sort keys %{$weeks}){
foreach my $tissue (sort keys %{$file_group_by_tissue}){

	next if(defined $filter_tissue->{uc($tissue)});
	next if(defined $filter_week->{uc($week)});

#output read count
if($opts{readcount}==1){
foreach my $wgc_id (sort keys %{$wgc_id_info}){
	if(
	$wgc_id_info->{$wgc_id}->{week} eq $week &&
	$wgc_id_info->{$wgc_id}->{tisu} eq $tissue
	){
		if(defined $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{repe}->{$wgc_id}){
			print  $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{repe}->{$wgc_id}->{rec}->{count}, "\t";
		}
	}	
}}

#output percent
if($opts{readcount_percent}==1){
foreach my $wgc_id (sort keys %{$wgc_id_info}){
	if(
	$wgc_id_info->{$wgc_id}->{week} eq $week &&
	$wgc_id_info->{$wgc_id}->{tisu} eq $tissue
	){
		if(defined $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{repe}->{$wgc_id}){
			print  $count->{$wgc_id}->{eahr}->{$sgRNA}->{pcnt}, "\t";
		}
	}	
}
}
#output mean readcount percent and baseline comparision
if(defined $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}){
print $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{stas}->{mpnt}, "\t" if($opts{readcount_percent_mean}==1);
print $file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{stas}->{tORf}, "\t" if($opts{baseline_compare}==1);
}
}}

print "\n";
}



__END__
print "seq\t";
foreach my $tissue   (sort keys %{$file_group_by_tissue                                              }){
foreach my $week     (sort keys %{$file_group_by_tissue->{$tissue}                                   }){
foreach my $sgRNA    (sort keys %{$file_group_by_tissue->{$tissue}->{$week}->{data}                  }){
foreach my $wgc_id   (sort keys %{$file_group_by_tissue->{$tissue}->{$week}->{data}->{$sgRNA}->{repe}}){


}}}}
foreach my $time_tag (sort keys %{$file_group}  ){
	foreach my $wgc_id ( sort keys %{$file_group->{$time_tag}} ){
	print "$time_tag\t";
}
}
print "\n";
print "seq\t";
foreach my $time_tag (sort keys %{$file_group}  ){
foreach my $wgc_id ( sort keys %{$file_group->{$time_tag}} ){
	print "$wgc_id\t";
}}
print "\n";
#print data ordered by seq for each wgc_id ordered by condition
foreach my $seq (@seqs){
print $seq, "\t";
foreach my $time_tag (sort keys %{$file_group}  ){
        foreach my $wgc_id ( sort keys %{$file_group->{$time_tag}} ){
 
	print $count->{$wgc_id}->{$seq}, "\t";

}
}
print "\n";
}


#===============================================================================================================
__END__
my $options;
$options .= "-loci $opts{loci}";
$options .= "-loci $opts{loci}";
$options .= "-loci $opts{loci}";
my $endTime=localtime();
open  LOG,">>$0.Program\_RLog";
print LOG "From \<$startTime\> to \<$endTime\>\tperl $0 $options\n";
close LOG;


__END__
sgRNA sequence  0
AACAATCAGAATACCAACACGGCTCCTACTGCAGGAACC 55639
AACTTACAATCGGCTAATACTGCACCCCAGACACAAACT 40805
AACCTACAGCAGCAAAACACCGCTCCTACTGTGGGGGCC 41929

