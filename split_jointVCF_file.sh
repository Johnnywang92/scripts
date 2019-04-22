#! /usr/bin/bash

set -u
set -e


###1.解压VCF压缩包
unzip *gz

###2. 新建新文件夹
ls *vcf|while read id; do echo ${id:0:10}; mkdir $_; done

###3.把vcf文件放入新建的文件夹
ls *vcf|while read id;do mv $id ${id:0:10};done

###4.遍历文件夹内的VCF文件的列数
ls */*vcf |while read id;do(grep CHROM $id|awk '{print NF}'>${id%.*}_num.log);done

###5.取出列名
ls */*vcf |while read id;do (cut -f 10-$num;done

for i in `seq $num`; do(cut -f 1-9,$i > $i.vcf);done

#######取出第9列后的列

cut -f1-9 --complement ./HY18129620/HY18129620.vcf

cut -f1-9 --complement ./HY18129620/HY18129620.vcf|sed '/^##/d' > tmp.vcf

head -1 tmp.vcf | awk '{split($0, array, " "); for(i=1; i<=length(array); i++){print array[i]} }' > name.txt

#####################
ls */*vcf |while read id;do(grep CHROM $id|awk '{print NF}'>${id%.*}_num.log);done

head -1 tmp.vcf | awk '{split($0, array, " "); for(i=1; i<=length(array); i++){print array[i]} }' > name.txt

awk '{print "cut -f 1-9,$i ./*/*vcf > tmp_$i.vcf"}'


cut -f 1-9,10 ./HY18129620/HY18129620.vcf > tmp_10.vcf

cut -f 1-9,11 ./HY18129620/HY18129620.vcf > tmp_11.vcf

cut -f 1-9,12 ./HY18129620/HY18129620.vcf > tmp_12.vcf

####前面49行不如最后一行直接搞定啦～～
##使用bcftools和vcftools进行多样本的vcf文件拆分
##https://www.biostars.org/p/224702/

for sample in `bcftools query -l test.vcf`; do vcf-subset --exclude-ref -c $sample test.vcf > ${sample}.vcf; done
