rm(list=ls())
gc()

library(lubridate)
library(dplyr)

dir_save <- '/media/gate/yaguang/Aggregate_PM25/US_ZIP_PM25_ZipAverage/daily/'
dir_save_pobox <- '/media/gate/yaguang/Aggregate_PM25/US_POBOX_PM25/daily/'
dir_save_merged_daily <- '/media/gate/yaguang/Aggregate_PM25/US_PM25_ZipcodeAverage_2000_2016/daily/'
dir_save_merged_annual <- '/media/gate/yaguang/Aggregate_PM25/US_PM25_ZipcodeAverage_2000_2016/annual/'
dir_validate <- '/media/gate/yaguang/Aggregate_PM25/'
dir_pobox <- '/media/gate/yaguang/Aggregate_PM25/pobox_csv/'


######################################################################
################# 1. Validate zipcode-averaged PM2.5 #################
######################################################################

##### How many days in each year?
files_00 <- list.files(path=dir_save,pattern = "^2000(.*)rds$")
files_01 <- list.files(path=dir_save,pattern = "^2001(.*)rds$")
files_02 <- list.files(path=dir_save,pattern = "^2002(.*)rds$")
files_03 <- list.files(path=dir_save,pattern = "^2003(.*)rds$")
files_04 <- list.files(path=dir_save,pattern = "^2004(.*)rds$")
files_05 <- list.files(path=dir_save,pattern = "^2005(.*)rds$")
files_06 <- list.files(path=dir_save,pattern = "^2006(.*)rds$")
files_07 <- list.files(path=dir_save,pattern = "^2007(.*)rds$")
files_08 <- list.files(path=dir_save,pattern = "^2008(.*)rds$")
files_09 <- list.files(path=dir_save,pattern = "^2009(.*)rds$")
files_10 <- list.files(path=dir_save,pattern = "^2010(.*)rds$")
files_11 <- list.files(path=dir_save,pattern = "^2011(.*)rds$")
files_12 <- list.files(path=dir_save,pattern = "^2012(.*)rds$")
files_13 <- list.files(path=dir_save,pattern = "^2013(.*)rds$")
files_14 <- list.files(path=dir_save,pattern = "^2014(.*)rds$")
files_15 <- list.files(path=dir_save,pattern = "^2015(.*)rds$")
files_16 <- list.files(path=dir_save,pattern = "^2016(.*)rds$")

length(files_00)+length(files_01)+length(files_02)+length(files_03)+length(files_04)+length(files_05)+
  length(files_06)+length(files_07)+length(files_08)+length(files_09)+length(files_10)+length(files_11)+
  length(files_12)+length(files_13)+length(files_14)+length(files_15)+length(files_16)

files_list <- list(files_00,files_01,files_02,files_03,files_04,files_05,files_06,files_07,files_08,files_09,files_10,
                   files_11,files_12,files_13,files_14,files_15,files_16)


##### Random samples from the zipcode-vaeraged PM2.5, to compare with QD's old PM2.5
validate <- data.frame(matrix(NA, nrow=0, ncol=3))
colnames(validate) <- c("date", "ZIP", "avgpm")
for (i in 1:length(files_list)) {
  validate_i <- data.frame(matrix(NA, nrow=10*10, ncol=3))
  colnames(validate_i) <- c("date", "ZIP", "avgpm")
  days <- unlist(files_list[i])[sample(1:length(unlist(files_list[i])),10)]
  validate_i$date <- rep(gsub("[A-z \\.\\(\\)]", "", days),each=10)
  zip_pm <- data.frame(matrix(NA, nrow=0, ncol=2))
  for (j in 1:length(days)) {
    zip_pm_j <- readRDS(paste0(dir_save,days[j]))[sample(1:dim(readRDS(paste0(dir_save,days[j])))[1],10),]
    zip_pm <- rbind(zip_pm,zip_pm_j)
  }
  validate_i$ZIP <- zip_pm$ZIP
  validate_i$avgpm <- zip_pm$avgpm
  validate <- rbind(validate,validate_i)
  # validate$date <- as.Date(validate$date, format = "%y%m%d")
}
validate$date <- ymd(validate$date)
validate <- validate[order(validate$date),]

save(validate,file=paste0(dir_validate,'dat_validate_zipcode.RData'))


##### How many zipcodes on each day? How many missingness?
pm_files <- list.files(path=dir_save)
n_zip_missing <- data.frame(matrix(NA, nrow=length(pm_files), ncol=3))
names(n_zip_missing) <- c('date','n_zip','n_missing')
for (i in 1:length(pm_files)) {
  n_zip_missing[i,1] <- ymd(gsub('([0-9]+).*$','\\1',pm_files[i]))
  n_zip_missing[i,2] <- dim(readRDS(paste0(dir_save,pm_files[i])))[1]
  n_zip_missing[i,3] <- sum(is.na(readRDS(paste0(dir_save,pm_files[i]))[,2]))
}
n_zip_missing$date <- as.Date(n_zip_missing$date,origin = "1970-01-01")
summary(n_zip_missing$n_zip)
summary(n_zip_missing$n_missing)
test <- n_zip_missing %>% filter(n_missing!=0)



######################################################################
###################### 2. Validate PO Boxes PM2.5 ####################
######################################################################

##### Are there any duplicate zips between regular zipcodes and PO box?
### 2000
zip_shape_00 <- readRDS(paste0(dir_save,"20000101.rds"))$ZIP
zip_po_00 <- read.csv(paste0(dir_pobox,"ESRI00USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_00,zip_po_00)
# integer(0)

### 2001
zip_shape_01 <- readRDS(paste0(dir_save,"20010101.rds"))$ZIP
zip_po_01 <- read.csv(paste0(dir_pobox,"ESRI01USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_01,zip_po_01)
# integer(0)

### 2002
zip_shape_02 <- readRDS(paste0(dir_save,"20020101.rds"))$ZIP
zip_po_02 <- read.csv(paste0(dir_pobox,"ESRI02USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_02,zip_po_02)
# integer(0)

### 2003
zip_shape_03 <- readRDS(paste0(dir_save,"20030101.rds"))$ZIP
zip_po_03 <- read.csv(paste0(dir_pobox,"ESRI03USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_03,zip_po_03)
# integer(0)

### 2004
zip_shape_04 <- readRDS(paste0(dir_save,"20040101.rds"))$ZIP
zip_po_04 <- read.csv(paste0(dir_pobox,"ESRI04USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_04,zip_po_04)
# integer(0)

### 2005
zip_shape_05 <- readRDS(paste0(dir_save,"20050101.rds"))$ZIP
zip_po_05 <- read.csv(paste0(dir_pobox,"ESRI05USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_05,zip_po_05)
# [1] 42223 57724 63673 71749 72395 73949

### 2006
zip_shape_06 <- readRDS(paste0(dir_save,"20060101.rds"))$ZIP
zip_po_06 <- read.csv(paste0(dir_pobox,"ESRI06USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_06,zip_po_06)
# [1] 42223 57724 63673 71749 72395 73949

### 2007
zip_shape_07 <- readRDS(paste0(dir_save,"20070101.rds"))$ZIP
zip_po_07 <- read.csv(paste0(dir_pobox,"ESRI07USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_07,zip_po_07)
# integer(0)

### 2008
zip_shape_08 <- readRDS(paste0(dir_save,"20080101.rds"))$ZIP
zip_po_08 <- read.csv(paste0(dir_pobox,"ESRI08USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_08,zip_po_08)
# integer(0)

### 2009
zip_shape_09 <- readRDS(paste0(dir_save,"20090101.rds"))$ZIP
zip_po_09 <- read.csv(paste0(dir_pobox,"ESRI09USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_09,zip_po_09)
# integer(0)

### 2010
zip_shape_10 <- readRDS(paste0(dir_save,"20100101.rds"))$ZIP
zip_po_10 <- read.csv(paste0(dir_pobox,"ESRI10USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_10,zip_po_10)
# integer(0)

### 2011
zip_shape_11 <- readRDS(paste0(dir_save,"20110101.rds"))$ZIP
zip_po_11 <- read.csv(paste0(dir_pobox,"ESRI11USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_11,zip_po_11)
# integer(0)

### 2012
zip_shape_12 <- readRDS(paste0(dir_save,"20120101.rds"))$ZIP
zip_po_12 <- read.csv(paste0(dir_pobox,"ESRI12USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_12,zip_po_12)
# integer(0)

### 2013
zip_shape_13 <- readRDS(paste0(dir_save,"20130101.rds"))$ZIP
zip_po_13 <- read.csv(paste0(dir_pobox,"ESRI13USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_13,zip_po_13)
# integer(0)

### 2014
zip_shape_14 <- readRDS(paste0(dir_save,"20140101.rds"))$ZIP
zip_po_14 <- read.csv(paste0(dir_pobox,"ESRI14USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_14,zip_po_14)
# integer(0)

### 2015
zip_shape_15 <- readRDS(paste0(dir_save,"20150501.rds"))$ZIP
zip_po_15 <- read.csv(paste0(dir_pobox,"ESRI15USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_15,zip_po_15)
# integer(0)

### 2016
zip_shape_16 <- readRDS(paste0(dir_save,"20160101.rds"))$ZIP
zip_po_16 <- read.csv(paste0(dir_pobox,"ESRI16USZIP5_POINT_WGS84_POBOX.csv"))$ZIP
intersect(zip_shape_16,zip_po_16)
# integer(0)

##### How many days in each year?
files_00_pobox <- list.files(path=dir_save_pobox,pattern = "^2000(.*)rds$")
files_01_pobox <- list.files(path=dir_save_pobox,pattern = "^2001(.*)rds$")
files_02_pobox <- list.files(path=dir_save_pobox,pattern = "^2002(.*)rds$")
files_03_pobox <- list.files(path=dir_save_pobox,pattern = "^2003(.*)rds$")
files_04_pobox <- list.files(path=dir_save_pobox,pattern = "^2004(.*)rds$")
files_05_pobox <- list.files(path=dir_save_pobox,pattern = "^2005(.*)rds$")
files_06_pobox <- list.files(path=dir_save_pobox,pattern = "^2006(.*)rds$")
files_07_pobox <- list.files(path=dir_save_pobox,pattern = "^2007(.*)rds$")
files_08_pobox <- list.files(path=dir_save_pobox,pattern = "^2008(.*)rds$")
files_09_pobox <- list.files(path=dir_save_pobox,pattern = "^2009(.*)rds$")
files_10_pobox <- list.files(path=dir_save_pobox,pattern = "^2010(.*)rds$")
files_11_pobox <- list.files(path=dir_save_pobox,pattern = "^2011(.*)rds$")
files_12_pobox <- list.files(path=dir_save_pobox,pattern = "^2012(.*)rds$")
files_13_pobox <- list.files(path=dir_save_pobox,pattern = "^2013(.*)rds$")
files_14_pobox <- list.files(path=dir_save_pobox,pattern = "^2014(.*)rds$")
files_15_pobox <- list.files(path=dir_save_pobox,pattern = "^2015(.*)rds$")
files_16_pobox <- list.files(path=dir_save_pobox,pattern = "^2016(.*)rds$")

files_list_pobox <- list(files_00_pobox,files_01_pobox,files_02_pobox,files_03_pobox,files_04_pobox,files_05_pobox,files_06_pobox,
                         files_07_pobox,files_08_pobox,files_09_pobox,files_10_pobox,files_11_pobox,files_12_pobox,files_13_pobox,
                         files_14_pobox,files_15_pobox,files_16_pobox)


##### Random samples from the PO Box PM2.5, to compare with QD's old PM2.5
validate_pobox <- data.frame(matrix(NA, nrow=0, ncol=3))
colnames(validate_pobox) <- c("date", "ZIP", "pm25")
for (i in 1:length(files_list_pobox)) {
  validate_i_pobox <- data.frame(matrix(NA, nrow=10*10, ncol=3))
  colnames(validate_i_pobox) <- c("date", "ZIP", "pm25")
  days_pobox <- unlist(files_list_pobox[i])[sample(1:length(unlist(files_list_pobox[i])),10)]
  validate_i_pobox$date <- rep(gsub("[A-z \\.\\(\\)]", "", days_pobox),each=10)
  pobox_pm <- data.frame(matrix(NA, nrow=0, ncol=2))
  for (j in 1:length(days_pobox)) {
    pobox_pm_j <- readRDS(paste0(dir_save_pobox,days_pobox[j]))[sample(1:dim(readRDS(paste0(dir_save_pobox,days_pobox[j])))[1],10),]
    pobox_pm <- rbind(pobox_pm,pobox_pm_j)
  }
  validate_i_pobox$ZIP <- pobox_pm$ZIP
  validate_i_pobox$pm25 <- pobox_pm$pm25
  validate_pobox <- rbind(validate_pobox,validate_i_pobox)
  # validate$date <- as.Date(validate$date, format = "%y%m%d")
}
validate_pobox$date <- ymd(validate_pobox$date)
validate_pobox <- validate_pobox[order(validate_pobox$date),]

save(validate_pobox,file=paste0(dir_validate,'dat_validate_pobox.RData'))

test <- readRDS(paste0(dir_save_pobox,'20160101.rds'))
summary(test)


##### How many zipcodes on each day? How many missingness?
pobox_files <- list.files(path=dir_save_pobox)
n_zip_missing_pobox <- data.frame(matrix(NA, nrow=length(pobox_files), ncol=3))
names(n_zip_missing_pobox) <- c('date','n_zip','n_missing')
for (i in 1:length(pobox_files)) {
  n_zip_missing_pobox[i,1] <- ymd(gsub('([0-9]+).*$','\\1',pobox_files[i]))
  n_zip_missing_pobox[i,2] <- dim(readRDS(paste0(dir_save_pobox,pobox_files[i])))[1]
  n_zip_missing_pobox[i,3] <- sum(is.na(readRDS(paste0(dir_save_pobox,pobox_files[i]))[,2]))
}
n_zip_missing_pobox$date <- as.Date(n_zip_missing_pobox$date,origin = "1970-01-01")
summary(n_zip_missing_pobox$n_zip)
summary(n_zip_missing_pobox$n_missing)
test <- n_zip_missing_pobox %>% filter(n_missing!=0)


##########################################################################
###################### 3. Validate merged daily PM2.5 ####################
##########################################################################
##### How many days in each year?
files_00_merged <- list.files(path=dir_save_merged_daily,pattern = "^2000(.*)rds$")
files_01_merged <- list.files(path=dir_save_merged_daily,pattern = "^2001(.*)rds$")
files_02_merged <- list.files(path=dir_save_merged_daily,pattern = "^2002(.*)rds$")
files_03_merged <- list.files(path=dir_save_merged_daily,pattern = "^2003(.*)rds$")
files_04_merged <- list.files(path=dir_save_merged_daily,pattern = "^2004(.*)rds$")
files_05_merged <- list.files(path=dir_save_merged_daily,pattern = "^2005(.*)rds$")
files_06_merged <- list.files(path=dir_save_merged_daily,pattern = "^2006(.*)rds$")
files_07_merged <- list.files(path=dir_save_merged_daily,pattern = "^2007(.*)rds$")
files_08_merged <- list.files(path=dir_save_merged_daily,pattern = "^2008(.*)rds$")
files_09_merged <- list.files(path=dir_save_merged_daily,pattern = "^2009(.*)rds$")
files_10_merged <- list.files(path=dir_save_merged_daily,pattern = "^2010(.*)rds$")
files_11_merged <- list.files(path=dir_save_merged_daily,pattern = "^2011(.*)rds$")
files_12_merged <- list.files(path=dir_save_merged_daily,pattern = "^2012(.*)rds$")
files_13_merged <- list.files(path=dir_save_merged_daily,pattern = "^2013(.*)rds$")
files_14_merged <- list.files(path=dir_save_merged_daily,pattern = "^2014(.*)rds$")
files_15_merged <- list.files(path=dir_save_merged_daily,pattern = "^2015(.*)rds$")
files_16_merged <- list.files(path=dir_save_merged_daily,pattern = "^2016(.*)rds$")

files_list_merged_daily <- list(files_00_merged,files_01_merged,files_02_merged,files_03_merged,files_04_merged,files_05_merged,files_06_merged,
                                files_07_merged,files_08_merged,files_09_merged,files_10_merged,files_11_merged,files_12_merged,files_13_merged,
                                files_14_merged,files_15_merged,files_16_merged)


##### How many zipcodes on each day? How many missingness? How many duplicate zipcodes?
merged_files <- list.files(path=dir_save_merged_daily)
n_zip_missing_merged <- data.frame(matrix(NA, nrow=length(merged_files), ncol=5))
names(n_zip_missing_merged) <- c('date','n_zip','n_missing','n_unique','n_duplicate')
for (i in 1:length(merged_files)) {
  n_zip_missing_merged[i,1] <- ymd(gsub('([0-9]+).*$','\\1',merged_files[i]))
  n_zip_missing_merged[i,2] <- dim(readRDS(paste0(dir_save_merged_daily,merged_files[i])))[1]
  n_zip_missing_merged[i,3] <- sum(is.na(readRDS(paste0(dir_save_merged_daily,merged_files[i]))[,2]))
  n_zip_missing_merged[i,4] <- length(unique(readRDS(paste0(dir_save_merged_daily,merged_files[i]))$ZIP))
  n_zip_missing_merged[i,5] <- n_zip_missing_merged[i,2] - n_zip_missing_merged[i,4] 
  if( i %% 100 == 0 ) cat(paste("iteration", i, "complete\n"))
}
n_zip_missing_merged$date <- as.Date(n_zip_missing_merged$date,origin = "1970-01-01")
summary(n_zip_missing_merged)
test <- n_zip_missing_merged %>% filter(n_missing!=0)
test2 <- n_zip_missing_merged %>% filter(n_duplicate!=0)
