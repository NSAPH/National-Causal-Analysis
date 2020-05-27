library(dplyr)

aggregate_by_county <- function(brfss) {
  
  brfss <- select(brfss, X_STATE,CTYCODE, X_SMOKER2, bmi)
  brfss$CTYCODE[brfss$CTYCODE == 777 | brfss$CTYCODE == 999] <- NA
  brfss$fips <- as.numeric(paste0(sprintf("%02d", brfss$X_STATE), sprintf("%03d", brfss$CTYCODE)))
  brfss$X_SMOKER2[brfss$X_SMOKER2 == 9] <- NA 
  brfss$current_smoker <- (brfss$X_SMOKER2 %in% c(1,2,3))
  brfss <- group_by(brfss, fips)
  brfss_state <- summarise(brfss, smoke_rate = mean(current_smoker, na.rm = T), mean_bmi = mean(bmi, na.rm=T) )
  return(brfss_state)
}

prep_bmi <- function(year, bmi) {
  if (year <=2000) {
    bmi[bmi==999] <- NA
    bmi <- bmi * 0.1
  } else if (year == 2001) {
    bmi[bmi==999999] <- NA
    bmi <- bmi * 0.0001
  } else {
    bmi[bmi==9999] <- NA
    bmi <- bmi * 0.01
  }
  return(bmi)
}

brfss_path <- "/nfs/nsaph_ci3/ci3_confounders/brfss/csv/brfss_"
out <- NULL
for (year in 1999:2012) {
  year_data <- read.csv(paste0(brfss_path, year, ".csv"))
  
  #Handle variation in variable names across years
  if (year == 1999) {
    year_data$X_BMI2 <- year_data$X_BMI
  } else if (year == 2003) {
    year_data$X_BMI2 <- year_data$X_BMI3
  } else if (year == 2004) {
    year_data$X_BMI2 <- year_data$X_BMI4
  } else if (year%in% c(2005, 2006, 2007, 2008, 2009, 2010)) {
    year_data$X_BMI2 <- year_data$X_BMI4
    year_data$X_SMOKER2 <- year_data$X_SMOKER3
  } else if (year %in% c(2011, 2012, 2013)) {
    year_data$X_BMI2 <- year_data$X_BMI5
    year_data$X_SMOKER2 <- year_data$X_SMOKER3
    year_data$CTYCODE <- year_data$CTYCODE1
  } else if (year == 2013) {
    year_data$X_BMI2 <- year_data$X_BMI5
    year_data$X_SMOKER2 <- year_data$X_SMOKER3
    year_data$CTYCODE <- year_data$CTYCODE1
  }
  
  year_data$bmi <- prep_bmi(year, year_data$X_BMI2)
  
  #aggregate data
  year_data <- aggregate_by_county(year_data)
  year_data$year <- year
  out <- rbind(out, year_data)
}

## Output county level estimates
county_level <- out[!is.na(out$fips),]
write.csv(county_level, "brfss_county_confounders.csv", row.names = F)

## Link zipcodes with state FIPS codes, then merge with county code in dartmouth data
zips <- read.csv("esri_zipcode_2010.csv")
state_codes <- read.csv("state.txt", sep="|") #needed to assemble full FIPS code

zips$STATE <- as.character(zips$STATE)
state_codes$STUSAB <- as.character(state_codes$STUSAB)

####### Rename variables to avoid name clash
state_codes$st_fips <- state_codes$STATE
state_codes$STATE <- NULL

zips <- left_join(zips, state_codes, by = c("STATE" = "STUSAB"))
zips$fips <- as.numeric(paste0(sprintf("%02d", zips$st_fips), sprintf("%03d", zips$CTY1FIPS)))
#######

# Create zipcode list for all years to allow for temporal imputation
year_zips <- zips
zips <- NULL
for (year in 1999:2016) {
  year_zips$year <- year
  zips <- rbind(zips, year_zips)
}

## Join zipcodes to county codes
out$year <- as.numeric(out$year)
out <- left_join(zips, out, by = c("fips", "year"))
out <- select(out, fips, smoke_rate, mean_bmi, year, ZIP)
for (var in names(out)) {
  out[[var]] <- as.numeric(out[[var]])
}

write.csv(out, "brfss_confounders.csv", row.names = F)

### Temporal interpolation

source("interpolate_function.R")

for (var in c("smoke_rate", "mean_bmi")) {
  print(var)
  out[[var]] <- interpolate_ts(out, var, location = "ZIP")
  county_level[[var]] <- interpolate_ts(county_level, var, location = "fips")
}

out <- out[!is.na(out$mean_bmi),]
county_level <- county_level[!is.na(county_level$mean_bmi),]

write.csv(out, "brfss_interpolated.csv", row.names=F)
write.csv(county_level, "brfss_county_interpolated.csv", row.names = F)
