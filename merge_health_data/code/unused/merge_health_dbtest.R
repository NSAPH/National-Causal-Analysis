library("MonetDBLite")
library("DBI")
library("dplyr")
library("arkdb")
library("readr")

reverse_string <- function(str) {
  return(sapply(lapply(strsplit(str, NULL), rev), paste, collapse=""))
}

input_files <- c(
health_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/health_data/denominator_1999_2013.csv",
entry_age_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/health_data/entry_age_data.csv",
pm25_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/exposure/pm25/qd_old/qd_old_zip_pm25_long.csv",
ozone_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/exposure/ozone/qd_old/qd_old_zip_ozone_long.csv",
census_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/no_bg_interpolated_zips.csv",
brfss_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/brfss_interpolated.csv",
dartmouth_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/dartmouth_interpolated.csv",
temperature_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/temperature_annual_zipcode.csv",
cluster_cat_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/confounders/Cluster_LongTerm_GEOSChem_20160525.csv",
death_file = "/nfs/nsaph_ci3/users/ci3_mbsabath/merge_old/health_data/deaths.csv")

db <- DBI::dbConnect(MonetDBLite::MonetDBLite(), paste(getwd(), "mdbtest", sep = "/"))

glimpse(read.csv(input_files[["death_file"]]))

my_streamable_readr_csv <- function () 
{
    if (!requireNamespace("readr", quietly = TRUE)) {
        stop("readr package must be installed to use readr-based methods", 
             call. = FALSE)
    }
    read_csv <- getExportedValue("readr", "read_csv")
    write_csv <- getExportedValue("readr", "write_csv")
    read <- function(file, ...) {
        read_csv(file, 
                 col_types = cols(
                     QID = "c",
                     year = "i",
                     dead = "l"),
                 guess_max = 10,
                 ...)
    }
    write <- function(x, path, omit_header = FALSE) {
        write_csv(x = x, path = path, append = omit_header)
    }
    streamable_table(read, write, "csv")
}

## read death data
system.time({
    unark(input_files[["death_file"]], db, lines = 10000000,
          streamable_table = my_streamable_readr_csv())
})


########################################################################

death_file <- input_files[["death_file"]]

db2 <- src_sqlite("temp.db", create = T)
## read death data
system.time({
deaths <- LaF::laf_open(LaF::detect_dm_csv(death_file, header = T, nrows = 10000), ignore_failed_conversion = T)
deaths <- read_chunkwise(deaths)
deaths <- mutate(deaths, QID = as.character(QID))
write_chunkwise(deaths, db2, 'deaths')
})

deaths <- read_chunkwise(tbl(db2, 'deaths'))



system.time({
deaths <- read_chunkwise(laf_open(read_dm("deaths_dm.yml")), 1000000L)
write_chunkwise(deaths, db, 'deaths')
})



## read pm data
pm <- LaF::laf_open(LaF::detect_dm_csv(pm25_file, header = T), ignore_failed_conversion = T) #handle missing data
pm <- read_chunkwise(pm)
pm <- mutate(pm, pm25_qd_old_dist = pm25)
pm <- select(pm, -pm25)
write_chunkwise(pm, db, 'pm')
pm <- read_chunkwise(tbl(db,'pm'))

## read ozone data
ozone <- LaF::laf_open(LaF::detect_dm_csv(ozone_file, header = T), ignore_failed_conversion = T) #handle missing data
ozone <- read_chunkwise(ozone)
ozone <- mutate(ozone, ozone_qd_old_dist = ozone)
ozone <- select(ozone, -ozone)
write_chunkwise(ozone, db, 'ozone')
ozone <- read_chunkwise(tbl(db,'ozone'))

## read census data
census <- LaF::laf_open(LaF::detect_dm_csv(census_file, header = T), ignore_failed_conversion = T) #handle missing data
census <- read_chunkwise(census)
census <- select(census, -X, -zcta)
write_chunkwise(census, db, 'census')
census <- read_chunkwise(tbl(db,'census'))

## read brfss data
brfss <- LaF::laf_open(LaF::detect_dm_csv(brfss_file, header = T), ignore_failed_conversion = T) #handle missing data
brfss <- read_chunkwise(brfss)
write_chunkwise(brfss, db, 'brfss')
brfss <- read_chunkwise(tbl(db,'brfss'))

## read dartmouth data
dartmouth <- LaF::laf_open(LaF::detect_dm_csv(dartmouth_file, header = T), ignore_failed_conversion = T) #handle missing data
dartmouth <- read_chunkwise(dartmouth)
dartmouth <- select(dartmouth, -fips)
write_chunkwise(dartmouth, db, 'dartmouth')
dartmouth <- read_chunkwise(tbl(db,'dartmouth'))

## read temperature data
temperature <- LaF::laf_open(LaF::detect_dm_csv(temperature_file, header = T), ignore_failed_conversion = T) #handle missing data
temperature <- read_chunkwise(temperature)
write_chunkwise(temperature, db, 'temperature')
temperature <- read_chunkwise(tbl(db,'temperature'))

## read cluster cat data
cluster_cat <- LaF::laf_open(LaF::detect_dm_csv(cluster_cat_file, header = T), ignore_failed_conversion = T) #handle missing data
cluster_cat <- read_chunkwise(cluster_cat)
write_chunkwise(cluster_cat, db, 'cluster_cat')
cluster_cat <- read_chunkwise(tbl(db,'cluster_cat'))

## read entry age data
entry_age <- LaF::laf_open(LaF::detect_dm_csv(entry_age_file, header = T, nrows = 10000), ignore_failed_conversion = T) #handle missing data
entry_age <- read_chunkwise(entry_age)
entry_age <- mutate(entry_age, QID = as.character(QID))
write_chunkwise(entry_age, db, 'entry_age')
entry_age <- read_chunkwise(tbl(db,'entry_age'))

## read death data
deaths <- LaF::laf_open(LaF::detect_dm_csv(death_file, header = T, nrows = 10000), ignore_failed_conversion = T)
deaths <- read_chunkwise(deaths)
deaths <- mutate(deaths, QID = as.character(QID))
write_chunkwise(deaths, db, 'deaths')
deaths <- read_chunkwise(tbl(db, 'deaths'))



## read health data
health <- LaF::laf_open(LaF::detect_dm_csv(health_file, header = T, nrows = 10000), ignore_failed_conversion = T) #handle missing data
health <- read_chunkwise(health)
health <- mutate(health, zip = zipcode)
health <- select(health, -zipcode, -FIPS, -Latitude, -Longitude)
write_chunkwise(health, db, 'health')
health <- read_chunkwise(tbl(db,'health'))

out <- left_join(health, pm, by = c("zip", "year"))
out <- left_join(out, ozone, by = c("zip", "year"))
out <- left_join(out, census, by = c("zip" = "ZIP", "year"))
out <- left_join(out, brfss, by = c("zip" = "ZIP", "year"))
out <- left_join(out, dartmouth, by = c("zip" = "ZIP", "year"))
out <- left_join(out, entry_age, by = "QID")
out <- left_join(out, cluster_cat, by = "zip")
out <- left_join(out, temperature, by = c("zip" = "ZIP", "year"))
out <- left_join(out, deaths, by = c("QID", "year"))

out <- mutate(out, followup_year = year - entry_year + 1)
out <- mutate(out, followup_year_plus1 = followup_year + 1)

write_chunkwise(out, "medicare_mortality_2000_2012.csv")
system("rm temp.db")
