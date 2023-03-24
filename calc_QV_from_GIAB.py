'''
Purpose: calculate projected QV from performance in GIAB truth regions.Assumes unphased GIAB variants
Author: Mira Mastoras, mmastora@ucsc.edu
Usage: python3 calc_QV_from_GIAB.py -v /Users/miramastoras/Desktop/whole_genome_variants/raw_asm_eval_chr20_happy.vcf -b /Users/miramastoras/Desktop/whole_genome_variants/HG002.GIAB.4.2.1.benchmark_noinconsistent.dip.projectable.bed
'''

import argparse
import sys
import math

def arg_parser():
    '''
    Parses command line arguments with argparse
    '''
    parser = argparse.ArgumentParser(
        prog='',
        description="")

    parser.add_argument('--happy_vcf', '-v', type=str, action='store', help='hap.py vcf file')
    parser.add_argument('--bedfile', '-b', type=str, action='store', help='GIAB confidence regions used in hap.py')

    return parser.parse_args()

def get_false_bases(happy_vcf):
    '''
    Get count of false bases from hap,py vcf
    '''
    n_false = 0
    with open(happy_vcf, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("#"):
                pass
            else:
                line=line.split("\t")
                truth_col=line[9]
                query_col=line[10]

                # skip UNK values
                if "UNK" in truth_col or "UNK" in query_col:
                    continue
                # if we have a false variant:
                if "FP" in truth_col or "FN" in truth_col or "FP" in query_col or "FN" in query_col:
                    # put alles indexed into a list based on their order (0,1,2) in the vcf etc
                    alleles=line[3].split(",") + line[4].split(",")
                    # get genotype of query and truth

                    query_gt=line[10].split(":")[0].split("/")
                    truth_gt = line[9].split(":")[0].split("/")

                    # "." indicates the GT was '.:.:.:.:NOCALL:nocall:0' which means REFCALL
                    if truth_gt[0]==".":
                        truth_gt = [0, 0]
                    if query_gt[0]==".":
                        query_gt = [0 , 0]

                    for al in query_gt:
                        # check if each allele in query_gt matches any allele in truth_gt. This deals with the errors on each haplotype
                        if int(al) == int(truth_gt[0]) or int(truth_gt[1]):
                            pass
                        else:
                            # add length of false alleles to (# false bases)
                           n_false += len(alleles[int(al)])
    return n_false

def count_bases_in_bed(bedfile):
    '''
    count number of bases in bedfile
    '''
    bases=0
    with open(bedfile, 'r') as f:
        for line in f:
            line = line.strip().split("\t")
            if int(line[1]) > int(line[2]):
                print("Bedfile start coordinate is larger than end coordinate at", line[0], "\t", line[1], "\t", line[2])
                sys.exit()
            bases += int(line[2]) - int(line[1])

    return bases
def main():
    '''
    '''
    args = arg_parser()

    # get number of bases in genome (those projectable to GRCh38 and also in GIAB confidence regions)
    n_total = count_bases_in_bed(args.bedfile)

    # get num false bases from hap.py vcf
    n_false=get_false_bases(args.happy_vcf)

    # Calculate QV and print
    E= n_false / n_total
    print(n_false, n_total)
    print(E)
    QV=-10 * (math.log(E,10))
    print(QV)

if __name__ == '__main__':
    main()