'''
Purpose: keep only one copy of duplicate entries in vcf
Author: Mira Mastoras, mmastora@ucsc.edu
Usage: python3 rmdups_vcf.py -i ~/Desktop/HG002_hifiasm_wgs_dip_polisher_output.sorted.merged.PASS.nostar.vcf.gz -o
'''

import argparse
from pysam import VariantFile

def arg_parser():
    '''
    Parses command line arguments with argparse
    '''
    parser = argparse.ArgumentParser(
        prog='',
        description="")

    parser.add_argument("-i", "--vcf_file",
                        required=True,
                        help="input vcf")
    parser.add_argument("-o", "--output_file",
                        required=False,
                        help="optionally specify different output file")

    return parser.parse_args()


def main():
    '''
    '''
    args = arg_parser()

    vcf_in = VariantFile(args.vcf_file)  # auto-detect input format

    if args.output_file:
        outname=args.output_file
    else:
        outname=args.vcf_file.replace(".vcf.gz", "_filt.vcf.gz")
    print(outname)

    vcf_out = VariantFile(outname, 'w', header=vcf_in.header)

    vcf_set=set()

    dup_count=0
    # iterate over all vcf entries
    for rec in vcf_in.fetch():
        key=rec.contig + ":"+str(rec.pos)
        if key in vcf_set:
            dup_count+=1
            continue
        else:
            # add key to dictionary
            vcf_set.add(key)
            # write vcf record to file
            vcf_out.write(rec)
    print("Filtered out", dup_count, "duplicate entries.")

if __name__ == '__main__':
    main()