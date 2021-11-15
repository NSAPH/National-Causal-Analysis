library("nnet")
library("xgboost")
library("SuperLearner")
library("parallel")
library(ggplot2)
library(grid) 
library(gridExtra)
library(data.table)
library(fst)
library("KernSmooth")

###############pm
output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
load(paste0(output, "prematch_data.RData"))

f <- list.files(paste0(output, "pm25_adjusted/"),
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)


load(paste0(output, "prematch_pm25_adjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$pm25_ensemble

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out=100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list,function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n,40*delta_n,2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf(paste0(output,"DR100.pdf"),width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file = paste0(output, "smoothed_pm25_adjusted.RData"))

# pm25 | no2
f <- list.files(paste0(output, "pm25_adjusted_no2/"),
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

load(paste0(output, "prematch_pm25_adjusted_no2.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$pm25_ensemble

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
match_data <- subset(match_data,
                     treat <= quantile(prematch_data$pm25_ensemble, 0.99)&
                     treat >= quantile(prematch_data$pm25_ensemble, 0.01))
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out=100)
#a.vals <- subset(a.vals,
#                 a.vals <= quantile(prematch_data$pm25_ensemble, 0.99),
#                 a.vals >= quantile(prematch_data$pm25_ensemble, 0.01))
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list,function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n,40*delta_n,2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf(paste0(output,"DR100.pdf"),width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file = paste0(output, "smoothed_pm25_adjusted_no2.RData"))

###############no2
f <- list.files("~/shared_space/ci3_xwu/HEI_final/no2_adjusted/",
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
#load(paste0(output, "prematch_data.RData"))
load(paste0(output, "prematch_no2_adjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$no2

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out = 100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list, function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n, 40*delta_n, 2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/DR100.pdf",width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file= paste0(output, "smoothed_no2_adjusted.RData"))

###############ozone
f <- list.files("~/shared_space/ci3_xwu/HEI_final/ozone_adjusted/",
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
#load(paste0(output, "prematch_data.RData"))
load(paste0(output, "prematch_ozone_adjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$ozone

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out = 100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list, function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n, 40*delta_n, 2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/DR100.pdf",width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file= paste0(output, "smoothed_ozone_adjusted.RData"))


###############pm unadjusted
output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
load(paste0(output, "prematch_data.RData"))

f <- list.files(paste0(output,"pm25_unadjusted/"),
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

load(paste0(output, "prematch_pm25_unadjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$pm25_ensemble

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out=100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list,function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n,40*delta_n,2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/DR100.pdf",width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file = paste0(output, "smoothed_pm25_unadjusted.RData"))


###############no2 unadjusted
f <- list.files("~/shared_space/ci3_xwu/HEI_final/no2_unadjusted/",
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
load(paste0(output, "prematch_data.RData"))
load(paste0(output, "prematch_no2_unadjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$no2

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out = 100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list, function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n, 40*delta_n, 2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/DR100.pdf",width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file= paste0(output, "smoothed_no2_unadjusted.RData"))

########## ozone unadjusted
f <- list.files("~/shared_space/ci3_xwu/HEI_final/ozone_unadjusted/",
                pattern = "\\.rds",
                full.names = TRUE)
match_data.list<- lapply(f, readRDS)
match_data.list <- match_data.list[sapply(match_data.list, function(a){nrow(a[[1]])}) ==nrow(prematch_data)]
match_data.list <- lapply(match_data.list,function(a){a[[1]]})
match_data <- do.call(rbind.data.frame,match_data.list)

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
load(paste0(output, "prematch_data.RData"))
load(paste0(output, "prematch_ozone_unadjusted.RData"))
source(paste0(output, "application_function.R"))
prematch_data$treat <- prematch_data$ozone

#saveRDS(match_data,file= "/nfs/home/X/xwu/shared_space/ci3_nsaph/XiaoWu/GPSmatching_data/match_data.rds")
a.vals <- seq(min(prematch_data$treat), max(prematch_data$treat), length.out = 100)
dose_matching.response.nonsmooth <- sapply(match_data.list,function(a){mean(a$Y)})
a.vals.nosmooth <- sapply(match_data.list, function(a){mean(a$treat)})
dose_matching.response.smooth<-matching_smooth(pseudo.out=match_data$Y,
                                               bw.seq= seq(8*delta_n, 40*delta_n, 2*delta_n),
                                               a.vals= a.vals,
                                               a=match_data$treat)

#pdf("/nfs/home/X/xwu/shared_space/ci3_analysis/GPSmatching/DR100.pdf",width=8.5,height=11)
plot(a.vals,
     dose_matching.response.smooth,
     col="red", type="l" ,main="",
     xlab=expression(paste("PM"[2.5]," (",mu,g/m^3,")")),
     ylab=expression(paste("Mortality Rate ", "(per 100 Medicare Enrollees)")),
     lwd=3, yaxt="n", ylim=c(0.02,0.07), cex.axis=1.5, cex.lab=1.5)
lines(a.vals.nosmooth,dose_matching.response.nonsmooth,col="blue",lwd=1,lty=2,type="p")
#lines(a.vals,dose_matching.response.smooth.quad-1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
#lines(a.vals,dose_matching.response.smooth.quad+1.96*std_curve*sqrt(2*sqrt(2049))/sqrt(2049),col="red",lwd=1,lty=2)
axis(side = 2, at = seq(0.02,0.07,0.005),labels=seq(0.02,0.07,0.005)*100,cex.axis=1.5)
#dev.off()          

save(a.vals,
     dose_matching.response.nonsmooth,
     a.vals.nosmooth,
     dose_matching.response.smooth,
     file= paste0(output, "smoothed_ozone_unadjusted.RData"))


