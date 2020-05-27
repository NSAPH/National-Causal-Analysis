## requirements: about 200 Gb Memory.

nthreads = 18
outfile = "health_confounder_exposure_merged.csv"

options(fst_threads = nthreads)

library(data.table)
library(fst)

setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

print("gathering variable info")

merged_files <- list.files(pattern = "confounder_exposure_merged_health_[0-9]+.fst")

merged_data <- read_fst(merged_files[[10]], as.data.table = TRUE)

id.vars <- c("fips", "fips.x", "fips.y", "zip", "zipcode_r", "zcta", "v1",
             "statecode", "hmoind", "year", "qid", "latitude", "longitude", "cluster_cat")

n_unique <- merged_data[, lapply(.SD, uniqueN, na.rm = TRUE)]

cat.vars <- names(unlist(n_unique))[unlist(n_unique) < 10]
cat.vars <- setdiff(cat.vars, id.vars)

num.vars <- names(merged_data)[merged_data[FALSE, sapply(.SD, is.numeric)]]
num.vars <- setdiff(num.vars, unique(c(cat.vars, id.vars)))

print("processing id variables")
merged_data <- rbindlist(lapply(merged_files, read_fst, columns = id.vars, as.data.table = TRUE))
n_unique_id <- merged_data[, lapply(.SD, function(x) {
                                         c(n_observed = length(x[!is.na(x)]), n_unique = uniqueN(x, na.rm = TRUE))
                                     })]
n_unique_id <- dcast(melt(n_unique_id[, stat := c("n_observed", "n_unique")],
                          variable.name = "var", id.vars = "stat"),
                     var ~ stat)

rm(merged_data)
gc()

print("processing categorical variables")
merged_data <- rbindlist(lapply(merged_files, read_fst, columns = cat.vars, as.data.table = TRUE))
n_unique_cat <- merged_data[, lapply(.SD,
                                     function(x) {
                                         c(n_observed = length(x[!is.na(x)]), n_unique = uniqueN(x, na.rm = TRUE))
                                     })]
n_unique_cat <- dcast(melt(n_unique_cat[, stat := c("n_observed", "n_unique")],
                           variable.name = "var", id.vars = "stat"), var ~ stat)
cat_counts <- lapply(cat.vars, function(var) merged_data[, .(var = var, count = .N), by = var])
for(i in cat_counts) {
    setnames(i, c("value", "var", "count"))
    setcolorder(i, c("var", "value", "count"))
}
cat_counts <- rbindlist(cat_counts)

rm(merged_data)
gc()

print("processing numeric variables")
merged_data <- rbindlist(lapply(merged_files, read_fst, columns = num.vars, as.data.table = TRUE))
print("data import complete, calculating statistics")
num_sum <- merged_data[, lapply(.SD,
                                function(x) {
                                    c(n_observed = length(x[!is.na(x)]),
                                      min = min(x, na.rm = TRUE),
                                      mean = mean(x, na.rm = TRUE),
                                      max = max(x, na.rm = TRUE),
                                      sd = sd(x, na.rm = TRUE))
                                }),
                       .SDcols = num.vars]
num_sum_long <- dcast(melt(num_sum[, stat := c("n_observed", "min", "mean", "max", "sd")],
                           variable.name = "var", id.vars = "stat"),
                      var ~ stat)

all_stats <- rbind(n_unique_id, merge(cat_counts, n_unique_cat, by = "var"), num_sum_long, fill = TRUE)

print("writing out results")

fwrite(all_stats, outfile)

nrow(merged_data)

save(all_stats, n_unique_id, n_unique_cat, cat_counts, num_sum_long, file = gsub("\\.csv", ".RData", outfile))



## note: we started with 548727053, ended up with 548977471. need to figure out where the extra 250418 came from...

