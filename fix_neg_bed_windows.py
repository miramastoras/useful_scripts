'''
Purpose: This script fixes a bedfile where some of the intervals go beyond the size the of contig by converting the end coord to the length of the contig
Author: Mira Mastoras, mmastora@ucsc.edu
Usage: python3 fix_neg_bed_windows.py -b bedfile -g genome.sizes > new.bed

python3 fix_neg_bed_windows.py -b /Users/miramastoras/Desktop/GIAB_false_variants_projected_to_hap1.sort.10kb.bed -g /Users/miramastoras/Desktop/HG002.paternal.f1_assembly_v2_genbank.fa.fai.size.genome \
 > /Users/miramastoras/Desktop/GIAB_false_variants_projected_to_hap1.sort.10kb.fix.bed
'''

import argparse

def arg_parser():
    '''
    Parses command line arguments with argparse
    '''
    parser = argparse.ArgumentParser(
        prog='',
        description="")

    parser.add_argument("-g", "--genome",
                        required=True,
                        help="genome size file from fai ")
    parser.add_argument("-b", "--bedfile",
                        required=True,
                        help="bedfile file")

    return parser.parse_args()


def main():
    '''
    '''
    args = arg_parser()
    sizesDict={}
    with open(args.genome) as genomeFile:
        for line in genomeFile:
            contigs=line.strip().split("\t")
            sizesDict[contigs[0]]=int(contigs[1])

    # open bedfile
    with open(args.bedfile) as bedfile:
        for line in bedfile:
            interval=line.strip().split("\t")
            end=int(interval[2])
            start=int(interval[1])
            contig_name=interval[0]
            contig_size=sizesDict[interval[0]]

            # if end coord goes beyond size of contig, replace it with contig size
            if end > contig_size:
                end=contig_size
            # replace neg coords with 0
            if start < 0:
                start = 0

            print(contig_name, start, end, sep="\t")

if __name__ == '__main__':
    main()