#####################################################################################
# Project: Aggregate QD's PM2.5 by grid cell to zip code                            #
# Step 3: Merge daily PM2.5 at standard zipcode and PO box PM2.5,                   #
#         and summarise to annual PM2.5                                             #
# Author: Yaguang Wei                                                               #
#####################################################################################

############## 0. Setup load packages ###############
rm(list=ls())
gc()

library(lubridate)
library(dplyr)
library(stringr)

dir_zipcode <- '/media/gate/yaguang/Aggregate_PM25/US_ZIP_PM25_ZipAverage/daily/'
dir_pobox <- '/media/gate/yaguang/Aggregate_PM25/US_POBOX_PM25/daily/'
dir_save_daily <- '/media/gate/yaguang/Aggregate_PM25/US_PM25_ZipcodeAverage_2000_2016/daily/'
dir_save_annual <- '/media/gate/yaguang/Aggregate_PM25/US_PM25_ZipcodeAverage_2000_2016/annual/'

cl = makeCluster(10,outfile='')
registerDoParallel(cl)

#############################################################################################
################# 1. Merge daily PM2.5 at standard zipcode and PO box PM2.5 #################
#############################################################################################
# 2000
pm_daily_zipcode_00 <- list.files(path=dir_zipcode,pattern = "^2000(.*)rds$")
pm_daily_pobox_00 <- list.files(path=dir_pobox,pattern = "^2000(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_00[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_00[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_00), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_00[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_00[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2000-01-01')))
  return(0)
}

stopCluster(cl)

# 2001
pm_daily_zipcode_01 <- list.files(path=dir_zipcode,pattern = "^2001(.*)rds$")
pm_daily_pobox_01 <- list.files(path=dir_pobox,pattern = "^2001(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_01[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_01[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_01), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_01[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_01[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2001-01-01')))
  return(0)
}

stopCluster(cl)


# 2002
pm_daily_zipcode_02 <- list.files(path=dir_zipcode,pattern = "^2002(.*)rds$")
pm_daily_pobox_02 <- list.files(path=dir_pobox,pattern = "^2002(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_02[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_02[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_02), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_02[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_02[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2002-01-01')))
  return(0)
}

stopCluster(cl)


# 2003
pm_daily_zipcode_03 <- list.files(path=dir_zipcode,pattern = "^2003(.*)rds$")
pm_daily_pobox_03 <- list.files(path=dir_pobox,pattern = "^2003(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_03[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_03[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_03), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_03[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_03[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2003-01-01')))
  return(0)
}

stopCluster(cl)


# 2004
pm_daily_zipcode_04 <- list.files(path=dir_zipcode,pattern = "^2004(.*)rds$")
pm_daily_pobox_04 <- list.files(path=dir_pobox,pattern = "^2004(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_04[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_04[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_04), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_04[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_04[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2004-01-01')))
  return(0)
}

stopCluster(cl)


# 2005
pm_daily_zipcode_05 <- list.files(path=dir_zipcode,pattern = "^2005(.*)rds$")
pm_daily_pobox_05 <- list.files(path=dir_pobox,pattern = "^2005(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_05[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_05[1]))$ZIP)
# 42223 57724 63673 71749 72395 73949
# 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area'

foreach(i = 1:length(pm_daily_zipcode_05), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_05[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_05[i]))
  pm_daily_pobox <- pm_daily_pobox %>% filter(!ZIP%in%c('42223','57724','63673','71749','72395','73949'))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2005-01-01')))
  return(0)
}

stopCluster(cl)


# 2006
pm_daily_zipcode_06 <- list.files(path=dir_zipcode,pattern = "^2006(.*)rds$")
pm_daily_pobox_06 <- list.files(path=dir_pobox,pattern = "^2006(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_06[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_06[1]))$ZIP)
# [1] 42223 57724 63673 71749 72395 73949
# 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area' 'Zip Code Area'

foreach(i = 1:length(pm_daily_zipcode_06), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_06[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_06[i]))
  pm_daily_pobox <- pm_daily_pobox %>% filter(!ZIP%in%c('42223','57724','63673','71749','72395','73949'))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2006-01-01')))
  return(0)
}

stopCluster(cl)


# 2007
pm_daily_zipcode_07 <- list.files(path=dir_zipcode,pattern = "^2007(.*)rds$")
pm_daily_pobox_07 <- list.files(path=dir_pobox,pattern = "^2007(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_07[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_07[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_07), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_07[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_07[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2007-01-01')))
  return(0)
}

stopCluster(cl)


# 2008
pm_daily_zipcode_08 <- list.files(path=dir_zipcode,pattern = "^2008(.*)rds$")
pm_daily_pobox_08 <- list.files(path=dir_pobox,pattern = "^2008(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_08[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_08[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_08), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_08[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_08[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2008-01-01')))
  return(0)
}

stopCluster(cl)


# 2009
pm_daily_zipcode_09 <- list.files(path=dir_zipcode,pattern = "^2009(.*)rds$")
pm_daily_pobox_09 <- list.files(path=dir_pobox,pattern = "^2009(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_09[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_09[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_09), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_09[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_09[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2009-01-01')))
  return(0)
}

stopCluster(cl)


# 2010
pm_daily_zipcode_10 <- list.files(path=dir_zipcode,pattern = "^2010(.*)rds$")
pm_daily_pobox_10 <- list.files(path=dir_pobox,pattern = "^2010(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_10[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_10[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_10), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_10[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_10[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2010-01-01')))
  return(0)
}

stopCluster(cl)


# 2011
pm_daily_zipcode_11 <- list.files(path=dir_zipcode,pattern = "^2011(.*)rds$")
pm_daily_pobox_11 <- list.files(path=dir_pobox,pattern = "^2011(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_11[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_11[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_11), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_11[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_11[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2011-01-01')))
  return(0)
}

stopCluster(cl)


# 2012
pm_daily_zipcode_12 <- list.files(path=dir_zipcode,pattern = "^2012(.*)rds$")
pm_daily_pobox_12 <- list.files(path=dir_pobox,pattern = "^2012(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_12[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_12[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_12), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_12[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_12[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2012-01-01')))
  return(0)
}

stopCluster(cl)


# 2013
pm_daily_zipcode_13 <- list.files(path=dir_zipcode,pattern = "^2013(.*)rds$")
pm_daily_pobox_13 <- list.files(path=dir_pobox,pattern = "^2013(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_13[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_13[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_13), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_13[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_13[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2013-01-01')))
  return(0)
}

stopCluster(cl)


# 2014
pm_daily_zipcode_14 <- list.files(path=dir_zipcode,pattern = "^2014(.*)rds$")
pm_daily_pobox_14 <- list.files(path=dir_pobox,pattern = "^2014(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_14[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_14[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_14), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_14[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_14[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2014-01-01')))
  return(0)
}

stopCluster(cl)


# 2015
pm_daily_zipcode_15 <- list.files(path=dir_zipcode,pattern = "^2015(.*)rds$")
pm_daily_pobox_15 <- list.files(path=dir_pobox,pattern = "^2015(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_15[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_15[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_15), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_15[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_15[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2015-01-01')))
  return(0)
}

stopCluster(cl)


# 2016
pm_daily_zipcode_16 <- list.files(path=dir_zipcode,pattern = "^2016(.*)rds$")
pm_daily_pobox_16 <- list.files(path=dir_pobox,pattern = "^2016(.*)rds$")

intersect(readRDS(paste0(dir_zipcode,pm_daily_zipcode_16[1]))$ZIP,readRDS(paste0(dir_pobox,pm_daily_pobox_16[1]))$ZIP)

foreach(i = 1:length(pm_daily_zipcode_16), .packages=c('dplyr','stringr')) %dopar%
{
  pm_daily_zipcode <- readRDS(paste0(dir_zipcode,pm_daily_zipcode_16[i]))
  names(pm_daily_zipcode) <- c('ZIP','pm25')
  pm_daily_zipcode <- pm_daily_zipcode[!is.na(pm_daily_zipcode$ZIP),]
  
  pm_daily_pobox <- readRDS(paste0(dir_pobox,pm_daily_pobox_16[i]))
  pm_daily_pobox <- pm_daily_pobox[!is.na(pm_daily_pobox$ZIP),]
  pm_daily_pobox$ZIP <- as.character(pm_daily_pobox$ZIP)
  pm_daily_pobox$ZIP <- str_pad(pm_daily_pobox$ZIP, width=5, side="left", pad="0")
  
  pm_daily_combine <- rbind(pm_daily_zipcode,pm_daily_pobox)
  pm_daily_combine <- pm_daily_combine[order(pm_daily_combine$ZIP),]
  saveRDS(pm_daily_combine,file = paste0(dir_save_daily,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')),'.rds'))
  rm(pm_daily_zipcode,pm_daily_pobox,pm_daily_combine)
  gc()
  cat('',i,gsub('[[:punct:]]','',as.Date(i-1,origin='2016-01-01')))
  return(0)
}

stopCluster(cl)



#############################################################################################
################################## 2. Summarise to annual PM2.5 #############################
#############################################################################################
# 2000
pm_daily_merged_files_00 <- list.files(path=dir_save_daily,pattern = "^2000(.*)rds$")

pm_daily_merged_00 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_00) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_00)){
  pm_daily_merged_files_00_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_00[i]))
  pm_daily_merged_00 <- rbind(pm_daily_merged_00, pm_daily_merged_files_00_temp)
  rm(pm_daily_merged_files_00_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_00 <- pm_daily_merged_00 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_00) <- c('ZIP','pm25')
saveRDS(pm_annual_00,file = paste0(dir_save_annual,'2000.rds'))


# 2001
pm_daily_merged_files_01 <- list.files(path=dir_save_daily,pattern = "^2001(.*)rds$")

pm_daily_merged_01 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_01) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_01)){
  pm_daily_merged_files_01_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_01[i]))
  pm_daily_merged_01 <- rbind(pm_daily_merged_01, pm_daily_merged_files_01_temp)
  rm(pm_daily_merged_files_01_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_01 <- pm_daily_merged_01 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_01) <- c('ZIP','pm25')
saveRDS(pm_annual_01,file = paste0(dir_save_annual,'2001.rds'))


# 2002
pm_daily_merged_files_02 <- list.files(path=dir_save_daily,pattern = "^2002(.*)rds$")

pm_daily_merged_02 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_02) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_02)){
  pm_daily_merged_files_02_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_02[i]))
  pm_daily_merged_02 <- rbind(pm_daily_merged_02, pm_daily_merged_files_02_temp)
  rm(pm_daily_merged_files_02_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_02 <- pm_daily_merged_02 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_02) <- c('ZIP','pm25')
saveRDS(pm_annual_02,file = paste0(dir_save_annual,'2002.rds'))


# 2003
pm_daily_merged_files_03 <- list.files(path=dir_save_daily,pattern = "^2003(.*)rds$")

pm_daily_merged_03 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_03) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_03)){
  pm_daily_merged_files_03_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_03[i]))
  pm_daily_merged_03 <- rbind(pm_daily_merged_03, pm_daily_merged_files_03_temp)
  rm(pm_daily_merged_files_03_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_03 <- pm_daily_merged_03 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_03) <- c('ZIP','pm25')
saveRDS(pm_annual_03,file = paste0(dir_save_annual,'2003.rds'))


# 2004
pm_daily_merged_files_04 <- list.files(path=dir_save_daily,pattern = "^2004(.*)rds$")

pm_daily_merged_04 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_04) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_04)){
  pm_daily_merged_files_04_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_04[i]))
  pm_daily_merged_04 <- rbind(pm_daily_merged_04, pm_daily_merged_files_04_temp)
  rm(pm_daily_merged_files_04_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_04 <- pm_daily_merged_04 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_04) <- c('ZIP','pm25')
saveRDS(pm_annual_04,file = paste0(dir_save_annual,'2004.rds'))


# 2005
pm_daily_merged_files_05 <- list.files(path=dir_save_daily,pattern = "^2005(.*)rds$")

pm_daily_merged_05 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_05) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_05)){
  pm_daily_merged_files_05_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_05[i]))
  pm_daily_merged_05 <- rbind(pm_daily_merged_05, pm_daily_merged_files_05_temp)
  rm(pm_daily_merged_files_05_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_05 <- pm_daily_merged_05 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_05) <- c('ZIP','pm25')
saveRDS(pm_annual_05,file = paste0(dir_save_annual,'2005.rds'))


# 2006
pm_daily_merged_files_06 <- list.files(path=dir_save_daily,pattern = "^2006(.*)rds$")

pm_daily_merged_06 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_06) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_06)){
  pm_daily_merged_files_06_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_06[i]))
  pm_daily_merged_06 <- rbind(pm_daily_merged_06, pm_daily_merged_files_06_temp)
  rm(pm_daily_merged_files_06_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_06 <- pm_daily_merged_06 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_06) <- c('ZIP','pm25')
saveRDS(pm_annual_06,file = paste0(dir_save_annual,'2006.rds'))


# 2007
pm_daily_merged_files_07 <- list.files(path=dir_save_daily,pattern = "^2007(.*)rds$")

pm_daily_merged_07 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_07) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_07)){
  pm_daily_merged_files_07_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_07[i]))
  pm_daily_merged_07 <- rbind(pm_daily_merged_07, pm_daily_merged_files_07_temp)
  rm(pm_daily_merged_files_07_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_07 <- pm_daily_merged_07 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_07) <- c('ZIP','pm25')
saveRDS(pm_annual_07,file = paste0(dir_save_annual,'2007.rds'))


# 2008
pm_daily_merged_files_08 <- list.files(path=dir_save_daily,pattern = "^2008(.*)rds$")

pm_daily_merged_08 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_08) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_08)){
  pm_daily_merged_files_08_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_08[i]))
  pm_daily_merged_08 <- rbind(pm_daily_merged_08, pm_daily_merged_files_08_temp)
  rm(pm_daily_merged_files_08_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_08 <- pm_daily_merged_08 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_08) <- c('ZIP','pm25')
saveRDS(pm_annual_08,file = paste0(dir_save_annual,'2008.rds'))


# 2009
pm_daily_merged_files_09 <- list.files(path=dir_save_daily,pattern = "^2009(.*)rds$")

pm_daily_merged_09 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_09) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_09)){
  pm_daily_merged_files_09_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_09[i]))
  pm_daily_merged_09 <- rbind(pm_daily_merged_09, pm_daily_merged_files_09_temp)
  rm(pm_daily_merged_files_09_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_09 <- pm_daily_merged_09 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_09) <- c('ZIP','pm25')
saveRDS(pm_annual_09,file = paste0(dir_save_annual,'2009.rds'))


# 2010
pm_daily_merged_files_10 <- list.files(path=dir_save_daily,pattern = "^2010(.*)rds$")

pm_daily_merged_10 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_10) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_10)){
  pm_daily_merged_files_10_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_10[i]))
  pm_daily_merged_10 <- rbind(pm_daily_merged_10, pm_daily_merged_files_10_temp)
  rm(pm_daily_merged_files_10_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_10 <- pm_daily_merged_10 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_10) <- c('ZIP','pm25')
saveRDS(pm_annual_10,file = paste0(dir_save_annual,'2010.rds'))


# 2011
pm_daily_merged_files_11 <- list.files(path=dir_save_daily,pattern = "^2011(.*)rds$")

pm_daily_merged_11 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_11) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_11)){
  pm_daily_merged_files_11_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_11[i]))
  pm_daily_merged_11 <- rbind(pm_daily_merged_11, pm_daily_merged_files_11_temp)
  rm(pm_daily_merged_files_11_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_11 <- pm_daily_merged_11 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_11) <- c('ZIP','pm25')
saveRDS(pm_annual_11,file = paste0(dir_save_annual,'2011.rds'))


# 2012
pm_daily_merged_files_12 <- list.files(path=dir_save_daily,pattern = "^2012(.*)rds$")

pm_daily_merged_12 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_12) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_12)){
  pm_daily_merged_files_12_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_12[i]))
  pm_daily_merged_12 <- rbind(pm_daily_merged_12, pm_daily_merged_files_12_temp)
  rm(pm_daily_merged_files_12_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_12 <- pm_daily_merged_12 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_12) <- c('ZIP','pm25')
saveRDS(pm_annual_12,file = paste0(dir_save_annual,'2012.rds'))


# 2013
pm_daily_merged_files_13 <- list.files(path=dir_save_daily,pattern = "^2013(.*)rds$")

pm_daily_merged_13 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_13) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_13)){
  pm_daily_merged_files_13_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_13[i]))
  pm_daily_merged_13 <- rbind(pm_daily_merged_13, pm_daily_merged_files_13_temp)
  rm(pm_daily_merged_files_13_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_13 <- pm_daily_merged_13 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_13) <- c('ZIP','pm25')
saveRDS(pm_annual_13,file = paste0(dir_save_annual,'2013.rds'))


# 2014
pm_daily_merged_files_14 <- list.files(path=dir_save_daily,pattern = "^2014(.*)rds$")

pm_daily_merged_14 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_14) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_14)){
  pm_daily_merged_files_14_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_14[i]))
  pm_daily_merged_14 <- rbind(pm_daily_merged_14, pm_daily_merged_files_14_temp)
  rm(pm_daily_merged_files_14_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_14 <- pm_daily_merged_14 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_14) <- c('ZIP','pm25')
saveRDS(pm_annual_14,file = paste0(dir_save_annual,'2014.rds'))


# 2015
pm_daily_merged_files_15 <- list.files(path=dir_save_daily,pattern = "^2015(.*)rds$")

pm_daily_merged_15 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_15) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_15)){
  pm_daily_merged_files_15_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_15[i]))
  pm_daily_merged_15 <- rbind(pm_daily_merged_15, pm_daily_merged_files_15_temp)
  rm(pm_daily_merged_files_15_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_15 <- pm_daily_merged_15 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_15) <- c('ZIP','pm25')
saveRDS(pm_annual_15,file = paste0(dir_save_annual,'2015.rds'))


# 2016
pm_daily_merged_files_16 <- list.files(path=dir_save_daily,pattern = "^2016(.*)rds$")

pm_daily_merged_16 <- data.frame(matrix(NA, nrow=0, ncol=2))
names(pm_daily_merged_16) <- c('ZIP','pm25')
for (i in 1:length(pm_daily_merged_files_16)){
  pm_daily_merged_files_16_temp <- readRDS(paste0(dir_save_daily,pm_daily_merged_files_16[i]))
  pm_daily_merged_16 <- rbind(pm_daily_merged_16, pm_daily_merged_files_16_temp)
  rm(pm_daily_merged_files_16_temp)
  if( i %% 20 == 0 ) cat(paste("iteration", i, "complete\n"))
}
pm_annual_16 <- pm_daily_merged_16 %>% dplyr::group_by(ZIP) %>% dplyr::summarize(pm25_annual=mean(pm25,na.rm=TRUE))
names(pm_annual_16) <- c('ZIP','pm25')
saveRDS(pm_annual_16,file = paste0(dir_save_annual,'2016.rds'))


