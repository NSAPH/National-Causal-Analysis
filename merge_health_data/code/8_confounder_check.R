##       author: Ista Zahn
##      created: April 2019
##      purpose: check confounder distributions
##
## requirements: about 20 GB of memory

nthreads <- 4
sharddir <- "../data/cache_data/health_by_year/"
covar_dir <- "../data/output_data/"

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

confounders <- read_fst(paste0(covar_dir, "merged_covariates.fst"),
                        as.data.table = TRUE)

## drop rows that are all missing
value.cols <- setdiff(names(confounders), c("zip", "year"))
conf_all <- apply(confounders[, ..value.cols],
                  1,
                  function(x) all(is.na(x)))
confounders <- confounders[!conf_all]

health_year_zip <- unique(
    read_fst("../data/cache_data/health.fst",
             columns = c("year", "zip"),
             as.data.table = TRUE))


health_nomatch <- health_year_zip[!confounders, on = c("zip", "year")]
confounders_nomatch <- confounders[!health_year_zip, on = c("zip", "year")]

table(confounders_nomatch$year) / table(confounders$year)

table(health_nomatch$year) / table(health_year_zip$year)


dartmouth_interp = fread("/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/dartmouth_interpolated.csv")
dartmouth_original <- fread("/nfs/home/I/izahn/shared_space/ci3_mbsabath/prepare_census_data/dartmouth_health_data.csv")

exp_qd <- readRDS("/nfs/bigdata_nobackup_ci3/n/ci3_nsaph/NEJM/ExposureNational/CovariateSummary_20160203.rds")
setDT(exp_qd)

dartmouth_var_names <- c(grep("^PctA1c", names(exp_qd), value = TRUE),
                         grep("^PctAml", names(exp_qd), value = TRUE))

exp_qd_dartmouth <- exp_qd[, c("zipcode", "Latitude", "Longitude",
                               dartmouth_var_names),
                           with = FALSE]

exp_qd_dartmouth <- melt(exp_qd_dartmouth,
                         id.vars = c("zipcode", "Latitude", "Longitude"),
                         measure.vars = dartmouth_var_names)

exp_qd_dartmouth[, year := gsub("PctA1c", "", variable)]
exp_qd_dartmouth[, year := as.integer(gsub("PctAml", "", year))]
exp_qd_dartmouth[, variable := gsub("[0-9]{4}$", "", variable)]

exp_qd_dartmouth <- dcast(exp_qd_dartmouth, ... ~ variable, value.var = "value")

names(exp_qd_dartmouth)[1] <- "zip"
exp_qd_dartmouth[, zip := as.integer(as.character(zip))]
names(exp_qd_dartmouth) <- tolower(names(exp_qd_dartmouth))

names(dartmouth_original) <- c("fips", "pcta1c", "pctaml", "year", "zip")

dartmouth <- merge(exp_qd_dartmouth, dartmouth_original,
                   by = c("zip", "year"),
                   suffixes = c(".qd", ".ib"))
dartmouth <- melt(dartmouth, measure.vars = c("pcta1c.qd", "pcta1c.ib", "pctaml.qd", "pctaml.ib"))
dartmouth[, source := gsub("^.*\\.", "", variable)]
dartmouth[, variable := gsub("\\..*$", "", variable)]
dartmouth <- dcast(dartmouth, ... ~ variable)


library(ggplot2)

ggplot(dartmouth,
       mapping = aes(x = pcta1c, fill = source)) +
    geom_density() +
    facet_wrap(~year)
