##       author: Ista Zahn
##      created: April 2019
##      purpose: merge exposure and confounder
##
## requirements: about 20 GB of memory

nthreads <- 4
cachedir <- "../data/cache_data/"
covar_dir <- "../data/output_data/"

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

## specify input data locations and variable types
input_files <- c(
    pm25_nn =
        "/nfs/nsaph_ci3/ci3_exposure/pm25/whole_us/annual/zipcode/qd_predictions/xiao_pred/neighbor_weight/qd_old_zip_pm_long.csv",
    pm25_no_interp =
        "/nfs/nsaph_ci3/ci3_exposure/pm25/monitors/annual/qd_monitors/zcta/neighbor_weight/qd_monitor_zip_pm_long.csv",
    pm25_ensemble = 
      "/nfs/nsaph_ci3/ci3_exposure/pm25/whole_us/annual/zipcode/qd_predictions_ensemble/ywei_aggregation/all_years.csv",
    ozone =
        "/nfs/nsaph_ci3/ci3_exposure/ozone/whole_us/annual/zcta/qd_predictions/neighbor_weight/qd_old_zip_ozone_long.csv",
    ozone_no_interp =
        "/nfs/nsaph_ci3/ci3_exposure/ozone/monitors/annual/qd_monitors/zcta/neighbor_weight/qd_monitor_zip_ozone_long.csv",
    census =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_census/census_interpolated_zips.csv",
    census_no_interp =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_census/census_uninterpolated_zips.csv",
    brfss =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_brfss/brfss_interpolated.csv",
    brfss_no_interp =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_brfss/brfss_confounders.csv",
    dartmouth =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_dartmouth/dartmouth_interpolated.csv",    
    dartmouth_no_interp =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_dartmouth/dartmouth_health_data.csv",
    temperature =
        "/nfs/nsaph_ci3/ci3_confounders/data_for_analysis/prepped_temperature/annual/temperature_annual_zipcode.csv",
    cluster_cat =
        "/nfs/nsaph_ci3/ci3_exposure/pm25/whole_us/cluster_cat/Cluster_LongTerm_GEOSChem_20160525.csv"
)

input_types <- list(
    pm25_nn =
        c(year = "integer",
          zip = "integer",
          pm25 = "numeric"),
    pm25_no_interp =
      c(year = "integer",
        zip = "integer",
        pm25 = "numeric"),
    pm25_ensemble =
      c(year = "integer",
        ZIP = "integer",
        pm25 = "numeric"),
    ozone =
        c(year = "integer",
          zip = "integer",
          ozone = "numeric"), 
    census =
        c(zcta = "integer",
          year = "integer",
          poverty = "numeric", 
          popdensity = "numeric",
          medianhousevalue = "numeric",
          pct_blk = "numeric", 
          medhouseholdincome = "numeric",
          pct_owner_occ = "numeric",
          hispanic = "numeric", 
          education = "numeric",
          ZIP = "integer"), 
    brfss =
        c(fips = "integer",
          smoke_rate = "numeric", 
          mean_bmi = "numeric",
          year = "integer",
          ZIP = "integer"),
    dartmouth   =
        c(fips = "integer",
          amb_visit_pct = "numeric",
          a1c_exm_pct = "numeric",
          year = "integer",
          ZIP = "integer"), 
    temperature =
        c(ZIP = "integer",
          year = "integer",
          tmmx = "numeric", 
          rmax = "numeric",
          pr = "numeric"), 
    cluster_cat =
        c(cluster_cat = "character",
          zip = "integer"))

no_interp <- grep("no_interp", names(input_files), value = TRUE)
input_types[no_interp] <- input_types[gsub("_no_interp", "", no_interp)]

## read input data
input_data <- lapply(
    names(input_files),
    function(input) {
        fread(input_files[[input]], colClasses = input_types[[input]])
    }
)
names(input_data) <- names(input_files)

## lowercase names for convenience
for(the_name in names(input_data)) {
    setnames(input_data[[the_name]],
             tolower(names(input_data[[the_name]])))
}

## rename no_interp versions
for(the_name in grep("no_interp", names(input_data), value = TRUE)) {
    setnames(input_data[[the_name]],
             paste0(names(input_data[[the_name]]), "_no_interp"))
    setnames(input_data[[the_name]],
             gsub("year_no_interp", "year", names(input_data[[the_name]])))
    setnames(input_data[[the_name]],
             gsub("zip_no_interp", "zip", names(input_data[[the_name]])))    
}

## cleanup
input_data[["pm25_nn"]][,pm25_nn := pm25]
input_data[["pm25_nn"]][,pm25 := NULL]
input_data[["pm25_ensemble"]][,pm25_ensemble := pm25]
input_data[["pm25_ensemble"]][,pm25 := NULL]
input_data[["brfss"]][, fips.brfss := fips]
input_data[["brfss"]][, fips := NULL]
input_data[["brfss_no_interp"]][, fips_no_interp.brfss := fips_no_interp]
input_data[["brfss_no_interp"]][, fips_no_interp := NULL]
input_data[["census"]][, v1 := NULL]
input_data[["census_no_interp"]][, v1_no_interp := NULL]
input_data[["dartmouth"]][, fips.dartmouth := fips]
input_data[["dartmouth"]][, fips := NULL]
input_data[["dartmouth_no_interp"]][, fips_no_interp.dartmouth := fips_no_interp]
input_data[["dartmouth_no_interp"]][, fips_no_interp := NULL]

## check for duplicates. 
dup_check <- sapply(
    input_data[c("pm25_nn",
                 "pm25_no_interp",
                 "pm25_ensemble",
                 "ozone",
                 "ozone_no_interp",
                 "census",
                 "census_no_interp",
                 "brfss",
                 "brfss_no_interp",
                 "dartmouth",
                 "dartmouth_no_interp",
                 "temperature")],
    anyDuplicated, by = c("year", "zip"))

dup_check <- c(dup_check, anyDuplicated(input_data[["cluster_cat"]], by = "zip"))

if(any(dup_check)) stop("duplicate exposure or covariate identifiers detected, fix before merging")

## merge exposures and covariates

print("mergeing pm25 and ozone")
exp_covar <- merge(input_data[["pm25_ensemble"]], input_data[["pm25_no_interp"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".emsemble", ".pm25_no_interp"))
exp_covar <- merge(exp_covar, input_data[["pm25_nn"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".pm25", ".pm25_no_interp"))
exp_covar <- merge(exp_covar, input_data[["ozone"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".pm25", ".ozone"))
exp_covar <- merge(exp_covar, input_data[["ozone_no_interp"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".pm25", ".ozone_no_interp"))
print("merging census")
exp_covar <- merge(exp_covar, input_data[["census"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".census"))
exp_covar <- merge(exp_covar, input_data[["census_no_interp"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".census_no_interp"))
print("merging brfss")
exp_covar <- merge(exp_covar, input_data[["brfss"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".brfss"))
exp_covar <- merge(exp_covar, input_data[["brfss_no_interp"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".brfss_no_interp"))
print("merging dartmouth")
exp_covar <- merge(exp_covar, input_data[["dartmouth"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".dartmouth"))
exp_covar <- merge(exp_covar, input_data[["dartmouth_no_interp"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".dartmouth_no_interp"))
print("merging temperature")
exp_covar <- merge(exp_covar, input_data[["temperature"]],
                   by = c("year", "zip"),
                   all = TRUE,
                   suffixes = c(".xx", ".temperature"))
print("merging cluster_cat")
exp_covar <- merge(exp_covar, input_data[["cluster_cat"]],
                   by = "zip",
                   all = TRUE,
                   suffixes = c(".xx", ".cluster_cat"))

allmiss <- apply(exp_covar, 1, function(x) sum(is.na(x) | x == "")) == (ncol(exp_covar) - 2)
exp_covar <- exp_covar[!allmiss, ]

## combine fips
exp_covar[, fips := fips.brfss]
exp_covar[, fips_no_interp := fips_no_interp.brfss]
exp_covar[is.na(fips), fips := fips.dartmouth]
exp_covar[is.na(fips_no_interp), fips_no_interp := fips_no_interp.dartmouth]
exp_covar[, fips.brfss := NULL]
exp_covar[, fips.dartmouth := NULL]
exp_covar[, fips_no_interp.brfss := NULL]
exp_covar[, fips_no_interp.dartmouth := NULL]


## save merged covariates
print("writing out covariates files")
write_fst(exp_covar, paste0(covar_dir, "merged_covariates.fst"))
fwrite(exp_covar, paste0(covar_dir, "merged_covariates.csv"))
