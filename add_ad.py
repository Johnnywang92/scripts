from __future__ import print_function
import copy

#gridss_raw = "/home/gfk/workspace/workflow/gridss/gridss.sv.vcf.1"
#gridss_AD = "/home/gfk/workspace/workflow/gridss/Gridss_AD.vcf"
def add_AD(gridss_raw,gridss_AD):
    with open(gridss_raw) as raw, open(gridss_AD,"w") as out:
        for line in raw:
            if line[0] != '#':
                line = line.strip().split('\t')
                format = line[8]
                new_format= line[8] + ':AD'
                info = line[9].split(":")
                AD = info[-1] +","+ info[-7]
                new_info = line[9] + ":" + AD
                #print(new_info)
                newlist = copy.deepcopy(line)
                #print(newlist)
                newlist[8] = new_format
                newlist[9] = new_info
                print('\t'.join(newlist),file=out)
            else:
                print(line.strip('\n'),file=out)

if __name__ == '__main__':
    add_AD(gridss_raw,gridss_AD)
