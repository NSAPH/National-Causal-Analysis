#### Code to combine centroid zip temperature with spatial weighted temperature

library(data.table)
NSAPHutils::set_threads()

#### Combine Daily Data

spatial <- fread("../data/temperature_annual_zipcode_polygon.csv")
centroid <- fread("../data/temperature_annual_zipcode_point.csv")

new_zips <- setdiff(unique(centroid$ZIP), unique(spatial$ZIP))

out <- rbind(spatial, centroid[centroid$ZIP %in% new_zips])

fwrite(out, "../data/temperature_annual_zipcode.csv")

spatial <- fread("../data/temperature_daily_zipcode_polygon.csv")
centroid <- fread("../data/temperature_daily_zipcode_point.csv")
centroid <-  centroid[ZIP %in% new_zips]

gc()

out <- rbind(spatial,centroid)

fwrite(out, "../data/temperature_daily_zipcode_combined.csv")
