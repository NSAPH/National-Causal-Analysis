for (year in 2000:2016) {

  year_data <- readRDS(paste0("../raw_data/annual_pm25/", year, '.rds'))
  year_data$year <- year
  write.csv(year_data, paste0("../raw_data/annual_pm25/", year, '.csv'), row.names=F)
}

out <- NULL
for (year in 2000:2016) {
  year_data <- read.csv(paste0("../raw_data/annual_pm25/", year, '.csv'))
  out <- rbind(out, year_data)
}

write.csv(out, '../processed_data/all_years.csv', row.names=F)
