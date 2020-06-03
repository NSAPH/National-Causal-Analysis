
nthreads <- 4
outdir   <- "../../data/cache_data/merged_by_year/"
sharddir <- "../../data/cache_data/health_by_year/"
resultdir <- "../../results/"
covar_dir <- "../../data/output_data/"
outfile <- paste0(covar_dir,
                  "health_confounder_exposure_1999_2016_merged.csv")
merged_sharddir <- "../../data/cache_data/merged_by_year/"

## load packages and set options
options(fst_threads = nthreads)

library(data.table)
library(fst)
library(parallel)

setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

merged_files <- list.files(
    merged_sharddir,
    pattern = "confounder_exposure_merged_nodups_health_[0-9]+\\.fst",
    full.names = TRUE
)

mclapply(merged_files,
         function(x) {
             print(paste("working on ", basename(x)))
             tmp <- read_fst(x, as.data.table = TRUE)
             tmp[, followup_years_plus_one := NULL]
             tmp[, followup_year_plus_one := followup_year + 1]             
             write_fst(tmp, x)
             return(TRUE)
         },
         mc.cores = 4)


file.remove(outfile)
lapply(merged_files,
         function(x) {
             print(paste("working on ", basename(x)))
             tmp <- read_fst(x, as.data.table = TRUE)
             if(!file.exists(outfile)) fwrite(tmp[FALSE], outfile)
             fwrite(tmp, outfile, append = TRUE)
             return(TRUE)
         })


         


exd <- readRDS("/nfs/nsaph_ci3/ci3_health_data/waiting_for_info/multiresolution_data/finaldata17Aug2017.Rds")




nthreads <- 12

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)



tst <- fread("/nfs/nsaph_ci3/ci3_health_data/medicare/cvd/2000_2014/yazdi/mahdieh_hospitalization_addition.csv", skip = 10000000, nrows = 10000000)
fread("/nfs/nsaph_ci3/ci3_health_data/medicare/cvd/2000_2014/yazdi/mahdieh_hospitalization_addition.csv", skip = 13081610, nrows = 5, header = FALSE)


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
