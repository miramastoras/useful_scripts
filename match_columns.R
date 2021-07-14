# Author: Mira Mastoras
#This script updates the populations in a .fam file. 
# It takes in a fam file, and a txt file with the new population label in the first column, 
# and the ID in the second column 
# It uses the match function to locate the index in the new pops txt file of each ID in the fam file 
# and then replaces the old pop id with the new one 

setwd("~/Desktop/reynolds_lab")

# read in data 
all_inds = read.table("all_inds.txt", header = FALSE, sep ="\t", col.names = c("pop", "id"))
fam = read.table("MGDP_NMDP_rawMetX_MAIS_geno0.05.fam", header = FALSE, sep = " ", col.names = c("pop", "id", "x1","x2","x3","x4"))
all_inds = as.data.frame(all_inds)
fam = as.data.frame(fam)

# get index of all_inds file which matches position of fam file
match_index = match(fam$id, all_inds$id,nomatch = NA_integer_)

# convert the gene column from a factor to a character data type
fam$pop = lapply(fam$pop, as.character)
all_inds$pop = lapply(all_inds$pop, as.character)

# The value of match index at i is the index of the snp file where the match needs to go at x in the meta file (meta$gene[x])
i = 1 
while (i <= length(match_index)) {
  if (is.na(match_index[i])) {
    i = i+1 }
  else {
    all_inds_index = match_index[i]
    fam$pop[i] = all_inds$pop[all_inds_index]
    i = i+1 }
}

is.na(match_index[1])
head(fam)

fam$pop = unlist(fam$pop)

write.table(fam, file="MGDP_NMDP_rawMetX_MAIS_geno0.05_pops.fam",col.names = F, row.names = F, quote=FALSE, sep=' ')
