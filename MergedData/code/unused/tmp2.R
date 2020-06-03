nthreads <- 12

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

chk2000 <- read_fst("./data/cache_data/merged_by_year/confounder_exposure_merged_nodups_health_2000.fst",
                    columns = c("race"),
                    as.data.table = TRUE)

x <- fn_n_obs_unq(chk2000)
a <- data.table(var = "race", stat = names(x), value = unname(x))
a <- dcast(a, ... ~ stat, value.var = "value")
x <- fn_counts(chk2000)
b <- data.table(var = "race", value = x[[1]], count = x[[2]])
b[, percent := round((count / sum(count)) * 100, 2), by = "var"]

y <- merge(a, b, all = TRUE)

chk2000 <- read_fst("./data/cache_data/merged_by_year/confounder_exposure_merged_nodups_health_2000.fst",
                    to = 10,
                    as.data.table = TRUE)

foo <- fread("/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/temperature_annual_zipcode.csv",
             nrows = 10)

head(foo)

chk <- readRDS("/nfs/nsaph_ci3/ci3_exposure/ozone/whole_us/daily/zcta/qd_predictions/neighbor_weight/PREDICTIONGeneral2_OZONE_zipcode_SUBSET_2000_2012.rds")

any(sapply(input_data[c("pm25",
                        "ozone",
                        "census",
                        "brfss",
                        "dartmouth",
                        "temperature")],
       anyDuplicated, by = c("year", "zip")))


entry_age = 65:110

cbind(entry_age,
      cut(entry_age,
          c(seq(65, 100, by = 5), 200),
          include.lowest = TRUE,
          right = FALSE,
          labels = FALSE))


nthreads <- 6
outdir   <- "data/cache_data/"
sharddir <- "data/cache_data/health_by_year/"
qddir <- "data/cache_data/qd_merged/"
years <- 2000:2012


## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
library(zipcode)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

files <- list.files("data/cache_data/merged_by_year/",
                    pattern = "\\.fst",
                    full.names = TRUE)

qdfiles <- list.files(qddir, 
                      pattern = "\\.fst$", 
                      full.names = TRUE)



ea <- rbindlist(lapply(
    qdfiles,
    read_fst,
    columns = c("qid", "year", "popden"),
    as.data.table = TRUE))
ea <- ea[!duplicated(ea[, .(qid, year)])]
eaa <- rbindlist(lapply(
    files,
    read_fst,
    columns = c("qid", "year", "popdensity"),
    as.data.table = TRUE))
atn <- merge(ea, eaa, by = c("qid", "year"))



rm(ea)
rm(eaa)



eaa2 <- unique(eaa[, .(entry_age, entry_age_break)])
setorder(eaa2, entry_age)


cbind(ea2, eaa2)
