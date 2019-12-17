from __future__ import print_function
import click
from os import system, path, mkdir
import os
import sys

@click.command()

@click.option("--type","-tp",default='WES',help='specify your analysis type')
@click.option("--threads","-t",default='20',help='threads for sentieon running')
@click.option("--interval","-var")
@click.option('--affilter','-af',default='0')
@click.option('--dp','-d',default='5')
@click.option("--hardfilter","-hd",default='1')
@click.option("--sv","-s",default='1')

#perl Sentieon_V2.0.pl --reference /home/database --sentieon /home/bioapps --fastq /home/fastq --results /Users/yifanwang/Desktop/tmp --nt 20 --list /Users/yifanwang/Desktop/fastq.list --AFfilter 1 --DP 5 --hardfilter 1 --SV 1

def sentieons(type,threads,interval,affilter,dp,hardfilter,sv):
    cdir= '/Users/yifanwang/workspace/workflow/worker/scripts'
    media_db_dir = '/Users/yifanwang/workspace/workflow/media'
    outdir = '/Users/yifanwang/Desktop/tmp'
    bedfile = '/home/xinpian_bed'

    if type == 'WES':
        sescript = path.join(cdir,'Sentieon_V2.0.pl')
    elif type == 'WGS':
        sescript = path.join(cdir,'Sentieon_WGS_V2.0.pl_1')
    elif type == 'RNA':
        sescript = path.join(cdir,'Sentieon_RNA_V2.0.pl')
    elif type == 'MT':
        sescript = path.join(cdir,'Sentieon_MT_V2.0.pl')
    
    refdir = media_db_dir
    sentdir = path.join(media_db_dir,'bioapps')
    resultdir = path.join(outdir,'sention_result4')
    mkdir(resultdir)
    samplefile = '/Users/yifanwang/Desktop/fastq.list2'
    
    if interval:
        sentions_command = ['perl',sescript, '--reference', refdir,'--sentieon',sentdir,'--fastq',
            outdir,'--results', resultdir, '--nt', threads,
             '--list', samplefile,'--interval',interval,'--affilter',affilter,'--dp',dp,'--hardfilter',hardfilter,'--sv',sv]
    else:
        sentions_command = ['perl',sescript, '--reference', refdir,'--sentieon',sentdir,'--fastq',
            outdir,'--results',resultdir, '--nt', threads, '--list', samplefile]

    print(' '.join(sentions_command))
    os.system(' '.join(sentions_command))
if __name__ == '__main__':
    sentieons()
##python click_add.py --threads 24 --interval /home/bed.txt
##python click_add.py --threads 24 --type RNA