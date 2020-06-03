## Author: Ista Zahn
## Created: April 2019
## Purpose: Identify duplicates in health data denominator data
## Requirements: about 30 Gb memory, 60 minutes

nthreads <- 12
outdir   <- "../results/duplicate_qid/"
cachedir <- "../data/cache_data/"

options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

if(!dir.exists(outdir)) dir.create(outdir)

health_files <- list.files("../data/cache_data/health_by_year",
                           pattern = "^health_[0-9]{4}\\.fst",
                           full.names = TRUE)
names(health_files) <- paste0("year_",
                              gsub("^health_([0-9]{4})\\.fst",
                                   "\\1",
                                   basename(health_files)))

health_dup_summaries <- lapply(
    health_files,
    function(x) {
        print(paste0("working on ", basename(x)))
        qid_counts <- read_fst(x, columns = c("qid", "year"), as.data.table = TRUE)
        qid_counts <- qid_counts[qid != ""]
        qid_counts[, number_of_qid_repeats := .N, by = c("qid", "year")]
        qid_dups <- unique(qid_counts[number_of_qid_repeats > 1, qid])
        qid_dup_summary <- qid_counts[, .N, by = c("number_of_qid_repeats", "year")]
        rm(qid_counts)
        qid_dup_data <- read_fst(x, as.data.table = TRUE)[qid %in% qid_dups]
        setorder(qid_dup_data, year, qid)
        list(data = qid_dup_data, summary = qid_dup_summary)
    })

health_dup_info <- rbindlist(lapply(health_dup_summaries, function(x) x[["summary"]]))
health_dup_data <- rbindlist(lapply(health_dup_summaries, function(x) x[["data"]]))
fwrite(health_dup_info, paste0(outdir, "qid_dup_summary.csv"))
fwrite(health_dup_data, paste0(outdir, "qid_dup_data.csv"))

## copy to data cache directory
file.copy(paste0(outdir, "qid_dup_data.csv"),
          paste0(cachedir, "qid_dup_data.csv"))

