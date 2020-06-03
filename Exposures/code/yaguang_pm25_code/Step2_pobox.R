#####################################################################################
# Project: Aggregate QD's PM2.5 by grid cell to zip code                            #
# Step 2: linking cloest grid cell for PO Box                                       #
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
library(nabor)

dir_grid <- '/media/qnap2/assembled_data/prediction/PM25_USGrid/'
dir_pobox <- '/media/gate/yaguang/Aggregate_PM25/pobox_csv/'
dir_pobox_save <- '/media/gate/yaguang/Aggregate_PM25/US_POBOX_PM25/daily/'

cl = makeCluster(5,outfile='')
registerDoParallel(cl)

# load coordinates
grid_cord <- readRDS(paste0(dir_grid,"USGridSite.rds"))


########### 1. Calculate PM2.5 for PO Boxes by linking single nearest grid cell ###########
# 2000
pobox_00 <- read.csv(paste0(dir_pobox,'ESRI00USZIP5_POINT_WGS84_POBOX.csv'))
pobox_00 <- pobox_00[,c(1,3,4)]
names(pobox_00) <- c('ZIP','long','lat')

pm_daily_files_00 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2000(.*)rds$")

foreach(i = 1:length(pm_daily_files_00), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_00[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_00_i <- pobox_00
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_00_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_00_i$pobox_id <- as.numeric(row.names(pobox_00_i))
  pobox_00_i <- cbind.data.frame(pobox_00_i,link)
  names(pobox_00_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_00_i <- left_join(pobox_00_i,pm25_daily_grid,by=c("pm_id"))
  pobox_00_i <- pobox_00_i[pobox_00_i$dis!=Inf,]
  pobox_00_i <- pobox_00_i[,c('ZIP','pm25')]
  saveRDS(pobox_00_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_00_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')))
  return(0)
}
stopCluster(cl)


# 2001
pobox_01 <- read.csv(paste0(dir_pobox,'ESRI01USZIP5_POINT_WGS84_POBOX.csv'))
pobox_01 <- pobox_01[,c(1,3,4)]
names(pobox_01) <- c('ZIP','long','lat')

pm_daily_files_01 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2001(.*)rds$")

foreach(i = 1:length(pm_daily_files_01), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_01[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_01_i <- pobox_01
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_01_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_01_i$pobox_id <- as.numeric(row.names(pobox_01_i))
  pobox_01_i <- cbind.data.frame(pobox_01_i,link)
  names(pobox_01_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_01_i <- left_join(pobox_01_i,pm25_daily_grid,by=c("pm_id"))
  pobox_01_i <- pobox_01_i[pobox_01_i$dis!=Inf,]
  pobox_01_i <- pobox_01_i[,c('ZIP','pm25')]
  saveRDS(pobox_01_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_01_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')))
  return(0)
}
stopCluster(cl)


# 2002
pobox_02 <- read.csv(paste0(dir_pobox,'ESRI02USZIP5_POINT_WGS84_POBOX.csv'))
pobox_02 <- pobox_02[,c(1,3,4)]
names(pobox_02) <- c('ZIP','long','lat')

pm_daily_files_02 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2002(.*)rds$")

foreach(i = 1:length(pm_daily_files_02), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_02[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_02_i <- pobox_02
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_02_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_02_i$pobox_id <- as.numeric(row.names(pobox_02_i))
  pobox_02_i <- cbind.data.frame(pobox_02_i,link)
  names(pobox_02_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_02_i <- left_join(pobox_02_i,pm25_daily_grid,by=c("pm_id"))
  pobox_02_i <- pobox_02_i[pobox_02_i$dis!=Inf,]
  pobox_02_i <- pobox_02_i[,c('ZIP','pm25')]
  saveRDS(pobox_02_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_02_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')))
  return(0)
}
stopCluster(cl)


# 2003
pobox_03 <- read.csv(paste0(dir_pobox,'ESRI03USZIP5_POINT_WGS84_POBOX.csv'))
pobox_03 <- pobox_03[,c(1,3,4)]
names(pobox_03) <- c('ZIP','long','lat')

pm_daily_files_03 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2003(.*)rds$")

foreach(i = 1:length(pm_daily_files_03), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_03[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_03_i <- pobox_03
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_03_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_03_i$pobox_id <- as.numeric(row.names(pobox_03_i))
  pobox_03_i <- cbind.data.frame(pobox_03_i,link)
  names(pobox_03_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_03_i <- left_join(pobox_03_i,pm25_daily_grid,by=c("pm_id"))
  pobox_03_i <- pobox_03_i[pobox_03_i$dis!=Inf,]
  pobox_03_i <- pobox_03_i[,c('ZIP','pm25')]
  saveRDS(pobox_03_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_03_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')))
  return(0)
}
stopCluster(cl)


# 2004
pobox_04 <- read.csv(paste0(dir_pobox,'ESRI04USZIP5_POINT_WGS84_POBOX.csv'))
pobox_04 <- pobox_04[,c(1,3,4)]
names(pobox_04) <- c('ZIP','long','lat')

pm_daily_files_04 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2004(.*)rds$")

foreach(i = 1:length(pm_daily_files_04), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_04[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_04_i <- pobox_04
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_04_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_04_i$pobox_id <- as.numeric(row.names(pobox_04_i))
  pobox_04_i <- cbind.data.frame(pobox_04_i,link)
  names(pobox_04_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_04_i <- left_join(pobox_04_i,pm25_daily_grid,by=c("pm_id"))
  pobox_04_i <- pobox_04_i[pobox_04_i$dis!=Inf,]
  pobox_04_i <- pobox_04_i[,c('ZIP','pm25')]
  saveRDS(pobox_04_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_04_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')))
  return(0)
}
stopCluster(cl)


# 2005
pobox_05 <- read.csv(paste0(dir_pobox,'ESRI05USZIP5_POINT_WGS84_POBOX.csv'))
pobox_05 <- pobox_05[,c(1,3,4)]
names(pobox_05) <- c('ZIP','long','lat')

pm_daily_files_05 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2005(.*)rds$")

foreach(i = 1:length(pm_daily_files_05), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_05[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_05_i <- pobox_05
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_05_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_05_i$pobox_id <- as.numeric(row.names(pobox_05_i))
  pobox_05_i <- cbind.data.frame(pobox_05_i,link)
  names(pobox_05_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_05_i <- left_join(pobox_05_i,pm25_daily_grid,by=c("pm_id"))
  pobox_05_i <- pobox_05_i[pobox_05_i$dis!=Inf,]
  pobox_05_i <- pobox_05_i[,c('ZIP','pm25')]
  saveRDS(pobox_05_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_05_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')))
  return(0)
}
stopCluster(cl)


# 2006
pobox_06 <- read.csv(paste0(dir_pobox,'ESRI06USZIP5_POINT_WGS84_POBOX.csv'))
pobox_06 <- pobox_06[,c(1,3,4)]
names(pobox_06) <- c('ZIP','long','lat')

pm_daily_files_06 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2006(.*)rds$")

foreach(i = 1:length(pm_daily_files_06), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_06[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_06_i <- pobox_06
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_06_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_06_i$pobox_id <- as.numeric(row.names(pobox_06_i))
  pobox_06_i <- cbind.data.frame(pobox_06_i,link)
  names(pobox_06_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_06_i <- left_join(pobox_06_i,pm25_daily_grid,by=c("pm_id"))
  pobox_06_i <- pobox_06_i[pobox_06_i$dis!=Inf,]
  pobox_06_i <- pobox_06_i[,c('ZIP','pm25')]
  saveRDS(pobox_06_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_06_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')))
  return(0)
}
stopCluster(cl)


# 2007
pobox_07 <- read.csv(paste0(dir_pobox,'ESRI07USZIP5_POINT_WGS84_POBOX.csv'))
pobox_07 <- pobox_07[,c(1,3,4)]
names(pobox_07) <- c('ZIP','long','lat')

pm_daily_files_07 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2007(.*)rds$")

foreach(i = 1:length(pm_daily_files_07), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_07[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_07_i <- pobox_07
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_07_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_07_i$pobox_id <- as.numeric(row.names(pobox_07_i))
  pobox_07_i <- cbind.data.frame(pobox_07_i,link)
  names(pobox_07_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_07_i <- left_join(pobox_07_i,pm25_daily_grid,by=c("pm_id"))
  pobox_07_i <- pobox_07_i[pobox_07_i$dis!=Inf,]
  pobox_07_i <- pobox_07_i[,c('ZIP','pm25')]
  saveRDS(pobox_07_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_07_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')))
  return(0)
}
stopCluster(cl)


# 2008
pobox_08 <- read.csv(paste0(dir_pobox,'ESRI08USZIP5_POINT_WGS84_POBOX.csv'))
pobox_08 <- pobox_08[,c(1,3,4)]
names(pobox_08) <- c('ZIP','long','lat')

pm_daily_files_08 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2008(.*)rds$")

foreach(i = 1:length(pm_daily_files_08), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_08[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_08_i <- pobox_08
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_08_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_08_i$pobox_id <- as.numeric(row.names(pobox_08_i))
  pobox_08_i <- cbind.data.frame(pobox_08_i,link)
  names(pobox_08_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_08_i <- left_join(pobox_08_i,pm25_daily_grid,by=c("pm_id"))
  pobox_08_i <- pobox_08_i[pobox_08_i$dis!=Inf,]
  pobox_08_i <- pobox_08_i[,c('ZIP','pm25')]
  saveRDS(pobox_08_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_08_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')))
  return(0)
}
stopCluster(cl)


# 2009
pobox_09 <- read.csv(paste0(dir_pobox,'ESRI09USZIP5_POINT_WGS84_POBOX.csv'))
pobox_09 <- pobox_09[,c(1,3,4)]
names(pobox_09) <- c('ZIP','long','lat')

pm_daily_files_09 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2009(.*)rds$")

foreach(i = 1:length(pm_daily_files_09), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_09[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_09_i <- pobox_09
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_09_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_09_i$pobox_id <- as.numeric(row.names(pobox_09_i))
  pobox_09_i <- cbind.data.frame(pobox_09_i,link)
  names(pobox_09_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_09_i <- left_join(pobox_09_i,pm25_daily_grid,by=c("pm_id"))
  pobox_09_i <- pobox_09_i[pobox_09_i$dis!=Inf,]
  pobox_09_i <- pobox_09_i[,c('ZIP','pm25')]
  saveRDS(pobox_09_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_09_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')))
  return(0)
}
stopCluster(cl)


# 2010
pobox_10 <- read.csv(paste0(dir_pobox,'ESRI10USZIP5_POINT_WGS84_POBOX.csv'))
pobox_10 <- pobox_10[,c(1,3,4)]
names(pobox_10) <- c('ZIP','long','lat')

pm_daily_files_10 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2010(.*)rds$")

foreach(i = 1:length(pm_daily_files_10), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_10[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_10_i <- pobox_10
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_10_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_10_i$pobox_id <- as.numeric(row.names(pobox_10_i))
  pobox_10_i <- cbind.data.frame(pobox_10_i,link)
  names(pobox_10_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_10_i <- left_join(pobox_10_i,pm25_daily_grid,by=c("pm_id"))
  pobox_10_i <- pobox_10_i[pobox_10_i$dis!=Inf,]
  pobox_10_i <- pobox_10_i[,c('ZIP','pm25')]
  saveRDS(pobox_10_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_10_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')))
  return(0)
}
stopCluster(cl)


# 2011
pobox_11 <- read.csv(paste0(dir_pobox,'ESRI11USZIP5_POINT_WGS84_POBOX.csv'))
pobox_11 <- pobox_11[,c(1,3,4)]
names(pobox_11) <- c('ZIP','long','lat')

pm_daily_files_11 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2011(.*)rds$")

foreach(i = 1:length(pm_daily_files_11), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_11[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_11_i <- pobox_11
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_11_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_11_i$pobox_id <- as.numeric(row.names(pobox_11_i))
  pobox_11_i <- cbind.data.frame(pobox_11_i,link)
  names(pobox_11_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_11_i <- left_join(pobox_11_i,pm25_daily_grid,by=c("pm_id"))
  pobox_11_i <- pobox_11_i[pobox_11_i$dis!=Inf,]
  pobox_11_i <- pobox_11_i[,c('ZIP','pm25')]
  saveRDS(pobox_11_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_11_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')))
  return(0)
}
stopCluster(cl)


# 2012
pobox_12 <- read.csv(paste0(dir_pobox,'ESRI12USZIP5_POINT_WGS84_POBOX.csv'))
pobox_12 <- pobox_12[,c(1,3,4)]
names(pobox_12) <- c('ZIP','long','lat')

pm_daily_files_12 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2012(.*)rds$")

foreach(i = 1:length(pm_daily_files_12), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_12[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_12_i <- pobox_12
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_12_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_12_i$pobox_id <- as.numeric(row.names(pobox_12_i))
  pobox_12_i <- cbind.data.frame(pobox_12_i,link)
  names(pobox_12_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_12_i <- left_join(pobox_12_i,pm25_daily_grid,by=c("pm_id"))
  pobox_12_i <- pobox_12_i[pobox_12_i$dis!=Inf,]
  pobox_12_i <- pobox_12_i[,c('ZIP','pm25')]
  saveRDS(pobox_12_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_12_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')))
  return(0)
}
stopCluster(cl)


# 2013
pobox_13 <- read.csv(paste0(dir_pobox,'ESRI13USZIP5_POINT_WGS84_POBOX.csv'))
pobox_13 <- pobox_13[,c(1,3,4)]
names(pobox_13) <- c('ZIP','long','lat')

pm_daily_files_13 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2013(.*)rds$")

foreach(i = 1:length(pm_daily_files_13), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_13[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_13_i <- pobox_13
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_13_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_13_i$pobox_id <- as.numeric(row.names(pobox_13_i))
  pobox_13_i <- cbind.data.frame(pobox_13_i,link)
  names(pobox_13_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_13_i <- left_join(pobox_13_i,pm25_daily_grid,by=c("pm_id"))
  pobox_13_i <- pobox_13_i[pobox_13_i$dis!=Inf,]
  pobox_13_i <- pobox_13_i[,c('ZIP','pm25')]
  saveRDS(pobox_13_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_13_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')))
  return(0)
}
stopCluster(cl)


# 2014
pobox_14 <- read.csv(paste0(dir_pobox,'ESRI14USZIP5_POINT_WGS84_POBOX.csv'))
pobox_14 <- pobox_14[,c(1,3,4)]
names(pobox_14) <- c('ZIP','long','lat')

pm_daily_files_14 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2014(.*)rds$")

foreach(i = 1:length(pm_daily_files_14), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_14[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_14_i <- pobox_14
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_14_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_14_i$pobox_id <- as.numeric(row.names(pobox_14_i))
  pobox_14_i <- cbind.data.frame(pobox_14_i,link)
  names(pobox_14_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_14_i <- left_join(pobox_14_i,pm25_daily_grid,by=c("pm_id"))
  pobox_14_i <- pobox_14_i[pobox_14_i$dis!=Inf,]
  pobox_14_i <- pobox_14_i[,c('ZIP','pm25')]
  saveRDS(pobox_14_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_14_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')))
  return(0)
}
stopCluster(cl)


# 2015
pobox_15 <- read.csv(paste0(dir_pobox,'ESRI15USZIP5_POINT_WGS84_POBOX.csv'))
pobox_15 <- pobox_15[,c(1,3,4)]
names(pobox_15) <- c('ZIP','long','lat')

pm_daily_files_15 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2015(.*)rds$")

foreach(i = 1:length(pm_daily_files_15), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_15[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_15_i <- pobox_15
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_15_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_15_i$pobox_id <- as.numeric(row.names(pobox_15_i))
  pobox_15_i <- cbind.data.frame(pobox_15_i,link)
  names(pobox_15_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_15_i <- left_join(pobox_15_i,pm25_daily_grid,by=c("pm_id"))
  pobox_15_i <- pobox_15_i[pobox_15_i$dis!=Inf,]
  pobox_15_i <- pobox_15_i[,c('ZIP','pm25')]
  saveRDS(pobox_15_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_15_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')))
  return(0)
}
stopCluster(cl)


# 2016
pobox_16 <- read.csv(paste0(dir_pobox,'ESRI16USZIP5_POINT_WGS84_POBOX.csv'))
pobox_16 <- pobox_16[,c(1,3,4)]
names(pobox_16) <- c('ZIP','long','lat')

pm_daily_files_16 <- list.files(path=dir_grid,pattern = "^PredictionStep2_PM25_USGrid_2016(.*)rds$")

foreach(i = 1:length(pm_daily_files_16), .packages=c('nabor','dplyr')) %dopar%
{
  pm25_daily_grid_raw <- readRDS(paste0(dir_grid,pm_daily_files_16[i]))
  pm25_daily_grid <- data.frame(t(pm25_daily_grid_raw))
  pm25_daily_grid <- cbind(pm25_daily_grid,grid_cord)
  pm25_daily_grid <- pm25_daily_grid[,c(1:3)]
  names(pm25_daily_grid) <- c('pm25','long','lat')
  
  pobox_16_i <- pobox_16
  link <- nabor::knn(pm25_daily_grid[,c("long","lat")],pobox_16_i[,c("long","lat")],k=1,radius=2*sqrt(2)/10*0.1)
  link <- cbind.data.frame(link$nn.idx,link$nn.dists)
  names(link) <- c("id","dis")
  pobox_16_i$pobox_id <- as.numeric(row.names(pobox_16_i))
  pobox_16_i <- cbind.data.frame(pobox_16_i,link)
  names(pobox_16_i) <- c("ZIP","long","lat","pobox_id","pm_id","dis")
  pm25_daily_grid$pm_id <- as.numeric(row.names(pm25_daily_grid))
  pobox_16_i <- left_join(pobox_16_i,pm25_daily_grid,by=c("pm_id"))
  pobox_16_i <- pobox_16_i[pobox_16_i$dis!=Inf,]
  pobox_16_i <- pobox_16_i[,c('ZIP','pm25')]
  saveRDS(pobox_16_i,file = paste0(dir_pobox_save,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')),'.rds'))
  
  rm(pm25_daily_grid_raw,pm25_daily_grid,pobox_16_i)
  gc()
  cat(i,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')))
  return(0)
}
stopCluster(cl)

