##

library(NSAPHutils)

set_threads()

library(data.table)
library(fst)

old_merged <- "../data/cache_data/merged_by_year/"
new_merged <- "../data/cache_data/merged_by_year_v2/"

death_dates <- read_data(old_merged, years = 1999:2016, columns = c("qid","bene_dod"))
death_dates <- death_dates[bene_dod != ""]
death_dates <- death_dates[qid != ""]
death_dates[, death_count  := .N, by = c("qid", "bene_dod")]
death_dates[, qid_count := .N, by = qid]
# more rows assosciated with an individual than assosciated with their death
# implies that an individual has multiple reported DODs in the data set
death_dates <- death_dates[qid_count > death_count] 
death_dates[, c("bene_dod", "qid_count", "death_count") := NULL]

setkey(death_dates, qid)

has_died <- NULL

for (filename in list.files(old_merged)) {
  year_data <- read_fst(paste0(old_merged , filename), as.data.table = T)
  setkey(year_data, qid)
  year_data <- year_data[!death_dates]
  year_data[dead == F, bene_dod := ""] # remove death dates from different years
  
  if (!is.null(has_died))  {
    setkey(has_died, qid)
    year_data <- year_data[!has_died]
  }
  
  has_died <- rbind(has_died, year_data[dead == T, .(qid)])
  write_fst(year_data, paste0(new_merged, filename))
}
