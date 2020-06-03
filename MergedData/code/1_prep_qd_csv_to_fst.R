##       author: Ista Zahn
##      created: April 2019
##      purpose: share QD's merged data to fst format to facilitate descriptive stats
## requirements: about 170 GB of memory

##   parameters:
##        nthreads: adjust according to availability
##        sharddir: the directory where the sharded data will be written (in fst format)

nthreads <- 6
sharddir <- "../data/cache_data/qd_merged/"


## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

## make sure starting directory is clean
start_dir <- setwd(sharddir)
existing <- list.files()
if(length(existing) > 0) file.remove(existin)

## split into shards
system('split --lines=35000000 /nfs/nsaph_ci3/ci3_health_data/medicare/mortality/2000_2012/exposure_merged/denominator_1999_2013_merge.csv')

infiles <- list.files()

## handle first one separately, since it has column names
qd1 <- fread(infiles[[1]])
qdnames <- tolower(names(qd1))
setnames(qd1, qdnames)
write_fst(qd1, paste0(sharddir, "qd_", basename(infiles[[1]]), ".fst"))
rm(qd1)
file.remove(infiles[[1]])

## process the rest
for(input in infiles[-1]) {
tmp <- fread(input, header = FALSE, col.names = qdnames)
write_fst(tmp, paste0(sharddir, "qd_", basename(input), ".fst"))
rm(tmp)
file.remove(input)
}

## restart working directory
setwd(start_dir)
