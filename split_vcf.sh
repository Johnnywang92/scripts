##used for split trios VCF files
##USAGE:
##	bash split_vcf.sh INPUT.vcf
cp $1 test.vcf |for sample in `bcftools query -l test.vcf`; do vcf-subset --exclude-ref -c $sample test.vcf > ${sample}.vcf; done
