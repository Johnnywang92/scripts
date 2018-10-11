use strict;
use warnings;
#by huang_dawei@wuxiapptec.com
#Mon Sep 10 08:07:03 CST 2018


open I, "< $ARGV[0]";
my $id;
my $gene_id;
my $uniprotId_geneId;
my $geneId_uniprotId;
while(<I>){
	chomp;
	$id = $1 if(/^ID\s{3}(\w+)\s+.*/);
	$gene_id = $1 if(/^DR\s{3}GeneID;\s+(\d+);\s+.*/);
	if(/^\/\//){
#		print $id, "\n";
#		print $gene_id, "\n";
		$gene_id = "UNDEFINED" if($gene_id eq "");
		$uniprotId_geneId->{$id} = $gene_id;
		$geneId_uniprotId->{$gene_id}->{$id} = 1;
		$id = "";
		$gene_id = "";
	}
}

my $cnt = 0;
my $cntAll = 0;
my $splitCnt = 0;
my @gene_list_90 = ();
open O, "> $ARGV[0].geneId.txt";

foreach my $geneId (keys %{$geneId_uniprotId}){
	$cntAll+=1;
	$cnt +=1;
	push @gene_list_90, $geneId if($geneId ne "UNDEFINED");
	if($cnt == 90 or $cntAll == scalar(keys %{$geneId_uniprotId})){
		open OS, "> $ARGV[0].split_geneId.". $splitCnt. ".geneCnt_".  scalar(@gene_list_90). ".txt";
#		print OS "GeneID count:", scalar(@gene_list_90), "\n";
		print OS join "\n",@gene_list_90;
		print OS "\n";
		close OS;
		@gene_list_90 = ();
		$cnt = 0;
		$splitCnt +=1;
	}
	print O $geneId, "\t";
	my @uniprotId = keys %{$geneId_uniprotId->{$geneId}};
	my $uniprotId = join ";",@uniprotId;
	print O $uniprotId, "\t", scalar(@uniprotId), "\n";
}


__END__

# 没有对应的Gene ID

ID   Q3U3Z0_MOUSE            Unreviewed;       263 AA.
AC   Q3U3Z0;
DT   11-OCT-2005, integrated into UniProtKB/TrEMBL.
DT   11-OCT-2005, sequence version 1.
DT   31-JAN-2018, entry version 80.
DE   SubName: Full=Uncharacterized protein {ECO:0000313|EMBL:BAE32645.1};
GN   Name=Il7r {ECO:0000313|MGI:MGI:96562};
OS   Mus musculus (Mouse).
OC   Eukaryota; Metazoa; Chordata; Craniata; Vertebrata; Euteleostomi;
OC   Mammalia; Eutheria; Euarchontoglires; Glires; Rodentia; Myomorpha;
OC   Muroidea; Muridae; Murinae; Mus; Mus.
OX   NCBI_TaxID=10090 {ECO:0000313|EMBL:BAE32645.1};
RN   [1] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=10349636; DOI=10.1016/S0076-6879(99)03004-9;
RA   Carninci P., Hayashizaki Y.;
RT   "High-efficiency full-length cDNA cloning.";
RL   Methods Enzymol. 303:19-44(1999).
RN   [2] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=11042159; DOI=10.1101/gr.145100;
RA   Carninci P., Shibata Y., Hayatsu N., Sugahara Y., Shibata K., Itoh M.,
RA   Konno H., Okazaki Y., Muramatsu M., Hayashizaki Y.;
RT   "Normalization and subtraction of cap-trapper-selected cDNAs to
RT   prepare full-length cDNA libraries for rapid discovery of new genes.";
RL   Genome Res. 10:1617-1630(2000).
RN   [3] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=11076861; DOI=10.1101/gr.152600;
RA   Shibata K., Itoh M., Aizawa K., Nagaoka S., Sasaki N., Carninci P.,
RA   Konno H., Akiyama J., Nishi K., Kitsunai T., Tashiro H., Itoh M.,
RA   Sumi N., Ishii Y., Nakamura S., Hazama M., Nishine T., Harada A.,
RA   Yamamoto R., Matsumoto H., Sakaguchi S., Ikegami T., Kashiwagi K.,
RA   Fujiwake S., Inoue K., Togawa Y., Izawa M., Ohara E., Watahiki M.,
RA   Yoneda Y., Ishikawa T., Ozawa K., Tanaka T., Matsuura S., Kawai J.,
RA   Okazaki Y., Muramatsu M., Inoue Y., Kira A., Hayashizaki Y.;
RT   "RIKEN integrated sequence analysis (RISA) system--384-format
RT   sequencing pipeline with 384 multicapillary sequencer.";
RL   Genome Res. 10:1757-1771(2000).
RN   [4] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=11217851; DOI=10.1038/35055500;
RG   The RIKEN Genome Exploration Research Group Phase II Team and the FANTOM Consortium;
RT   "Functional annotation of a full-length mouse cDNA collection.";
RL   Nature 409:685-690(2001).
RN   [5] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=12466851; DOI=10.1038/nature01266;
RG   The FANTOM Consortium and the RIKEN Genome Exploration Research Group Phase I and II Team;
RT   "Analysis of the mouse transcriptome based on functional annotation of
RT   60,770 full-length cDNAs.";
RL   Nature 420:563-573(2002).
RN   [6] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RA   Arakawa T., Carninci P., Fukuda S., Hashizume W., Hayashida K.,
RA   Hori F., Iida J., Imamura K., Imotani K., Itoh M., Kanagawa S.,
RA   Kawai J., Kojima M., Konno H., Murata M., Nakamura M., Ninomiya N.,
RA   Nishiyori H., Nomura K., Ohno M., Sakazume N., Sano H., Sasaki D.,
RA   Shibata K., Shiraki T., Tagami M., Tagami Y., Waki K., Watahiki A.,
RA   Muramatsu M., Hayashizaki Y.;
RL   Submitted (MAR-2004) to the EMBL/GenBank/DDBJ databases.
RN   [7] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RG   The FANTOM Consortium;
RG   Riken Genome Exploration Research Group and Genome Science Group (Genome Network Project Core Group);
RT   "The Transcriptional Landscape of the Mammalian Genome.";
RL   Science 309:1559-1563(2005).
RN   [8] {ECO:0000313|EMBL:BAE32645.1}
RP   NUCLEOTIDE SEQUENCE.
RC   STRAIN=NOD {ECO:0000313|EMBL:BAE32645.1};
RX   PubMed=16141073; DOI=10.1126/science.1112009;
RG   RIKEN Genome Exploration Research Group and Genome Science Group (Genome Network Project Core Group) and the FANTOM Consortium;
RT   "Antisense Transcription in the Mammalian Transcriptome.";
RL   Science 309:1564-1566(2005).
CC   -----------------------------------------------------------------------
CC   Copyrighted by the UniProt Consortium, see https://www.uniprot.org/terms
CC   Distributed under the Creative Commons Attribution (CC BY 4.0) License
CC   -----------------------------------------------------------------------
DR   EMBL; AK154516; BAE32645.1; -; mRNA.
DR   UniGene; Mm.389; -.
DR   MGI; MGI:96562; Il7r.
DR   eggNOG; ENOG410IGXR; Eukaryota.
DR   eggNOG; ENOG410YWZG; LUCA.
DR   HOVERGEN; HBG055773; -.
DR   ChiTaRS; Il7r; mouse.
DR   GO; GO:0016021; C:integral component of membrane; IEA:UniProtKB-KW.
DR   GO; GO:0004896; F:cytokine receptor activity; IEA:InterPro.
DR   CDD; cd00063; FN3; 1.
DR   Gene3D; 2.60.40.10; -; 1.
DR   InterPro; IPR003961; FN3_dom.
DR   InterPro; IPR036116; FN3_sf.
DR   InterPro; IPR003531; Hempt_rcpt_S_F1_CS.
DR   InterPro; IPR013783; Ig-like_fold.
DR   Pfam; PF00041; fn3; 1.
DR   SUPFAM; SSF49265; SSF49265; 1.
DR   PROSITE; PS50853; FN3; 1.
DR   PROSITE; PS01355; HEMATOPO_REC_S_F1; 1.
PE   2: Evidence at transcript level;
KW   Membrane {ECO:0000256|SAM:Phobius}; Signal {ECO:0000256|SAM:SignalP};
KW   Transmembrane {ECO:0000256|SAM:Phobius};
KW   Transmembrane helix {ECO:0000256|SAM:Phobius}.
FT   SIGNAL        1     20       {ECO:0000256|SAM:SignalP}.
FT   CHAIN        21    263       {ECO:0000256|SAM:SignalP}.
FT                                /FTId=PRO_5004229927.
FT   TRANSMEM    241    262       Helical. {ECO:0000256|SAM:Phobius}.
FT   DOMAIN      131    232       Fibronectin type-III.
FT                                {ECO:0000259|PROSITE:PS50853}.
SQ   SEQUENCE   263 AA;  29636 MW;  67D4D83FF811C81D CRC64;
     MMALGRAFAI VFCLIQAVSG ESGNAQDGDL EDADADDHSF WCHSQLEVDG SQHLLTCAFN
     DSDINTANLE FQICGALLRV KCLTLNKLQD IYFIKTSEFL LIGSSNICVK LGQKNLTCKN
     MAINTIVKAE APSDLKVVYR KEANDFLVTF NAPHLKKKYL KKVKHDVAYR PARGESNWTH
     VSLFHTRTTI PQRKLRPKAM YEIKVRSIPH NDYFKGFWSE WSPSSTFETP EPKNQGGWDP
     VLPSVTILSL FSVFLLVILA HVL
//
