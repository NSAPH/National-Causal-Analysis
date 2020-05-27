## QD's version has 56 states, this version has 57. Find out why.


nthreads = 1

options(fst_threads = nthreads)

library(data.table)
library(fst)

setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

merged_files <- list.files(pattern = "confounder_exposure_merged_health_[0-9]+.fst")


mystates <- rbindlist(lapply(merged_files[2:14],## QD omitted 1999 and 2013
                           read_fst, columns = "statecode", as.data.table = TRUE))

n_mystates <- mystates[, .N, by = "statecode"]


qd_merged_files <- list.files("qd_merged_tmp", pattern = "\\.fst", full.names = TRUE)

qdstates <- rbindlist(lapply(qd_merged_files,
                           read_fst, columns = "statecode", as.data.table = TRUE))

n_qdstates <- qdstates[, .N, by = "statecode"]

merge(n_mystates, n_qdstates, by = "statecode", all = TRUE, suffixes = c(".Ista", ".QD"))


myqid <- rbindlist(lapply(merged_files[2:14],## QD omitted 1999 and 2013
                           read_fst, columns = "qid", as.data.table = TRUE))



#############################
tmp <- read_fst("confounder_exposure_merged_health_2011.fst", columns = c("zip", "popdensity"), as.data.table = TRUE)

tmp[mean(log(popdensity))]

