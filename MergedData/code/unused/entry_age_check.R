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


nthreads <- 4
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
    columns = c("entryage", "entryagebreak"),
    as.data.table = TRUE))

eat <- ea[, .N, by = c("entryage", "entryagebreak")]

#ea2 <- unique(ea)
#setorder(ea2, entryage)


eaa <- ea <- rbindlist(lapply(
    files,
    read_fst,
    columns = c("entry_age", "entry_age_break", "fips"),
    as.data.table = TRUE))
eaa <- eaa[!is.na(fips), .(entry_age, entry_age_break)]

eaat <- eaa[, .N, by = c("entry_age", "entry_age_break")]

atn <- merge(eat, eaat, by.x = c("entryage", "entryagebreak"), by.y = c("entry_age", "entry_age_break"))


rm(ea)
rm(eaa)


y <- rbindlist(lapply(
    qdfiles,
    read_fst,
    columns = c("year"),
    as.data.table = TRUE))
yt <- y[, .N, by = c("year")]

#ea2 <- unique(ea)
#setorder(ea2, entryage)


yy <- ea <- rbindlist(lapply(
    files,
    read_fst,
    columns = c("fips", "year"),
    as.data.table = TRUE))
yy <- yy[!is.na(fips), .(year)]

yyt <- yy[, .N, by = c("year")]




h99 <- fread("../data/cache_data/health_by_year/health_1999.csv")
cat(metadata_fst("../data/cache_data/health_by_year/health_2000.fst")$columnNames,
    sep = '", "')
names(h99) <- c("sex", "race", "age", "hmoind", "hmo_mo", "year", "bene_dod", "qid", "statecode", "fips", "latitude", "longitude", "dodflag", "dual", "zipcode_r", "zip")
h99 <- h99[year == 1999]
write_fst(h99, "../data/cache_data/health_by_year/health_1999.fst")

h99 <- h99[!duplicated(h99[, .(year, qid)])]
write_fst(h99, "../data/cache_data/health_by_year/nodups_health_1999.fst")
