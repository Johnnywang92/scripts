from __future__ import print_function
import os
from os import path
import linecache
import copy

def combine(vcf):
    back_vcf  = path.join(vcf + '_backup')
    os.system('cp %s %s'%(vcf,back_vcf))
    with open(vcf,'w') as out:
        count = len(open(back_vcf).readlines())
        num = 0
        for i in range(1,count):
            fst_line = linecache.getline(back_vcf,i).strip('\n')
            sec_line = linecache.getline(back_vcf,i+1).strip('\n')

            fst_lis = fst_line.strip().split('\t')
            sec_lis = sec_line.split('\t')
            if fst_line[0] != '#':
                fst_pos = fst_lis[1]
                sec_pos = sec_lis[1]
                
                if int(sec_pos) - int(fst_pos) == 1:
                    new_list = copy.deepcopy(fst_lis)
                    new_ref= fst_lis[3]+sec_lis[3]
                    new_alt= fst_lis[4]+sec_lis[4]
                    new_list[3] = new_ref
                    new_list[4] = new_alt

                    #print(fst_line,file=out)
                    print('\t'.join(new_list),file=out)
                    print(sec_line,file=out)
                else:
                    if i == num+1:
                        print(fst_line,file=out)
                    print(sec_line,file=out)
            else:
                print(fst_line,file=out)
                num = num + 1
                #print(num)

# vcf = './142.vcf'
# combine(vcf)

'''
This scrtpt write for combine the two SNPs which adjacent on chromsome into one SNP
Wed Apr 29 14:53:58 CST 2020
yifan.wang@bpvast.com

1. read whole vcf file and count the length
2. use linecache to get two line at once
3. check if the two SNPs adjacent: ?? sec_pos - fst_pos == 1, exchange with new ref and alt
4. print fst line if none adjacent exist at first two lines 
5. print sec lines
'''
