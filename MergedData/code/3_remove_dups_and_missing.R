##   author: Ista Zahn
##  created: April 2019
## requires: about 60 Gb memory, depends on nthreads
##  purpose: remove missing qid and duplicate QIDs within year.
##           A total of 9588 duplicates were dropped. Of these,
##           649 were selected for removal because other duplicate records
##           with more information were available. The remaining 8939
##           dropped duplicates were selected for removal at random.
##           Additional records were dropped due to missing QID's. See
##           `missing_duplicate_info.csv` in the results directory.

## run 2_check_qid_dups.R first!

nthreads <- 8
outdir   <- "../data/cache_data/"
sharddir <- "../data/cache_data/health_by_year/"
resultdir <- "../results/"
years <- 1999:2016

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
library(parallel)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

### remove dups from main health data
dup_data <- fread(paste0(outdir, "qid_dup_data.csv"))
setkey(dup_data, qid, year)

dup_data[,
         nmissing := apply(.SD, 1, function(x) sum(x == "" | is.na(x))),
         by = c("year", "qid")]

## drop duplicates with less information
ndups <- nrow(dup_data)
dup_data[, keep := nmissing == min(nmissing),
         by = c("year", "qid")]
dup_data <- dup_data[keep == TRUE]
ndropped_missing <- ndups - nrow(dup_data)
print(paste(ndropped_missing, "duplicates with missing values dropped"))

ndups <- nrow(dup_data)
## select at random
dup_data[, rand := sample(1:.N), by = c("year", "qid")]
dup_data[, keep := rand == max(rand), by = c("year", "qid")]
dup_data <- dup_data[keep == TRUE]
dup_data[, nmissing := NULL]
dup_data[, keep := NULL]
dup_data[, rand := NULL]
ndropped_random <- ndups - nrow(dup_data)
print(paste(ndropped_random, "duplicates dropped at random"))

health_files <- list.files(sharddir,
                           pattern = "^health_[0-9]{4}\\.fst",
                           full.names = TRUE)
names(health_files) <- gsub("^health_([0-9]{4})\\.fst",
                                   "\\1",
                                   basename(health_files))


setDTthreads(1)
threads_fst(nr_of_threads = 1)

missing <- mclapply(
    health_files,
    function(x) {
        print(paste("working on", basename(x)))
        tmp <- read_fst(x, as.data.table = TRUE)
        ntmp <- nrow(tmp)
        tmp <- tmp[qid != "" & !is.na(qid)] ## drop missing
        nmiss <- ntmp - nrow(tmp)
        ntmp <- nrow(tmp)
        dupyear <- dup_data[year == unique(tmp[, year])]
        dups <- unique(dupyear[, qid])
        tmp <- tmp[!qid %in% dups]
        tmp <- unique(rbind(tmp, dupyear))
        ndup <- ntmp - nrow(tmp)
        setorder(tmp, year, qid)
        write_fst(tmp, paste0(sharddir, "nodups_", basename(x)))
        data.table(file = basename(x),
                   n_dropped_missing = nmiss,
                   n_dropped_duplicate = ndup)
    },
    mc.cores = nthreads
)

missing <- rbindlist(missing)
fwrite(missing,
       paste0(resultdir, "missing_duplicate_info.csv"))
