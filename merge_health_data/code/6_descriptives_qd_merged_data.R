## requirements: about 100 Gb Memory.
## run qd_csv_to_fst.R first!

##       author: Ista Zahn
##      created: April 2019
##      purpose: compute descriptive statistics for merged exposure, confounder and health data
## requirements: about 40 GB of memory

##   parameters:
##          nthreads: adjust according to availability
##        resultsdir: the directory where results will be stored
##   merged_sharddir: the directory where the by-year merged data
##                    produced by merge_health_data.R can be found


nthreads <- 4 ## higher values might require more memory
resultsdir   <- "../results/"
merged_sharddir <- "../data/cache_data/merged_by_year/"

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)



merged_files <- list.files("../data/cache_data/qd_merged",
                           pattern = "qd_.*\\.fst",
                           full.names = TRUE)


id.vars <- c("fips", "zipcode_r", "qid", "hmoind",
"latitude", "longitude", "zipcode", "bene_dod")

cat.vars <- c("sex", "race", "dodflag", "dual", "dead", "cluster_cat", "entryagebreak",
              "statecode", "baserace", "basesex", "basedual")

num.vars <- c("age", "year", "entryage", "entryyear", "followupyear", "followupyearplusone", 
"pm25", "ozonesummer", "temperature", "humidity", "hmo_mo",
"ozoneannual", "monitorozonesummer", "monitorpm25", "bmi", "smokerate", 
"hsppct", "blkpct", "mdhsicm", "mdvlhs", "pctblpvt", "pctblsch", 
"popden", "pctownhs", "pctldl", "pcta1c", "pctaml")

## make sure we have everything
id.vars <- unique(
    c(id.vars,
      setdiff(metadata_fst(merged_files[[1]])[["columnNames"]],
              c(id.vars, cat.vars, num.vars))
      )
)


## Utility functions
fn_n_obs_unq  <- function(dt) {
    n_tot <- nrow(dt)
    dt <- na.omit(dt)
    out <- c(n_observed = nrow(dt), n_unique = uniqueN(dt))
    c(out, n_missing = (n_tot - out[["n_observed"]]))
}

fn_counts <- function(dt) {
    nt <- names(dt)
    dt[, .N, by = nt]
}

fn_num_sum <- function(dt) {
    dt <- na.omit(dt)
    if(!dt[, sapply(.SD, is.numeric)]) dt <- dt[, lapply(.SD, as.numeric)]
    x <- dt[, sapply(.SD, function(v) {
        sapply(c(min = min, median = median, mean = mean, max = max, sd = sd),
               function(fun) fun(v))
    })]
}

## Calculate statistics

print("computing unique values")
n_unique <- rbindlist(
    lapply(c(id.vars, cat.vars, num.vars),
           function(var) {
               print(paste("working on", var))
               merged_data <- rbindlist(
                   lapply(merged_files,
                          read_fst,
                          #from = 1,
                          #to = 50,
                          columns = var,
                          as.data.table = TRUE))
               x <- fn_n_obs_unq(merged_data)
               data.table(var = var, stat = names(x), value = unname(x))
           })
)
n_unique <- dcast(n_unique, ... ~ stat, value.var = "value")

gc()

print("computing counts for categorical variables")
tab <- rbindlist(
    lapply(cat.vars,
           function(var) {
               print(paste("working on", var))
               merged_data <- rbindlist(
                   lapply(merged_files,
                          read_fst,
                          #from = 1,
                          #to = 50,
                          columns = var,
                          as.data.table = TRUE))
               x <- fn_counts(merged_data)
               data.table(var = var, value = x[[1]], count = x[[2]])
           })
)
tab[, percent := round((count / sum(count)) * 100, 2), by = "var"]

print("computing stats for numeric variables")
numsum <- rbindlist(
    lapply(num.vars,
           function(var) {
               print(paste("working on", var))
               merged_data <- rbindlist(
                   lapply(merged_files,
                          read_fst,
                          #from = 1,
                          #to = 50,
                          columns = var,
                          as.data.table = TRUE))
               x <- fn_num_sum(merged_data)
               data.table(var = var, stat = rownames(x), value = x[, 1])
           })
)
numsum[, value := round(value, digits = 4)]
numsum[, stat := factor(stat, levels = c("min", "mean", "median", "max", "sd"))]
numsum <- dcast(numsum, ... ~ stat, value.var = "value")

all_stats <- merge(n_unique, tab, all = TRUE)
all_stats <- merge(all_stats, numsum, all = TRUE)
all_stats[, var := factor(var, levels = c(cat.vars, num.vars, id.vars))]
setorder(all_stats, var, value)


print("writing out results")
fwrite(all_stats, paste0(resultsdir, "qd_merged_data_stats.csv"))
save(all_stats, n_unique, tab, numsum,
     file = paste0(resultsdir, "qd_merged_data_stats.RData"))
