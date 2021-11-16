#install.packages("xgboost", repos="http://mirror.hmdc.harvard.edu/CRAN")
library(xgboost)
library("parallel")
library(data.table)
library(fst)
library("KernSmooth")

boots_id <- c(1:500)[as.integer(as.character(commandArgs(trailingOnly = TRUE))) + 1]

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"

load(paste0(output, "prematch_data.RData"))
load(paste0(output, "prematch_pm25_unadjusted.RData"))
source(paste0(output, "application_function.R"))

prematch_data$treat <- prematch_data$pm25_ensemble
all_zip <- unique(prematch_data$zip)
num_uniq_zip <- length(all_zip)
prematch_data.list <- split(prematch_data, list(prematch_data$zip))

set.seed(boots_id)
zip_sample<-sample(1:num_uniq_zip,floor(2*(num_uniq_zip)^{2/3}),replace=T) 
#zip_sample<-sample(1:num_uniq_zip,floor(0.2*num_uniq_zip),replace=T) 
prematch_data.list<-prematch_data.list[zip_sample] 
prematch_data_boots<-subset(prematch_data, zip %in% all_zip[zip_sample])
treat = prematch_data_boots["pm25_ensemble"]$pm25_ensemble
c <- prematch_data_boots[,c("mean_bmi","smoke_rate","hispanic","pct_blk","medhouseholdincome","medianhousevalue",
                     	    "poverty","education","popdensity", "pct_owner_occ",
                            "summer_tmmx","winter_tmmx","summer_rmax","winter_rmax",
                            "region","year")]
Y <- prematch_data_boots[, "mortality"]

###################xgboost
GPS_mod <- xgboost(data = data.matrix(c), label = treat, nrounds=50)
e_gps_pred <- predict(GPS_mod,data.matrix(c))
e_gps_std_pred <- sd(treat-e_gps_pred)
GPS <- dnorm(treat, mean = e_gps_pred, sd = e_gps_std_pred)
dataset <- cbind(Y,treat,c,GPS)

bin.num <- seq(min(dataset$treat), max(dataset$treat),length.out = 100)
delta_n <- bin.num[2]-bin.num[1]
scale <- 1.0
 
match_data.list <-  mclapply(bin.num,
                             function(dataset,
                                      a,
                                      e_gps_pred,
                                      e_gps_std_pred,
                                      delta_n,
                                      scale){
                          tryCatch(matching.fun.dose.l1.caliper_xgb(dataset,
                                                                    a,
                                                                    e_gps_pred,
                                                                    e_gps_std_pred,
                                                                    delta_n,
                                                                    scale)
                          ,error = function(e) {
                            return(NA)})}, 
                        dataset=dataset,
                        e_gps_pred = e_gps_pred,
                        e_gps_std_pred = e_gps_std_pred,
                        delta_n=delta_n,
                        scale=scale,
                        mc.cores=8)

lists <- sapply(match_data.list,function(x){
  if (is.null(nrow(x))==TRUE){return(NA)}
  nrow(x)})
match_data.list <- match_data.list[!is.na(lists)]
match_data <- do.call(rbind.data.frame,match_data.list)
#prematch_data_boots$treat <- prematch_data_boots$pm25_ensemble
a.vals <- seq(min(prematch_data$treat),max(prematch_data$treat),length.out=100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list,function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
					       bw.seq= seq(8*delta_n,40*delta_n,2*delta_n),
                                               #bw.seq= seq(32*delta_n,160*delta_n,32*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

save(a.vals,dose_matching.response.nonsmooth,a.vals.nosmooth,dose_matching.response.smooth,
     file=paste0(output, "Boots/Boots_pm25_unadjusted/boots_",boots_id,".RData"))

          
