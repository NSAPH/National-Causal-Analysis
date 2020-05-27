## Compare descriptive statistics.

##   author: Ista Zahn
##  created: April 2019


nthreads <- 1
options(fst_threads = nthreads)
library(data.table)
library(fst)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

cb <- fread("../doc/codebook.csv")

stats_2012 <- fread("../../exp_covar_health_merge_april2019/results/merged_2000_2012_data_stats.csv")
stats_2016 <- fread("../results/merged_1999_2016_data_stats.csv")

stats_2016 <- merge(cb,
                  stats_2016,
                  by.x = "Variable Name",
                  by.y = "var",
                  all.x = FALSE, all.y = TRUE)

stats_2016[, tmp := value]
stats_2012[, tmp := value]

stats <- merge(stats_2016, stats_2012,
               by.x = c("Variable Name 2012", "tmp"),
               by.y = c("var", "tmp"),
               suffixes = c(".2016", ".2012"),
               all = TRUE)

stats[, tmp := NULL]

var.order <- c(names(stats)[1:4],
               paste0(rep(unique(gsub("\\..*",
                                      "",
                                      names(stats)[5:ncol(stats)])),
                          each = 2),
                      c(".2016", ".2012")))

stats <- stats[, ..var.order]
stats <- stats[order((is.na(value.2016) | value.2016 == "") & (is.na(value.2012) | value.2012 == ""),
                     is.na(min.2016) & is.na(min.2012),
                     `Variable Name`,
                     value.2016), ]

fwrite(stats, "../results/merged_stats_check.csv")

