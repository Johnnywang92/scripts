myvcf=$1

if [ ! -f "$myvcf" ]; then
        echo "vcf not exists, process failed"
        exit 1
else
        vcfsize=`ls -l $myvcf | awk '{ print $5 }'`
        if [ "$vcfsize" -gt "100" ]; then
                echo "$vcfsize, process finished"
                #echo "process finished"
        else
                echo "$vcfsize, process failed"
                echo "process failed"
                exit 8
        fi
fi
