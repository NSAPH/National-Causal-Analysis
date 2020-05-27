## requirements: about 200 Gb Memory.

nthreads <- 18

options(fst_threads = nthreads)

library(data.table)
library(fst)

setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

if(dir.exists("ben_merged_tmp")) {
file.remove(list.files("ben_merged_tmp", full.names = TRUE))
} else {
dir.create("ben_merged_tmp")
}

setwd("ben_merged_tmp")

system('split --lines=35000000 /nfs/nsaph_ci3/ci3_health_data/medicare/mortality/2000_2012/exposure_merged/denominator_1999_2013_merge.csv')

infiles <- list.files()

ben1 <- fread(infiles[[1]])
bennames <- tolower(names(ben1))
setnames(ben1, bennames)
write_fst(ben1, paste0("ben_", basename(infiles[[1]]), ".fst"))
rm(ben1)
file.remove(infiles[[1]])

for(input in infiles[-1]) {
tmp <- fread(input, header = FALSE, col.names = bennames)
write_fst(tmp, paste0("ben_", basename(input), ".fst"))
rm(tmp)
file.remove(input)
}

setwd("..")
