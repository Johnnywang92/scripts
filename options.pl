use Getopt::Long;
use vars;

my $AFfilter = 0;


GetOptions("reference=s"=>\$reference,"sentieon=s"=>\$sentieon,"fastq=s"=>\$fastq,
	"result=s"=>\$result,"nt=i"=>\$nt,"interval=s"=>\$interval,"AFfilter:s"=>\$AFfilter);
print "$interval";


if ($interval){
	print "$interval\n";
}else {
	print "original\n";
}

if($AFfilter){
	print "filter---\n";
}else{
	print "no filter\n";
}