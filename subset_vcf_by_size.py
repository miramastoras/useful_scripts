#!/usr/bin/env python3
"""
Subset vcf file by size of variant

Usage: python3 subset_vcf_by_size.py -i ~/Desktop/phased_vcfs/HG02723_guppy6_small_only.phased.vcf -min 50 -max 100000000 &> ~/HG02723_guppy6_small_only.phased.gt50.vcf
"""
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--outVcf', '-o', type=str, action='store', help='output file, unzipped')
parser.add_argument('--inVcf', '-i', type=str, action='store', help='input file, unzipped')
parser.add_argument('--minSize', '-min', type=str, action='store', help='minimum variant size in bp')
parser.add_argument('--maxSize', '-max', type=str, action='store', help='minimum variant size in bp')
args = parser.parse_args()

inVcf = open(args.inVcf, 'r')
lines = inVcf.readlines()
# Strips the newline character
for line in lines:
    if line[0]=="#":
        print(line.strip())
    else:
        data=line.strip().split("\t")
        refVariant=data[3].split(",")
        queryVariant=data[4].split(",")
        refLen=len(max(refVariant, key=len))
        queryLen=len(max(queryVariant, key=len))
        if (refLen < int(args.minSize) and queryLen < int(args.minSize)) or (refLen > int(args.maxSize) or queryLen > int(args.maxSize)):
            continue
        else:
            print(line.strip())

inVcf.close()