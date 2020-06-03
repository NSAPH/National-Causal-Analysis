## Merge in seasonal temperature and humdity to V2

library(data.table)
library(fst)
library(NSAPHutils)

set_threads()

cache_dir <- "../data/merge_cache/"

seasonal_data <- fread("../data/confounder_data/earth_engine/temperature/temperature_seasonal_zipcode_combined.csv")
names(seasonal_data) <- tolower(names(seasonal_data))

for (file in list.files(cache_dir, pattern = ".fst", full.names = T)) {
  x <- read.fst(file, as.data.table = T)
  x <- merge(x, seasonal_data, all.x = T, by = c("zip", "year"))
  write_fst(x, file)
}