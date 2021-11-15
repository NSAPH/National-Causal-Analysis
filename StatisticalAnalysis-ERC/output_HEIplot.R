library("ggplot2")

#### Adjusted for other pollutants
subgroup = "pm25"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_adjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_adjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[10])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[10]))

pdf("pm25_adjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) +
  xlab(expression(paste("PM"[2.5]," (",mu,g/m^3,")"))) +
  ylab("Hazard Ratio") +
  ylim(0.9,1.3) +
  xlim(2.76,17.16)
dev.off()

# pm25 | no2
subgroup = "pm25"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_pm25_adjusted_no2_CausalGPS_trim.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_adjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[10])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[10]))

pdf("pm25_adjusted_no2.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) +
  xlab(expression(paste("PM"[2.5]," (",mu,g/m^3,")"))) +
  ylab("Hazard Ratio") +
  ylim(0.9,1.33) +
  xlim(2.76,17.16)
dev.off()


subgroup = "no2"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_adjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_adjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[3])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[3]))

pdf("no2_adjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) +
  xlab(expression(paste("NO"[2]," (ppb)"))) +
  ylab("Hazard Ratio") +
  ylim(0.9,2.2) +
  xlim(3.4,75)
dev.off()

subgroup = "ozone"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_adjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_adjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[24])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[24]))

pdf("ozone_adjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) +
  xlab(expression(paste("Ozone"," (ppb)"))) +
  ylab("Hazard Ratio") +
  ylim(0.8,1.22) +
  xlim(29.5,51)
dev.off()


#### Unadjusted for other pollutants
subgroup = "pm25"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_unadjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_unadjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[10])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[10]))

pdf("pm25_unadjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) + 
  xlab(expression(paste("PM"[2.5]," (",mu,g/m^3,")"))) +
  ylab("Hazard Ratio") +
  ylim(0.9,1.3) +
  xlim(2.76,17.16)
dev.off()

subgroup = "no2"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_unadjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_unadjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[3])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[3]))

pdf("no2_unadjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) + 
  xlab(expression(paste("NO"[2]," (ppb)"))) +
  ylab("Hazard Ratio") +
  ylim(0.8,2) +
  xlim(3.4,75)
dev.off()

subgroup = "ozone"
load(paste0("~/Dropbox/National_Causal/HEI_final/smoothed_",subgroup,"_unadjusted.RData"))
DR <-as.data.frame(cbind(band=rep("DR",length(a.vals)),a.vals,dose_matching.response.smooth),stringsAsFactors = F)
DR_nosmooth <-as.data.frame(cbind(band=rep("DR",length(a.vals.nosmooth)),a.vals.nosmooth,dose_matching.response.nonsmooth),stringsAsFactors =F)

f <- list.files(paste0("~/Dropbox/National_Causal/HEI_final/Boots/Boots_",subgroup,"_unadjusted"),
                pattern = "\\.RData",
                full.names = TRUE)

DR_response.smooth_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(dose_matching.response.smooth)
}))


DR_a.vals_boots <- do.call(rbind,lapply(f,function(path){
  load(path);
  return(a.vals)
}))

DR_sd <- sapply(1:100, function(i){
  sd(DR_response.smooth_boots[,i],na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})

DR$a.vals <-as.numeric(DR$a.vals)
DR$dose_matching.response.smooth <-as.numeric(DR$dose_matching.response.smooth)

DR_HR_sd <- sapply(1:100, function(i){
  sd((log(DR_response.smooth_boots[,i])-log(DR$dose_matching.response.smooth[1])),na.rm = T)*sqrt(2*31337^{2/3})/sqrt(31337)
})
DR_HR <- exp(log(DR$dose_matching.response.smooth)-log(DR$dose_matching.response.smooth[1]))

pdf("ozone_unadjusted.pdf", width = 11, height = 8.5)
ggplot(data=DR, aes(x=a.vals, y=dose_matching.response.smooth)) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR) ,color="red", lwd=1.2) +
  geom_ribbon(aes(x= DR_a.vals_boots[1,], ymin= (DR_HR-1.96*DR_HR_sd),ymax=(DR_HR+1.96*DR_HR_sd),fill="red"),alpha=0.1, show.legend = F, colour = NA) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR+1.96*DR_HR_sd),linetype="dashed" ,color="red", lwd=1.2) +
  geom_line(aes(x= DR_a.vals_boots[1,], y= DR_HR-1.96*DR_HR_sd),linetype="dashed" ,color="red" , lwd=1.2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = c(0.7, 0.2),
        axis.text = element_text(size=10 * 2),
        axis.title = element_text(size = 12 * 2)) +  
  xlab(expression(paste("Ozone"," (ppb)"))) +
  ylab("Hazard Ratio") +
  ylim(0.8,1.22) +
  xlim(29.5,51)
dev.off()


