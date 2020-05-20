library(dplyr)
crosswalk_path <- "/nfs/nsaph_ci3/ci3_confounders/locations/crosswalks/zip_zcta/Zip_to_ZCTA_crosswalk_2015_JSI.csv"

crosswalk <- read.csv(crosswalk_path)
crosswalk <- select(crosswalk, ZIP, ZCTA)

se_data <- read.csv("census_zcta_interpolated.csv")
se_data$zcta <- as.numeric(as.character(se_data$zcta))

se_data <- left_join(se_data, crosswalk, by = c("zcta" = "ZCTA"))

for (var in names(se_data)) {
  se_data <- se_data[!is.na(se_data[[var]]),]
}

write.csv(se_data, "census_interpolated_zips.csv")

se_data <- read.csv("census_zcta_uninterpolated.csv")
se_data$zcta <- as.numeric(as.character(se_data$zcta))

se_data <- left_join(se_data, crosswalk, by = c("zcta" = "ZCTA"))

for (var in names(se_data)) {
  se_data <- se_data[!is.na(se_data[[var]]),]
}

write.csv(se_data, "census_uninterpolated_zips.csv")
