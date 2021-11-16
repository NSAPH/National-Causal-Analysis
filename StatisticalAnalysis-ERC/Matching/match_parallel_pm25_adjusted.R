#library("nnet")
#library("xgboost")
#library("SuperLearner")
library("parallel")


output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"

load(paste0(output, "prematch_pm25_adjusted.RData"))
source(paste0(output, "application_function.R"))
process <- c(1:(length(bin.num)))[as.integer(as.character(commandArgs(trailingOnly = TRUE))) + 1]

match_data <-  mclapply(bin.num[process],
                        matching.fun.dose.l1.caliper_xgb, 
                        dataset=dataset,
                        e_gps_pred = e_gps_pred,
                        e_gps_std_pred = e_gps_std_pred,
                        delta_n=delta_n,
                        scale=scale,
                        mc.cores = 8)

saveRDS(match_data,
        paste0(output,"/pm25_adjusted/",process,".rds"))


