# Generate all required data from different data sources (see Table S1).
library(fst)
library(data.table)
library(parallel)
library("xgboost")
library("dplyr")
library("foreign")

f <- list.files("/nfs/nsaph_ci3/ci3_health_data/medicare/mortality/1999_2016/wu/cache_data/merged_by_year_v2",
                pattern = "\\.fst",
                full.names = TRUE)

myvars <- c("qid", "year","zip","sex","race","age","dual","entry_age_break","statecode",
            "followup_year","followup_year_plus_one","dead","pm25_ensemble",
            "mean_bmi","smoke_rate","hispanic","pct_blk","medhouseholdincome","medianhousevalue",
            "poverty","education","popdensity", "pct_owner_occ","summer_tmmx","winter_tmmx","summer_rmax","winter_rmax")
national_merged2016_qd <- rbindlist(lapply(f,
                        read_fst,
                        columns = myvars,
                        as.data.table=TRUE))

national_merged2016_qd<-as.data.frame(national_merged2016_qd)

national_merged2016_qd$zip <- sprintf("%05d", national_merged2016_qd$zip)

NORTHEAST=c("NY","MA","PA","RI","NH","ME","VT","CT","NJ")  
SOUTH=c("DC","VA","NC","WV","KY","SC","GA","FL","AL","TN","MS","AR","MD","DE","OK","TX","LA")
MIDWEST=c("OH","IN","MI","IA","MO","WI","MN","SD","ND","IL","KS","NE")
WEST=c("MT","CO","WY","ID","UT","NV","CA","OR","WA","AZ","NM")

national_merged2016_qd$region=ifelse(national_merged2016_qd$state %in% NORTHEAST, "NORTHEAST", 
                                  ifelse(national_merged2016_qd$state %in% SOUTH, "SOUTH",
                                         ifelse(national_merged2016_qd$state %in% MIDWEST, "MIDWEST",
                                                ifelse(national_merged2016_qd$state %in% WEST, "WEST",
                                                       NA))))

national_merged2016_qd <- national_merged2016_qd[complete.cases(national_merged2016_qd[,c(1:27)]) ,]
#> dim(national_merged2016)
#[1] 573,370,257        27

# Main analysis with QD
covariates_qd<-aggregate(national_merged2016_qd[,c(12:27)], 
                         by=list(national_merged2016_qd$zip,national_merged2016_qd$year), 
                         FUN=min)
colnames(covariates_qd)[1:2]<-c("zip","year")

covariates_qd<-subset(covariates_qd[complete.cases(covariates_qd) ,])
covariates_qd$year_fac <- as.factor(covariates_qd$year)
covariates_qd$region <- as.factor(covariates_qd$region)

output = "/nfs/home/X/xwu/shared_space/ci3_xwu/HEI_final/"
save(covariates_qd,
     file = paste0(output, "Data/covariates_qd.RData"))

# Generate count data for each individual characteristics and follow-up year
national_merged2016_qd$time_count<-national_merged2016_qd$followup_year_plus_one-national_merged2016_qd$followup_year
dead_personyear<-aggregate(cbind(national_merged2016_qd$dead,
                                 national_merged2016_qd$time_count), 
                           by=list(national_merged2016_qd$zip,
                                   national_merged2016_qd$year,
                                   national_merged2016_qd$sex,
                                   national_merged2016_qd$race,
                                   national_merged2016_qd$dual,
                                   national_merged2016_qd$entry_age_break,
                                   national_merged2016_qd$followup_year), 
                           FUN=sum)

confounders<-aggregate(national_merged2016_qd[,c(12:27)], 
                       by=list(national_merged2016_qd$zip,
                               national_merged2016_qd$year,
                                national_merged2016_qd$sex,
                               national_merged2016_qd$race,
                               national_merged2016_qd$dual,
                               national_merged2016_qd$entry_age_break,
                               national_merged2016_qd$followup_year), 
                       FUN=min)
aggregate_data_qd<-merge(dead_personyear,confounders
                      ,by=c("Group.1", "Group.2", "Group.3", "Group.4", "Group.5", "Group.6", "Group.7"))
colnames(aggregate_data_qd)[8:9]<-c("dead","time_count")
colnames(aggregate_data_qd)[1:7]<-c("zip","year","sex","race","dual","entry_age_break","followup_year")
aggregate_data_qd<-subset(aggregate_data_qd[complete.cases(aggregate_data_qd) ,])

save(aggregate_data_qd,
     file = paste0(output, "Data/aggregate_data_qd.RData"))

