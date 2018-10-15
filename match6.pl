use strict;
use warnings;

my $annot;
open ANN, "< $ARGV[0]";
while(<ANN>){
	chomp;
	$_ =~ s/,//g;
	my @r = split /\t/,$_;
	if ($r[6] eq ""){
		$r[6] = "N";
	}
	$r[0] =~ s/\s+//g;
	$r[2] =~ s/\s+//g;
	$r[3] =~ s/\s+//g;
	$r[6] =~ s/\s+//g;
	$annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[6]}->{exi} = 0;
	$annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[6]}->{rec}   = $_;
	$annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[6]}->{add}   = "";
#	print "$r[0]\t$r[2]\t$r[3]\t$r[6]\n";
}
close ANN;


open BLAST,"< $ARGV[1]";
while(<BLAST>){
	chomp;
	my @r = split /\t/,$_;
	$r[0] =~ s/\s+//g;
	$r[2] =~ s/\s+//g;
	$r[3] =~ s/\s+//g;
	$r[5] =~ s/\s+//g;
	if ($r[5] eq "-"){
		$r[5] = "N";
		#print "$r[5]\n";
	}
	next if($r[0] =~ /.*_PDC/);
	next if($r[0] =~ /LU-01-0582R/);

	if(defined $annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[5]}->{exi}){
		$annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[5]}->{exi} = 1;
		$annot->{$r[0]}->{$r[2]}->{$r[3]}->{$r[5]}->{add} = "$r[8]\t$r[9]";
	}elsif(defined $annot->{ substr($r[0], 0, 11) }->{$r[2]}->{$r[3]}->{$r[5]}->{exi}){
		$annot->{ substr($r[0], 0, 11) }->{$r[2]}->{$r[3]}->{$r[5]}->{exi} = 1;
		$annot->{ substr($r[0], 0, 11) }->{$r[2]}->{$r[3]}->{$r[5]}->{add} = "$r[8]\t$r[9]";
	}elsif(defined $annot->{ substr($r[0], 0, 10) }->{$r[2]}->{$r[3]}->{$r[5]}->{exi}){
		$annot->{ substr($r[0], 0, 10) }->{$r[2]}->{$r[3]}->{$r[5]}->{exi} = 1;
		$annot->{ substr($r[0], 0, 10) }->{$r[2]}->{$r[3]}->{$r[5]}->{add} = "$r[8]\t$r[9]";
	}

}
close BLAST;

foreach my $key1 (sort keys %{$annot}){
foreach my $key2 (sort {$a<=>$b} keys %{$annot->{$key1}}){
foreach my $key3 (sort {$a<=>$b} keys %{$annot->{$key1}->{$key2}}){
foreach my $key4 (keys %{$annot->{$key1}->{$key2}->{$key3}}){
	my $exi = 0;
	my $add = "";
	my $rec = "";
foreach my $key5 (keys %{$annot->{$key1}->{$key2}->{$key3}->{$key4}}){
	if($key5 eq "exi"){
		$exi = $annot->{$key1}->{$key2}->{$key3}->{$key4}->{exi};
	}
	if($key5 eq "add"){
		$add = $annot->{$key1}->{$key2}->{$key3}->{$key4}->{add};
	}
	if($key5 eq "rec"){
		$rec = $annot->{$key1}->{$key2}->{$key3}->{$key4}->{rec};
	}

}
	if($exi == 1 && $rec ne ""){
		print $rec, "\t", $add, "\n";
	}elsif($rec ne ""){
		print $rec, "\t-\t-\n"
	}

}
}
}
}
__END__

foreach my $key5 (keys %{$annot->{$key1}->{$key2}->{$key3}->{$key4}}){
#	print $annot->{$key1}->{$key2}->{$key3}->{$key4}->{exi}, "";
	if($key5 eq "exi"){
		print $annot->{$key1}->{$key2}->{$key3}->{$key4}->{exi}, "\n";
	}

}

foreach my $key1 (keys %{$annot}){
foreach my $key2 (keys %{$annot->{$key1}}){
foreach my $key3 (keys %{$annot->{$key1}->{$key2}}){
foreach my $key4 (keys %{$annot->{$key1}->{$key2}->{$key3}}){
	print $annot->{$key1}->{$key2}->{$key3}->{$key4}->{exi}, "\n";
}
}
}
}
__END__
MODEL	Gene Symbol	Chromosome	Mut.Start	Mut.End	Ref	Alt	Mutation	Genotype
BR-05-0014	TP53	17	7,578,478	7,578,478		GT	frameshift insertion	homozygous
BR-05-0014	NOTCH2	1	120,572,572	120,572,572	C	T	nonsynonymous SNV	heterozygous

	$annot->{ $r[0]}->{$r[2]}->{$r[3]}->{$r[6]} ="$_";
	$annot1->{$r[0]}->{$r[2]}->{$r[3]}->{$r[6]}->{exist}=0;
0
$r[0]\t     $r[11]\t$r[2]\t$r[3]\t  $r[3]\t $r[4]\t$r[5]\t $r[8] $r[9]\t $r[12]\t$r[7]\t$r[14]\t$r[15]\t$r[17]
ST-02-0001	NOTCH2	1	120458215	120458215	G	A	0.450	80	nonsynonymous SNV	0/1	.	rs367757908	.
ST-02-0001	FAT1	4	187630905	187630905	C	T	0.190	100	nonsynonymous SNV	0/1	0.0303514	rs75367100	COSM3683267;COSM3683268;

Modle_ID	wgcID	   Chr	POS	      REF	ALT	Filter	GT	AF	DP	region	gene	type	Aachange	1000G	dbSNP	common	COSMIC	cancer_panel	SMART
ES-06-0014	WGC000056	X	100240761	G	A	PASS	1/1	1.000	8	exonic	ARL13A	nonsynonymous SNV	ARL13A:NM_001162491:exon4:c.G236A:p.R79Q	.	.	.	.	.	.
ES-06-0014	WGC000056	X	100532621	T	C	PASS	0/1	0.833	6	exonic	TAF7L	nonsynonymous SNV	TAF7L:NM_001168474:exon9:c.A664G:p.S222G,TAF7L:NM_024885:exon9:c.A922G:p.S308G	0.180397	rs35899692	rs35899692	COSM3759316;	.	.
ES-06-0014	WGC000056	X	100547933	A	G	PASS	1/1	1.000	12	exonic	TAF7L	nonsynonymous SNV	TAF7L:NM_024885:exon1:c.T101C:p.L34P	0.994967	rs5951328	.	.	.	.
ES-06-0014	WGC000056	X	101138792	T	C	PASS	1/1	1.000	18	exonic	ZMAT1	nonsynonymous SNV	ZMAT1:NM_001011657:exon7:c.A1607G:p.Q536R,ZMAT1:NM_001282401:exon9:c.A1094G:p.Q365R,ZMAT1:NM_001282400:exon10:c.A1094G:p.Q365R	1	rs5944882	.	COSM4590056;COSM4590055;	.	.
ES-06-0014	WGC000056	X	101395780	T	TG	PASS	1/1	1.000	33	exonic	TCEAL6	frameshift insertion	TCEAL6:NM_001006938:exon3:c.523dupC:p.Q175fs	1	Name=rs200987681,rs111588852	.	COSM1464461;	.	.
ES-06-0014	WGC000056	X	101912118	C	T	PASS	1/1	1.000	28	exonic	GPRASP1	nonsynonymous SNV	GPRASP1:NM_001099411:exon3:c.C3277T:p.P1093S,GPRASP1:NM_001099410:exon4:c.C3277T:p.P1093S,GPRASP1:NM_014710:exon5:c.C3277T:p.P1093S,GPRASP1:NM_001184727:exon6:c.C3277T:p.P1093S	0.156821	rs2235804	rs2235804	COSM150803;	.	.
ES-06-0014	WGC000056	X	102979486	T	C	PASS	1/1	1.000	18	exonic	GLRA4	nonsynonymous SNV	GLRA4:NM_001024452:exon3:c.A253G:p.I85V,GLRA4:NM_001172285:exon3:c.A253G:p.I85V	0.986755	rs4907817	rs4907817	.	.	.
ES-06-0014	WGC000056	X	103267865	C	T	PASS	1/1	1.000	15	exonic	H2BFWT	nonsynonymous SNV	H2BFWT:NM_001002916:exon1:c.G368A:p.R123H	0.580927	rs553509	rs553509	COSM4998301;	.	.
ES-06-0014	WGC000056	X	103294760	C	T	PASS	1/1	1.000	30	exonic	H2BFM	stopgain	H2BFM:NM_001164416:exon1:c.C217T:p.Q73X	0.30649	rs2301384	rs2301384	COSM3992276;COSM3992277;	.	.
