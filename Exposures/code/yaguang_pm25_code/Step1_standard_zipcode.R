#####################################################################################
# Project: Aggregate QD's PM2.5 by grid cell to zip code                            #
# Step 1: zipcodes-averaged for regular zipcodes                                    #
# Author: Yaguang Wei                                                               #
#####################################################################################

############## 0. Setup load packages ###############
rm(list=ls())
gc()

# install.packages("gdalUtils")
# install.packages("devtools")
# install_github("allanjust/aodlur", dependencies = TRUE)
# install.packages("aodlur")
# install.packages("rgeos")
# install.packages("mapview")
# install.packages("dplyr")
# install.packages("gstat")
# install.packages("spatialEco")
# install.packages("doParallel")
# install.packages('rlang')
# install.packages('sf')
# install.packages("units", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
# install.packages("classInt")
# devtools::install_github("r-spatial/sf")
# install.packages('DESeq2')

library(gdalUtils)
library(devtools)
# library(aodlur)
library(magrittr)
library(rgdal)
library(sp)
library(rgeos)
library(raster)
# library(mapview)
library(plyr)
library(dplyr)
library(reshape2)
library(scales)
# library(units)
library(sf)
library(gstat)
library(spatialEco)
library(doParallel)
library(sp)

dir_grid <- '/media/qnap2/assembled_data/prediction/PM25_USGrid/'
dir_shp <- '/media/gate/yaguang/Aggregate_PM25/polygon/'
dir_save <- '/media/gate/yaguang/Aggregate_PM25/US_ZIP_PM25_ZipAverage/daily/'

cl = makeCluster(10,outfile='')
registerDoParallel(cl)

# load coordinates
grid_cord <- readRDS(paste0(dir_grid,"USGridSite.rds"))


############## 1. Calculate zipcode-averaged PM2.5 ###############
# 2000
cty_00 <- shapefile(paste0(dir_shp,"/ESRI00USZIP5_POLY_WGS84.shp"))
pm_daily_files_00 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2000(.*)rds$")

foreach(i = 1:length(pm_daily_files_00), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_00[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_00)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_00)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')))
  return(0)
}

stopCluster(cl)

# 2001
cty_01 <- shapefile(paste0(dir_shp,"/ESRI01USZIP5_POLY_WGS84.shp"))
pm_daily_files_01 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2001(.*)rds$")

foreach(i = 1:length(pm_daily_files_01), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_01[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_01)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_01)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')))
  return(0)
}

stopCluster(cl)

# 2002
cty_02 <- shapefile(paste0(dir_shp,"/ESRI02USZIP5_POLY_WGS84.shp"))
pm_daily_files_02 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2002(.*)rds$")

foreach(i = 1:length(pm_daily_files_02), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_02[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_02)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_02)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')))
  return(0)
}

stopCluster(cl)

# 2003
cty_03 <- shapefile(paste0(dir_shp,"/ESRI03USZIP5_POLY_WGS84.shp"))
pm_daily_files_03 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2003(.*)rds$")

foreach(i = 1:length(pm_daily_files_03), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_03[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_03)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_03)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')))
  return(0)
}

stopCluster(cl)

# 2004
cty_04 <- shapefile(paste0(dir_shp,"/ESRI04USZIP5_POLY_WGS84.shp"))
pm_daily_files_04 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2004(.*)rds$")

foreach(i = 1:length(pm_daily_files_04), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_04[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_04)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_04)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')))
  return(0)
}

stopCluster(cl)

# 2005
cty_05 <- shapefile(paste0(dir_shp,"/ESRI05USZIP5_POLY_WGS84.shp"))
pm_daily_files_05 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2005(.*)rds$")

foreach(i = 1:length(pm_daily_files_05), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_05[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_05)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_05)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')))
  return(0)
}

stopCluster(cl)

# 2006
cty_06 <- shapefile(paste0(dir_shp,"/ESRI06USZIP5_POLY_WGS84.shp"))
pm_daily_files_06 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2006(.*)rds$")

foreach(i = 1:length(pm_daily_files_06), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_06[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_06)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_06)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')))
  return(0)
}

stopCluster(cl)

# 2007
cty_07 <- shapefile(paste0(dir_shp,"/ESRI07USZIP5_POLY_WGS84.shp"))
pm_daily_files_07 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2007(.*)rds$")

foreach(i = 1:length(pm_daily_files_07), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_07[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_07)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_07)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')))
  return(0)
}

stopCluster(cl)

# 2008
cty_08 <- shapefile(paste0(dir_shp,"/ESRI08USZIP5_POLY_WGS84.shp"))
pm_daily_files_08 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2008(.*)rds$")

foreach(i = 1:length(pm_daily_files_08), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_08[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_08)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_08)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')))
  return(0)
}

stopCluster(cl)

# 2009
cty_09 <- shapefile(paste0(dir_shp,"/ESRI09USZIP5_POLY_WGS84.shp"))
pm_daily_files_09 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2009(.*)rds$")

foreach(i = 1:length(pm_daily_files_09), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_09[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_09)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_09)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')))
  return(0)
}

stopCluster(cl)

# 2010
cty_10 <- shapefile(paste0(dir_shp,"/ESRI10USZIP5_POLY_WGS84.shp"))
pm_daily_files_10 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2010(.*)rds$")

foreach(i = 1:length(pm_daily_files_10), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_10[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_10)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_10)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')))
  return(0)
}

stopCluster(cl)

# 2011
cty_11 <- shapefile(paste0(dir_shp,"/ESRI11USZIP5_POLY_WGS84.shp"))
pm_daily_files_11 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2011(.*)rds$")

foreach(i = 1:length(pm_daily_files_11), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_11[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_11)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_11)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')))
  return(0)
}

stopCluster(cl)

# 2012
cty_12 <- shapefile(paste0(dir_shp,"/ESRI12USZIP5_POLY_WGS84.shp"))
pm_daily_files_12 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2012(.*)rds$")

foreach(i = 1:length(pm_daily_files_12), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_12[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_12)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_12)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')))
  return(0)
}

stopCluster(cl)

# 2013
cty_13 <- shapefile(paste0(dir_shp,"/ESRI13USZIP5_POLY_WGS84.shp"))
pm_daily_files_13 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2013(.*)rds$")

foreach(i = 1:length(pm_daily_files_13), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_13[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_13)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_13)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')))
  return(0)
}

stopCluster(cl)

# 2014
cty_14 <- shapefile(paste0(dir_shp,"/ESRI14USZIP5_POLY_WGS84.shp"))
pm_daily_files_14 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2014(.*)rds$")

foreach(i = 1:length(pm_daily_files_14), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_14[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_14)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_14)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')))
  return(0)
}

stopCluster(cl)

# 2015
cty_15 <- shapefile(paste0(dir_shp,"/ESRI15USZIP5_POLY_WGS84.shp"))
pm_daily_files_15 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2015(.*)rds$")

foreach(i = 1:length(pm_daily_files_15), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_15[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_15)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_15)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')))
  return(0)
}

stopCluster(cl)

# 2016
cty_16 <- shapefile(paste0(dir_shp,"/ESRI16USZIP5_POLY_WGS84.shp"))
pm_daily_files_16 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2016(.*)rds$")

foreach(i = 1:length(pm_daily_files_16), .packages=c('sp','dplyr','spatialEco')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_16[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  sp::coordinates(pm25_daily_grid)<-~long+lat
  proj4string(pm25_daily_grid)<-proj4string(cty_16)
  pm25_daily_grid <- point.in.poly(pm25_daily_grid, cty_16)
  pm25_daily_grid <- as.data.frame(pm25_daily_grid)[,c('pm25','ZIP')]
  pm25_daily_zip <- pm25_daily_grid %>% group_by(ZIP) %>% summarise(avgpm=mean(pm25,na.rm=T))
  saveRDS(pm25_daily_zip,file = paste0(dir_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')),'.rds'))
  rm(pm25_daily_grid_raw,pm25_daily_grid,pm25_daily_zip)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')))
  return(0)
}

stopCluster(cl)