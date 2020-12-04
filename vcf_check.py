        ##vcf check
        gvcf = 'test.output-hc.vcf.g.gz'
        myvcf = 'myvcf=%s' % gvcf
        vcf_check = 'if [ ! -f "$myvcf" ]; then echo "vcf not exists, process failed"; exit 1; else vcfsize=`ls -l $myvcf | awk \'{ print $5 }\'`; if [ "$vcfsize" -gt "10000" ]; then echo "$vcfsize, process finished"; else echo "$vcfsize, process failed"; exit 8;  fi; fi'
        # ---------------------------------------------------------------------------
        #adjust vcfsize cutoff by the vcffile size
