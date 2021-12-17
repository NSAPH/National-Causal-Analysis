# Create Maps from aggregated data

library(data.table)
library(fst)
library(NSAPHutils)
library(NSAPHplatform)
library(sf)
library(ggplot2)
library(viridis)





zip_list <- list()
zip_list[["2000"]] <- st_read("../data/2000_shape_file/ESRI00USZIP5_POLY_WGS84.shp")
zip_list[["2016"]] <- st_read("../data/2016_shape_file/ESRI16USZIP5_POLY_WGS84.shp")
joel_pm_path <- "../data/joel_pm/"
rm_pm_path <- "../data/rm_pm/zip_pm25_"
joel_no2_path <- "../data/joel_no2/"
joel_ozone_path <- "../data/joel_o3/"
set_threads()



for (year in c(2000, 2016)) {
  
  rm_pm <- fread(paste0(rm_pm_path, year, ".csv"))
  rm_pm <- de_duplicate(rm_pm, "ZIP")
  setnames(rm_pm, "pm25", "rm_pm25")
  rm_pm[, STATE := NULL]
  
  joel_pm <- fread(paste0(joel_pm_path, year, ".csv"))
  setnames(joel_pm, "pm25", "joel_pm25")
  joel_pm[, year := NULL]

  joel_no2 <- fread(paste0(joel_no2_path, year, ".csv"))
  joel_no2[, year := NULL]

  joel_ozone <- fread(paste0(joel_ozone_path, year, ".csv"))
  joel_ozone[, year := NULL]

  exposure <- merge(rm_pm, joel_pm, by = "ZIP", all = T)
  exposure <- merge(exposure, joel_no2, by = "ZIP", all = T)
  exposure <- merge(exposure, joel_ozone, by = "ZIP", all = T)
  exposure[, ZIP := int_to_zip_str(ZIP)]

  zips <- zip_list[[as.character(year)]]
  zips  <- as.data.table(zips)
  zips <- zips[!(STATE %in% c("AK", "HI", "PR", "GU", "VI"))]
  zips[, ZIP := as.character(ZIP)]

  zips <- merge(zips,  exposure, by = "ZIP", all.x = T)


## Make maps
map <- ggplot(zips) +
  theme_minimal() +
  theme(plot.title = element_text(size = 20),
    axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        line = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal", 
        legend.text = element_text(angle = 60,  size = 20),
        legend.text.align = 0.75,
        legend.title = element_text(size = 24),
        legend.key.width = unit(150, "points"),
        panel.grid.major = element_line(colour = "transparent"))

## Joel Schwartz PM Map
joel_pm <- map
joel_pm <- joel_pm +
  geom_sf(aes(fill = joel_pm25), lwd = 0) +
  scale_fill_viridis("PM2.5",  na.value = "white", limits = c(0,25)) #+
  #labs(title = paste0("Annual Average Micrograms of PM2.5 (Joel Schwartz) per Cubic Meter of Air in ",year," By Zip Code"))

png(paste0("../figures/joel_pm_", year,".png"), height = 512, width = 1024)
print(joel_pm)
dev.off()

## Randall Martin PM Map
rm_pm <- map
rm_pm <- rm_pm +
  geom_sf(aes(fill = rm_pm25), lwd = 0) +
  scale_fill_viridis("PM2.5",  na.value = "white", limits = c(0,25)) #+
  #labs(title = paste0("Annual Average Micrograms of PM2.5 (Randall Martin) per Cubic Meter of Air in ",year," By Zip Code"))

  png(paste0("../figures/rm_pm_",year,".png"), height = 512, width = 1024)
  print(rm_pm)
  dev.off()


## ozone map
  joel_ozone <- map
  joel_ozone <- joel_ozone +
  geom_sf(aes(fill = ozone), lwd = 0) +
  scale_fill_viridis("Ozone",  na.value = "white") #+
  #labs(title = paste0("Annual Average PPB of Ozone (Joel Schwartz) in Air in ",year," By Zip Code"))

  png(paste0("../figures/joel_ozone_",year,".png"), height = 512, width = 1024)
  print(joel_ozone)
  dev.off()

## no2 map
  joel_no2 <- map
  joel_no2 <- joel_no2 +
  geom_sf(aes(fill = no2), lwd = 0) +
  scale_fill_viridis("NO2",  na.value = "white") #+
  #labs(title = paste0("Annual Average PPB of NO2 (Joel Schwartz) in ",year," By Zip Code"))

  png(paste0("../figures/joel_no2_", year, ".png"), height = 512, width = 1024)
  print(joel_no2)
  dev.off()
}


