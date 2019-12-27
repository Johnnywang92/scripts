#!/usr/bin/perl

=head
 
 IDT tumor analysis pipeline
 
 By Yifan Wang
 2019-12-27

for single sample

Usage: 

	perl $0 IDT.fastq.list	soft_dir	read_str	fastq_folder	reference_dir	result_dir	

	perl IDT.pl --list IDT.fastq.list --softdir /home/bpvast/IDT_test --read_str 3M2S+T --fastq_folder /home/bpvast/IDT_test/fatsq_data --reference_dir /home/bpvast/IDT_test/reference --result_dir /home/bpvast/IDT_test/workdir --probe_interval /home/gfk/IDT_test/T341V1.txt --probe /home/gfk/IDT_test/T341V1.txt


	the IDT.fastq.list format is:
	samplename	fastq.R1.gz	fastq.R2.gz

=cut


use warnings;
use strict;
use Cwd;
use File::Basename;
use Getopt::Long;
use vars qw($softdir $list $read_str $fastq_folder $reference_dir $result_dir $probe_interval $probe);

##INPUT Dirs
	
	# my $softdir=$ARGV[1];
	# my $read_str=$ARGV[2];		##read-structure: ILLUMINA:PE150 => 3M2S+T;	MGISEQ:PE100 => 3M4S+T(测试数据)
	# my $fastq_folder=$ARGV[3];
	# my $reference_dir=$ARGV[4];
	# my $result_dir=$ARGV[5];
	# my $xinpian=$ARGV[6];
	# my $probe_interval=$ARGV[7];

GetOptions("softdir=s"=>\$softdir,"list=s"=>\$list,"read_str=s"=>\$read_str,"fastq_folder=s"=>\$fastq_folder,"reference_dir=s"=>\$reference_dir,
	"result_dir=s"=>\$result_dir,"probe_interval=s"=>\$probe_interval,"probe=s"=>\$probe);


	my $xinpian = $probe_interval;
# Update with the location of the reference data files
#	my $hg19="$reference_dir/reference/human_g1k_v37.fasta";
#    my $bed="$reference_dir/reference/Illumina_pt2.bed";
	my $platform="ILLUMINA";
	my $group="IDT_seq";
	#my $probe="$reference_dir/snp.probe.bed";
	#my $probe_interval="$reference_dir/snp.probe.interval";

	my $pl="BGI";
	my $pl_unit="MGI";
	my $hg19="$reference_dir/human_g1k_v37.fasta";
	my $hg19_dict="$reference_dir/human_g1k_v37.dict";
	my $dbsnp="$reference_dir/dbsnp_138.b37.vcf";
	my $known_Mills_indels="$reference_dir/Mills_and_1000G_gold_standard.indels.b37.vcf";
	my $known_1000G_indels="$reference_dir/1000G_phase1.indels.b37.vcf";

	my $picard="$softdir/bioapps/picard/bin/picard.jar";
	my $fgbio="$softdir/bioapps/fgbio/bin/fgbio.jar";
	my $samtools="$softdir/bioapps/samtools-1.9/samtools";
	my $VarDict="$softdir/bioapps/VarDictJava/bin";
	my $bwa="$softdir/bioapps/bwa-0.7.17/bwa";
	
	my $SENTIEON_INSTALL_DIR="$softdir/bioapps/sentieon-genomics-201808.05";
	my $fasta = $hg19;
	my $nt="20";
	my @name;

open IN,"$list"|| die "INPUT file can not open!";   ##fastq.file.list
while(<IN>){
	chomp;
	my @inf=split(/\t/);
	push @name,@inf;		
}
close IN;
#	my $sample = $name[0];

for(my $n=0;$n<@name;$n=$n+3){
	my $sample = $name[$n];
	my $FASTQ = $name[$n+1];
	my $FASTQ2 = $name[$n+2];
	system("mkdir -p $result_dir/$sample");

#open OUT1,">$result_dir/$sample/$sample.ALL.sh" || die "outputfile can not open!";

	open OUT,">$result_dir/$sample/$sample.IDT.sh"||die "$sample.IDT.sh can not open!";
	print OUT "#!/bin/sh\n";
# ******************************************
# 0. Setup
# ******************************************
	print OUT "# ******************************************\n# 0. Setup\n# ******************************************\n\n";
	print OUT "# ******************************************\n# IDT Pipeline\n# ******************************************\n\n";
#	print OUT "# Update with the location of the Sentieon software package and license file\n";
# Update with the location of the Sentieon software package and license file
	print OUT "mkdir -p $result_dir/$sample && cd $result_dir/$sample\n";
	print OUT "log=$result_dir/$sample/detail.umi.log\n";
	print OUT "exec > \$log 2>\&1\n";
	
# ******************************************
# 1. fastq2uBAM
# ******************************************
	print OUT "# ******************************************\n# 1. fastq2uBAM\n# ******************************************\n\n";
	print OUT "java -jar $picard FastqToSam \\
FASTQ=$fastq_folder/$FASTQ \\
FASTQ2=$fastq_folder/$FASTQ2 \\
OUTPUT=$sample.uBAM \\
READ_GROUP_NAME=$sample \\
LIBRARY_NAME=$sample \\
SAMPLE_NAME=$sample \\
PLATFORM_UNIT=$pl_unit PLATFORM=$pl\n";

# ******************************************
# 2. get UMI infomation
# ******************************************
	print OUT "# ******************************************\n# 2. get UMI infomation\n# ******************************************\n\n";
	print OUT "java -jar $fgbio ExtractUmisFromBam \\
--input=$sample.uBAM \\
--output=$sample.umi.uBAM \\
--read-structure=$read_str $read_str \\
--single-tag=RX \\
--molecular-index-tags=ZA ZB\n";

# ******************************************
# 3. maping uBAM reads and combined uBAM and BAM
# ******************************************
	print OUT "# ******************************************\n# 3. maping uBAM reads and combined uBAM and BAM\n# ******************************************\n\n";
	print OUT "java -jar $picard SamToFastq I=$sample.umi.uBAM F=/dev/stdout \\
INTERLEAVE=true \\
|$bwa mem -p -t 20 $hg19 /dev/stdin \\
|java -jar $picard MergeBamAlignment \\
UNMAPPED=$sample.umi.uBAM \\
ALIGNED=/dev/stdin O=$sample.umi.merged.BAM R=$hg19 \\
SO=coordinate ALIGNER_PROPER_PAIR_FLAGS=true MAX_GAPS=-1 \\
ORIENTATIONS=FR VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true\n";

# ******************************************
# 4. Group reads by UMI
# ******************************************
	print OUT "# ******************************************\n# 2. Group reads by UMI\n# ******************************************\n\n";
	print OUT "java -jar $fgbio GroupReadsByUmi \\
--input=$sample.umi.merged.BAM \\
--output=$sample.umi.group.BAM \\
--strategy=paired --min-map-q=20 --edits=1\n";

# ******************************************
# 5. CollectDuplexSeqMetrics-211，根据211进行过滤后统计
# ******************************************
	print OUT "# ******************************************\n# 5. CollectDuplexSeqMetrics-211，根据211进行过滤后统计\n# ******************************************\n\n";
	print OUT "java -jar $fgbio CollectDuplexSeqMetrics \\
--input=$sample.umi.group.BAM \\
--output=$sample.211.umi \\
-u true \\
-a 1 \\
-b 1 \\
-l $probe_interval\n";

# ******************************************
# 6. CollectDuplexSeqMetrics-633，根据633进行过滤后统计
# ******************************************
	print OUT "# ******************************************\n# 6. CollectDuplexSeqMetrics-633，根据633进行过滤后统计\n# ******************************************\n\n";
	print OUT "java -jar $fgbio CollectDuplexSeqMetrics \\
--input=$sample.umi.group.BAM \\
--output=$sample.633.umi \\
-u true \\
-a 3 \\
-b 3 \\
-l $probe_interval\n";

# ******************************************
# 7. Call Duplex Consensus reads
# ******************************************
	##CallDuplexConsensusReads   ##CallMolecularConsensusReads
	print OUT "# ******************************************\n# 7. Call Duplex Consensus reads\n# ******************************************\n\n";
	print OUT "java -jar $fgbio CallMolecularConsensusReads \\
--min-reads=1 \\
--min-input-base-quality=30 \\
--error-rate-pre-umi=45 \\
--error-rate-post-umi=30 \\
--input=$sample.umi.group.BAM \\
--output=$sample.consensus.uBAM\n";

# ******************************************
# 8. mapping consensus reads and combined BAM
# ******************************************
	print OUT "# ******************************************\n# 8. mapping consensus reads and combined BAM\n# ******************************************\n\n";
	print OUT "java -jar $picard SamToFastq I=$sample.consensus.uBAM F=/dev/stdout \\
INTERLEAVE=true \\
|$bwa mem -p -t 20 $hg19 /dev/stdin \\
|java -jar $picard MergeBamAlignment \\
UNMAPPED=$sample.consensus.uBAM ALIGNED=/dev/stdin O=$sample.consensus.BAM R=$hg19 \\
SO=coordinate ALIGNER_PROPER_PAIR_FLAGS=true MAX_GAPS=-1 \\
ORIENTATIONS=FR VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true\n";



# ******************************************
# 9. filter Consensus reads
# ******************************************
	print OUT "# ******************************************\n# 9. filter Consensus reads\n# ******************************************\n\n";
	print OUT "java -jar $fgbio FilterConsensusReads \\
--input=$sample.consensus.BAM \\
--output=$sample.consensus.filter.BAM \\
--ref=$hg19 --min-reads=2 1 1 \\
--max-read-error-rate=0.05 \\
--max-base-error-rate=0.1 \\
--min-base-quality=30 \\
--max-no-call-fraction=0.05\n";

# ******************************************
# 10. clip
# ******************************************
	print OUT "# ******************************************\n# 10. clip\n# ******************************************\n\n";
	print OUT "java -jar $fgbio ClipBam \\
--input=$sample.consensus.filter.BAM \\
--output=$sample.consensus.filter.clip.BAM \\
--ref=$hg19 --soft-clip=false --clip-overlapping-reads=true\n";

# ******************************************
# 11. Variant call
# ******************************************
	print OUT "# ******************************************\n# 10. Variant call\n# ******************************************\n\n";
	print OUT "AF_THR=\"0.0001\"\n";

	print OUT "$VarDict/vardict-java -G $hg19 -f \$AF_THR -N $sample \\
-b $sample.consensus.filter.clip.BAM \\
-z -c 1 -S 2 -E 3 -g 4 -th -r 1 -B 1 $probe \\
|$VarDict/teststrandbias.R \\
|$VarDict/var2vcf_valid.pl -N $sample -E -f \$AF_THR \\
|awk '{if(\$1 ~/^#/)print;else if(\$4!=\$5)print}' > tmp.vcf\n";
	print OUT "java -jar $picard SortVcf I=tmp.vcf O=$sample.probe.vcf SD=$hg19_dict\n";
	print OUT "rm tmp.vcf\n";
close OUT;
}

#system ("bash $result_dir/$sample/IDT.sh;bash $result_dir/$sample/$sample.SV.sh");
