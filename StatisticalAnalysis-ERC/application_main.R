library("nnet")
library("xgboost")
library("SuperLearner")
library("parallel")
library(ggplot2)
require(gridExtra)
library(data.table)
library(fst)
library("KernSmooth")
library("stringr")

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"

load("/nfs/home/X/xwu/shared_space/ci3_analysis/pdez_measurementerror/National_Causal-master/balance_qd/covariates_qd.RData")
load("/nfs/home/X/xwu/shared_space/ci3_analysis/pdez_measurementerror/National_Causal-master/aggregate_data_qd.RData")
dead_personyear<-aggregate(cbind(aggregate_data_qd$dead,
                                 aggregate_data_qd$time_count),
                           by=list( aggregate_data_qd$zip,
                                    aggregate_data_qd$year), 
                           FUN=sum)
colnames(dead_personyear)[1:4]<-c("zip","year","dead","time_count")
dead_personyear[,"mortality"] <- dead_personyear[,"dead"]/dead_personyear[,"time_count"]
prematch_data <- merge(dead_personyear, covariates_qd,
                       by=c("zip", "year"))

save(prematch_data,
     file=paste0(output, "prematch_data.RData"))

allyears_ozone <- read.csv("/nfs/home/X/xwu/shared_space/ci3_exposure/ozone/whole_us/annual/zipcode/requaia_predictions/ywei_aggregation/all_years.csv")
allyears_ozone$ZIP <- str_pad(allyears_ozone$ZIP, 5, pad = "0")
allyears_no2 <- read.csv("/nfs/home/X/xwu/shared_space/ci3_exposure/no2/whole_us/annual/zipcode/qd_predictions_ensemble/ywei_aggregations/all_years.csv")
allyears_no2$ZIP <- str_pad(allyears_no2$ZIP, 5, pad = "0")

source("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/application_function.R")

prematch_data = merge(prematch_data, 
                      allyears_ozone, 
                      by.x = c("zip","year"), 
                      by.y = c("ZIP","year"))
prematch_data = merge(prematch_data, 
                      allyears_no2, 
                      by.x = c("zip","year"), 
                      by.y = c("ZIP","year"))

save(prematch_data,
     file = paste0(output,"prematch_data.RData"))

load(paste0(output,"prematch_data.RData"))
# 1) pm25 adjusted
treat = prematch_data["pm25_ensemble"]$pm25_ensemble
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year",
                     "no2", "ozone")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_pm25_adjusted.RData"))

# 1) pm25 adjusted no2 only
treat = prematch_data["pm25_ensemble"]$pm25_ensemble
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year",
                     "no2")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_pm25_adjusted_no2.RData"))

# 2) no2 adjusted
treat = prematch_data["no2"]$no2
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year",
                     "pm25_ensemble", "ozone")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_no2_adjusted.RData"))


# 3) ozone adjusted
treat = prematch_data["ozone"]$ozone
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year",
                     "pm25_ensemble", "no2")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_ozone_adjusted.RData"))


# 4) pm25 unadjusted
treat = prematch_data["pm25_ensemble"]$pm25_ensemble
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_pm25_unadjusted.RData"))


# 5) no2 unadjusted
treat = prematch_data["no2"]$no2
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_no2_unadjusted.RData"))


# 6) ozone unadjusted
treat = prematch_data["ozone"]$ozone
c = prematch_data[,c("mean_bmi", "smoke_rate", "hispanic", "pct_blk", "medhouseholdincome" ,"medianhousevalue",
                     "poverty", "education", "popdensity", "pct_owner_occ",
                     "summer_tmmx", "winter_tmmx", "summer_rmax", "winter_rmax",
                     "region", "year")]
Y = prematch_data[,"mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds = 50)
e_gps_pred <- predict(GPS_mod, data.matrix(c))
e_gps_std_pred <- sd(treat - e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y, treat, c, GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat), length.out = 100)
delta_n <- bin.num[2] - bin.num[1]
scale <- 1.0

save(bin.num,
     dataset,
     e_gps_pred,
     e_gps_std_pred,
     delta_n,
     scale,
     file = paste0(output,"prematch_ozone_unadjusted.RData"))

