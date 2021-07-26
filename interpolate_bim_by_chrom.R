# Name: interpolate_bim_by_chrom.R
# Author: Mira Mastoras mnmastoras@ucdavis.edu
# Desc: This script takes in a bim file and genetic map file and prints to the screen the new interpolated cM values for each position in the bim file 
#       The map file format must have the following four space delimited columns: chr position COMBINED_rate(cM/Mb) Genetic_Map(cM)
#       the bim file must be tab delimited 
#       both map and bim file must be run on a single chromosome. 
#       If a snp isn't covered by the genetic map file, a warning will be printed with its rsid. Please remove these SNPS with plink and rerun
# Usage: Rscript interpolate_bim_by_chrom.R chr8.bim chr8.map > chr8.newcM

## To run via command line 
# args = commandArgs(trailingOnly=TRUE)
# bim = read.table(args[1], sep="\t", header=FALSE)
# map = read.table(args[2], sep =" ", header=TRUE)

# To run interactively
bim = read.table("/Users/miramastoras/Desktop/working_reynolds_lab/interpolation/chr8.bim",sep="\t", header=FALSE)
map = read.table("/Users/miramastoras/Desktop/working_reynolds_lab/interpolation/chr8.map", sep=" ", header=TRUE)
colnames(bim)= c("chr","rsid","cM","pos", "A1", "A2")
colnames(map)=c("chr","position", "COMBINED_rate.cM.Mb." ,"Genetic_Map.cM.")
bim$chr=as.factor(bim$chr)
map$chr=as.factor(map$chr)

indexes=lapply(bim$pos, findInterval, map$position)

for (i in 1:length(indexes)) { # calculates the cM for each bim position
  start_index = unlist(indexes[i])
  end_index = unlist(indexes[i]) + 1
  query_index = i
  
  if (start_index == length(map$Genetic_Map.cM.)) { # case that genetic map ends before the given snp in the bim file
    query_cM=paste("WARNING:SNP not in map:", bim$rsid[query_index])
  }
  else {
    start_cM=map$Genetic_Map.cM.[start_index]
    end_cM=map$Genetic_Map.cM.[end_index]
    start_pos=map$position[start_index]
    end_pos=map$position[end_index]
    query_pos=bim$pos[query_index]
    
    if (start_index==0) { # case that no interval can be found for the snp, set cM to zero. 
      query_cM=0 
    }
    else {
      query_cM= start_cM + ((query_pos - start_pos) * ((end_cM - start_cM )/(end_pos-start_pos)))
    }
  }
  cat(query_cM, "\n")
}

