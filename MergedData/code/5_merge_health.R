##       author: Ista Zahn
##      created: April 2019
##      purpose: merge exposure, confounder and health data
##
## requirements: about 60 GB of memory

##   parameters:
##        nthreads: adjust according to availability
##          outdir: the directory where the full data will be written (in fst format)
##        sharddir: the directory where the by-year data will be written (in fst format)
##        resultdir: the directory where missing data reports will be written
##         outfile: file to write the full merged data to

nthreads <- 4
outdir   <- "../data/cache_data/merged_by_year/"
sharddir <- "../data/cache_data/health_by_year/"
resultdir <- "../results/"
covar_dir <- "../data/output_data/"
outfile <- paste0(covar_dir,
                  "health_confounder_exposure_1999_2016_merged.csv")
years <- 1999L:2016L

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

health_files = list.files(sharddir,
                          pattern = "^nodups_health_[0-9]+\\.fst",
                          full.names = TRUE)
hf_years <- as.integer(gsub("^.*([0-9]{4}).*$", "\\1", health_files))
health_files <- health_files[hf_years %in% years]

if(file.exists(outfile)) file.remove(outfile)
if(!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

exp_covar <- read_fst(paste0(covar_dir, "merged_covariates.fst"), as.data.table = TRUE)
followup_entry <- read_fst(paste0(covar_dir, "entry_and_followup_years.fst"))

## merge with health data
missing <- lapply(
    health_files,
    function(hfile) {
        print(paste("merging", basename(hfile)))
        out <- read_fst(hfile,
                        as.data.table = TRUE)
        print(paste("there are", nrow(out), "health records for this year"))
        ## drop rows missing identifiers (note that missing qid was dropped in remove_dups_and_missing.R)
        nobs <- nrow(out)
        out[, zip := as.integer(zip)]
        out <- out[!is.na(zip)]
        ndropped_zips <- nobs - nrow(out)
        print(paste("dropped", ndropped_zips, "rows missing zipcode"))
        ## score death variable
        out[, death_day := lubridate::dmy(bene_dod)]
        out[, dead := !is.na(death_day) & lubridate::year(death_day) == year]
        out[, death_day := NULL]
        setkey(out, year, zip)
        ## merge followup year
        print("merging entry year")
        out <- merge(out, followup_entry, by = "qid",
                     all.x = TRUE, all.y = FALSE,
                     suffixes = c(".medicare", ".entry_followup"))
        out[, followup_year := year - entry_year + 1]
        out[, followup_year_plus_one := followup_year + 1]
        print("merging remaining covariates")
        n_unmatched_covars <- sum(!exp_covar[year == out[1,year][[1]], zip] %in% unique(out[, .(zip)])[[1]])
        print(paste(n_unmatched_covars, "unmatched zipcodes dropped from covariate data"))
        out <- merge(out, exp_covar,
                     by = c("year", "zip"),
                     all.x = TRUE,
                     all.y = FALSE,
                     suffixes = c(".medicare", ".covar"))
        ## combine fips
        out[, fips := fips.medicare]
        out[is.na(fips), fips := fips.covar]
        out[, fips2 := fips_no_interp]
        out[, fips_no_interp := fips.medicare]
        out[is.na(fips_no_interp), fips_no_interp := fips2]
        out[, fips.medicare := NULL]
        out[, fips.covar := NULL]
        out[, fips2 := NULL]
        print(paste("done; out has", nrow(out), "rows"))
        print("all merging complete, writting to disk")
        if(!file.exists(outfile)) fwrite(out[FALSE], outfile)
        fwrite(out, outfile, append = TRUE)
        write_fst(out, paste0(outdir,
                              "confounder_exposure_merged_",
                              basename(hfile)))
        data.table(ndropped_missing_zip = ndropped_zips)
    }
)

missing <- rbindlist(missing)
fwrite(missing,
       paste0(resultdir, "missing_zipcode_info.csv"))

