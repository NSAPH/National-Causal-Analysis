##       author: Ista Zahn
##      created: April 2019
##      purpose: shard Medicare denominator data to fst format by year to facilitate merging by year
## requirements: about 20 GB of memory

##   parameters:
##        nthreads: adjust according to availability
##          outdir: the directory where the full data will be written (in fst format)
##        sharddir: the directory where the by-year data will be written (in fst format)
##           years: the years to include

nthreads <- 6
outdir   <- "../data/cache_data/"
sharddir <- "../data/cache_data/health_by_year/"
years    <- 1999:2016


## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(parallel)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)


## split the data (slow, but we only have to do it once...
hfile <- "/nfs/nsaph_ci3/ci3_health_data/medicare/mortality/1999_2016/unmerged_data/Denominator_1999_2016.csv"

start <- setwd(sharddir)
shard <- mclapply(
    as.character(years),
    function(year) {
        system(paste0('rg --no-line-number ",', year, '," ', hfile, ' > health_', year, '.csv'))
        invisible(TRUE)
    },
    mc.cores = nthreads
)
setwd(start)

## convert to fst
health_files <- list.files(sharddir,
                           pattern = "^health_[0-9]{4}\\.csv",
                           full.names = TRUE)

hf_info <- c(qid = "character",
             dodflag = "character",
             bene_dod = "character",
             sex = "integer",
             race = "integer",
             year = "integer",
             age = "integer",
             hmo_mo = "character",
             hmoind = "character",
             fips = "integer",
             statecode = "character",
             latitude = "numeric",
             longitude = "numeric",
             dual = "intecter",
             zipcode_r = "character",
             death = "integer")

for(hf in health_files) {
    health <- fread(hf, col.names = names(hf_info),
                    colClasses = unname(hf_info),
                    header = FALSE)
    health[, zip := stringi::stri_reverse(zipcode_r)]
    health[, zipcode_r := NULL]
    setkey(health, zip, year)
    write_fst(health,
              paste0(sharddir, gsub("\\.csv", "\\.fst", basename(hf))))
    file.remove(hf)
}

print("all done.")
