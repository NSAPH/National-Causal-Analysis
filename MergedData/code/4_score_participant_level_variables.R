##       author: Ista Zahn
##      created: April 2019
##      purpose: merge exposure and confounder
##
## requirements: about 20 GB of memory, 20 cpu

nthreads <- 1
cachedir <- "../data/cache_data/"
covar_dir <- "../data/output_data/"

## load packages and set options
options(fst_threads = nthreads)
library(data.table)
library(fst)
library(parallel)
setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

## participant - level variables
print("reading health data")
health <- rbindlist(
    mclapply(list.files(paste0(cachedir, "health_by_year"), pattern = "nodups_health_[0-9]{4}\\.fst", full.names = TRUE),
           read_fst,
           as.data.table = TRUE,
           columns = c("year", "qid", "age"),
           mc.cores = 19))

print("computing participant level variables")
followup_entry <-
    health[,
           .(entry_age = min(age, na.rm = TRUE),
             entry_year = min(year, na.rm = TRUE)),
           by = "qid"
]

followup_entry <-
    followup_entry[,
                   entry_age_break := cut(entry_age,
                                          c(seq(65, 100, by = 5), 200),
                                          include.lowest = TRUE,
                                          right = FALSE,
                                          labels = FALSE)
                   ]

write_fst(followup_entry, paste0(covar_dir, "entry_and_followup_years.fst"))
fwrite(followup_entry, paste0(covar_dir, "entry_and_followup_years.csv"))
