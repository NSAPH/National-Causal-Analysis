## QD's version has 56 states, this version has 57. Find out why.


nthreads = 1

options(fst_threads = nthreads)

library(data.table)
library(fst)

setDTthreads(nthreads)
threads_fst(nr_of_threads = nthreads)

merged_files <- list.files(pattern = "confounder_exposure_merged_health_[0-9]+.fst")[2:14]

dups <- lapply(merged_files, 
               function(x) {
                        tmp <- read_fst(x, columns = c("qid"), as.data.table = TRUE)
                        tmp <- group_by(tmp, qid)
                        tmp <- summarize(tmp, n= n())
                        tmp <- filter(tmp, n > 1)
                        tmp <- select(tmp, qid)
                        return(tmp)}
)

out <- NULL
for (i in 1:length(dups)) {
  out <- union(out, dups[[i]]$qid)
}

write.csv(data.frame(qid = out), "duplicated_qids.csv")