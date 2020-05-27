## check health and exposure data before merging.

##   author: Ista Zahn
##  created: April 2019
## requires: about 45 Gb memory
##  purpose: remove duplicate QIDs within year.
##           n: 548727053 ==> 548726671, i.e., removed 382 duplicate entries.

## run 2_remove_dups.R first!

nthreads <- 4
outdir   <- "../data/cache_data/"
sharddir <- "../data/cache_data/health_by_year/"
qddir <- "../data/cache_data/qd_merged/"
years <- 2000:2012


## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
library(zipcode)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

pm25 <- fread("/nfs/nsaph_ci3/ci3_exposure/pm25/whole_us/annual/zipcode/qd_predictions_ensemble/ywei_aggregation/all_years.csv")


pm25 <- pm25[!is.na(pm25) | pm25 == ""]

files <- list.files(sharddir,
                    pattern = "nodup.*\\.fst",
                    full.names = TRUE)
qdfiles <- list.files(qddir, 
                      pattern = "\\.fst$", 
                      full.names = TRUE)


health <- rbindlist(lapply(
  files,
  read_fst,
  columns = c("year", "zip", "qid"),
  as.data.table = TRUE)
)


dups <- duplicated(healt[, .(year, qid)])
table(dups)

qdhealth <- rbindlist(lapply(
  qdfiles,
  read_fst,
  columns = c("year", "zipcode", "qid"),
  as.data.table = TRUE)
)

qddups <- duplicated(qdhealth[, .(year, qid)])
table(qddups) ## here is the extra 50K in pm25 / ozone
qdhealth <- qdhealth[!qddups]

setnames(qdhealth, c("year", "zip", "qid"))

dff <- health[!qdhealth, on = c("year", "zip", "qid")] ## here are the extras in ours.

rm(health)
rm(qdhealth)

health_dff <- rbindlist(lapply(
  files,
  function(file) {
    tmp <- read_fst(file, as.data.table = TRUE)
    merge(tmp, dff, by = c("year", "zip", "qid"), all = FALSE)
  }
  )
)


fwrite(health_dff, paste0(outdir, "year_zip_qid_not_in_qd_original.csv"))

head(health_dff)
health_dff[, sapply(.SD, function(x) sum(is.na(x)))]
