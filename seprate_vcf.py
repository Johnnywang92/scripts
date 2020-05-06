import copy
import os
import sys

def saixuan(datalist):
    dicainfor = {}
    for i,d in enumerate(datalist.split(':')):
        dicainfor[d]=i
    return dicainfor
def seprate_mutialtvcf(vcf):
    backfile  = vcf.rsplit('.',1)[0] + '.back.vcf'
    os.system('cp %s %s'%(vcf,backfile))
    with open(backfile) as f:
        with open(vcf,'w') as out:
            for line in f:
                if line[0] != '#':
                    lis = line.strip().split('\t')
                    alts = lis[4]
                    if ',' in alts:
                        altlist = alts.split(',')
                        infor_tag = saixuan(lis[8])
                        if 'AD' in infor_tag:
                            adindex = infor_tag['AD']
                        for index,alt in enumerate(altlist):
                            if '*' in alt:
                                continue
                            newlist = copy.deepcopy(lis)
                        # newlist[8] = ':'.join(newlist[8].split(':')[:4])
                            newlist[4] = alt
                            for j in range(9,len(lis)):
                                infodate = newlist[j].split(':')
                                ad_datelist = infodate[adindex].split(',')
                                newad_date = ','.join([ad_datelist[0],ad_datelist[index+1]])
                                infodate[adindex] = newad_date
                                infodate[0] = '0/1'
                                newlist[j] = ':'.join(infodate)
                            # newlist[j] = ':'.join(newlist[j].split(':')[:4])
                            # print('\t'.join(newlist),file=out)
                            out.write('\t'.join(newlist) + '\n')
                    else:
                        # print(line.strip('\n'),file=out)
                        out.write(line.strip('\n') + '\n')
                else:
                    # print(line.strip('\n'),file=out)
                    out.write(line.strip('\n') + '\n')
