#/usr/bin/perl

use warnings;
use strict;

use Getopt::Long;
use File::Basename;

=head
1. if (.gz$) 解压（vcf）
2. 过滤PASS, check info[9] format.
3. 

=cut


#my $BCFTOOLS = "/bioapps/bcftools"

my $in_vcf;
my $out_vcf;
my $help;
my $DEBUG = 0;

GetOptions(
	'in_vcf=s' => \$in_vcf,
	'out_vcf=s' => \$out_vcf,
#	'pass-only-expression=s' => \$pass_only_exp,
	'help=s' => \$help,
) or print_help();
print_help() if $help;

#my $gzip_cmd = "| gzip -d ";


###1.解压###
if ($in_vcf =~ /\.gz$/){
	execute("gzip -dc $in_vcf > $in_vcf.tmp ");
} else{
	execute("cp $in_vcf $in_vcf.tmp");
}

####tasks
pass_only("$in_vcf.tmp","$out_vcf");


sub pass_only{
	my($input_file,$output_file) = @_;
	if (count($input_file)) {
		execute("bcftools view -i \"FILTER = 'PASS' & QUAL>100 & FORMAT/DP!='.' & FORMAT/AD[0:1] > 6\" $input_file > $output_file ");  ##FILTER = 'PASS' && 注意除perl自需的引号，其他引号使用\反义
	}
	else {
        
        die "The VCF file you uploaded: $in_vcf does not pass the QC!";
    }
}

sub count {
    my $file = shift;
    my @results = `zgrep -v '^#' $file | cut -f1,2,3 | sort -u | wc -l`;
    chomp $results[0];
    return $results[0];
}

sub execute {
    my $cmd = shift;

    print STDERR $cmd,"\n";
    if(!$DEBUG) {
        my $rvalue = `$cmd`;
        unless(defined $rvalue) {
            die "Error running $cmd\n";
        }
        else {
            print $rvalue;
        }
    }
}


__END__
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  HY19070442
1       897325  rs4970441       G       C       60.28   PASS    AC=2;AF=1.000;AN=2;DB;DP=3;ExcessHet=3.0103;FS=0.000;MLEAC=2;MLEAF=1.000;MQ=60.00;POSITIVE_TRAIN_SITE;QD=20.09;SOR=1.179;VQSLOD=9.0448;culprit=MQ       GT:AD:DP:GQ:PL  1/1:0,3:3:9:88,9,0
1       914876  rs13302983      T       C       83.28   PASS    AC=2;AF=1.000;AN=2;DB;DP=3;ExcessHet=3.0103;FS=0.000;MLEAC=2;MLEAF=1.000;MQ=60.00;POSITIVE_TRAIN_SITE;QD=27.76;SOR=1.179;VQSLOD=8.3970;culprit=MQ       GT:AD:DP:GQ:PL  1/1:0,3:3:9:111,9,0
1       955678  .       G       T       43.77   PASS    AC=1;AF=0.500;AN=2;BaseQRankSum=-0.000;ClippingRankSum=-0.000;DP=7;ExcessHet=3.0103;FS=0.000;MLEAC=1;MLEAF=0.500;MQ=60.00;MQRankSum=-0.000;QD=7.29;ReadPosRankSum=-0.000;SOR=0.693;VQSLOD=7.1662;culprit=MQ     GT:AD:DP:GQ:PGT:PID:PL  0/1:4,2:6:72:0|1:955678_G_T:72,0,180
1       955687  .       G       T       43.77   PASS    AC=1;AF=0.500;AN=2;BaseQRankSum=-0.000;ClippingRankSum=-0.000;DP=7;ExcessHet=3.0103;FS=0.000;MLEAC=1;MLEAF=0.500;MQ=60.00;MQRankSum=-0.000;QD=7.29;ReadPosRankSum=-0.000;SOR=0.693;VQSLOD=7.4948;culprit=MQ     GT:AD:DP:GQ:PGT:PID:PL  0/1:4,2:6:72:0|1:955678_G_T:72,0,180
1       981931  rs2465128       A       G       4764.77 PASS    AC=2;AF=1.000;AN=2;DB;DP=164;ExcessHet=3.0103;FS=0.000;MLEAC=2;MLEAF=1.000;MQ=60.00;POSITIVE_TRAIN_SITE;QD=30.54;SOR=1.079;VQSLOD=7.1805;culprit=MQ     GT:AD:DP:GQ:PL  1/1:0,156:156:99:4793,464,0
1       982994  rs10267 T       C       3433.77 PASS    AC=2;AF=1.000;AN=2;DB;DP=113;ExcessHet=3.0103;FS=0.000;MLEAC=2;MLEAF=1.000;MQ=60.00;POSITIVE_TRAIN_SITE;QD=31.22;SOR=1.022;VQSLOD=7.8230;culprit=MQ     GT:AD:DP:GQ:PL  1/1:0,110:110:99:3462,330,0
1       984302  rs9442391       T       C       1958.77 PASS    AC=2;AF=1.000;AN=2;DB;DP=72;ExcessHet=3.0103;FS=0.000;MLEAC=2;MLEAF=1.000;MQ=60.00;POSITIVE_TRAIN_SITE;QD=28.39;SOR=0.722;VQSLOD=7.6223;culprit=MQ      GT:AD:DP:GQ:PL  1/1:0,69:69:99:1987,207,0

###pass_only_expression###


#sub pass_only {
#    my ($input_file, $output_file, $expression) = @_;
#    if(count($input_file)) {

#        if($expression) {
#            execute("$VCFLIB/vcffilter $expression $input_file > $output_file");
#        }
#        else {
#            execute("cat $input_file | perl -ape '\$_=q{} unless(\$F[6] eq q{PASS} || \$F[6] eq q{.} || \$F[0] =~ /^#/)' > $output_file");
#        }
#    }
#    else {
#        execute("cp $input_file $output_file");
#    }
#    execute("tabix -p vcf $output_file");
#}

####
#bcftools view -i "DP!='.' && QUAL>100 && FORMAT/AD[0:1] > 6" $sample.structureal_variant_vcf_all > $sample.structureal_variant_vcf;  

#bcftools view -i "DP!='.' && AD!='.' " HY18118953.vqsr_SNP_INDEL.hc.recaled.vcf


#bcftools view -i "QUAL>100 & FORMAT/DP!='.' & FORMAT/AD[0:1] > 1 " test.vcf > final.vcf

