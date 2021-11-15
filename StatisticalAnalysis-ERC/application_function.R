matching.fun.dose.l1.caliper <- function(dataset,
                                          e_gps_pred,
                                          e_gps_std_pred,
                                          a,
                                          w_resid,
                                          delta_n=1,
                                          scale)
{
  ## cosmetic changes only
  #dataset[["treat"]] <- dataset[["pm25_ensemble"]]
  #p.a <- dnorm(a,mean = predict(GPS_mod,simulated.data),sd=summary(GPS_mod)[["sigma"]])
  w_new <- (a-e_gps_pred)/e_gps_std_pred
  p.a <- approx(density(w_resid,na.rm = TRUE)$x,density(w_resid,na.rm = TRUE)$y,xout=w_new,rule=2)$y
  
  #p.a <- dnorm(a,mean = predict(GPS_mod2,data.matrix(simulated.data[,c(5:14,19:20)])),
  #      sd=sd(simulated.data$pm25_ensemble-predict(GPS_mod2,data.matrix(simulated.data[,c(5:14,19:20)]))))
  
  ## calculate min and max once, cache result
  treat.min <- min(dataset[["treat"]],na.rm=T)
  treat.max <- max(dataset[["treat"]],na.rm=T)
  GPS.min <- min(dataset[["GPS"]],na.rm=T)
  GPS.max <- max(dataset[["GPS"]],na.rm=T)
  ## using transform instead of $ is mostly cosmetic
## using transform instead of $ is mostly cosmetic
  dataset <- transform(dataset,
                              std.treat = (treat - treat.min) / (treat.max - treat.min),
                              std.GPS = (GPS - GPS.min) / (GPS.max - GPS.min))
  std.a <- (a - treat.min) / (treat.max - treat.min)
  std.p.a <- (p.a - GPS.min) / (GPS.max - GPS.min)
  ## this subsetting doesn't depend on i, and therefore doesn't need to be done on each iteration
  dataset.subset <- dataset[abs(dataset[["treat"]] - a) <= (delta_n/2), ]
  ## doing the subtraction with `outer` is faster than looping over with sapply or parSapply
  wm <- apply(abs(outer(dataset.subset[["std.GPS"]], std.p.a, `-`)) * scale,
              2,
              function(x) which.min(abs(dataset.subset[["std.treat"]] - std.a) * (1 - scale) + x)
  )
  dp <- dataset.subset[wm,]
  #E.a <- apply(dp, 2, sum, na.rm = T)
  return(dp)
  gc()
}

matching.fun.dose.l1.caliper_xgb <- function(dataset,
                                             a,
					     e_gps_pred,
                                             e_gps_std_pred,
                                             delta_n=1,
                                             scale)
{
  ## cosmetic changes only
  p.a <- dnorm(a, mean = e_gps_pred, sd=e_gps_std_pred)
  
  ## calculate min and max once, cache result
  treat.min <- min(dataset[["treat"]],na.rm=T)
  treat.max <- max(dataset[["treat"]],na.rm=T)
  GPS.min <- min(dataset[["GPS"]],na.rm=T)
  GPS.max <- max(dataset[["GPS"]],na.rm=T)
  ## using transform instead of $ is mostly cosmetic
  dataset <- transform(dataset,
                       std.treat = (treat - treat.min) / (treat.max - treat.min),
                       std.GPS = (GPS - GPS.min) / (GPS.max - GPS.min))
  std.a <- (a - treat.min) / (treat.max - treat.min)
  std.p.a <- (p.a - GPS.min) / (GPS.max - GPS.min)
  ## this subsetting doesn't depend on i, and therefore doesn't need to be done on each iteration
  dataset.subset <- dataset[abs(dataset[["treat"]] - a) <= (delta_n/2), ]
  ## doing the subtraction with `outer` is faster than looping over with sapply or parSapply
 # wm <- apply(abs(outer(dataset.subset[["std.GPS"]], std.p.a, `-`)) * scale,
 #             2,
 #             function(x) which.min(abs(dataset.subset[["std.treat"]] - std.a) * (1 - scale) + x)
 # )
  wm <- sapply(1:length(std.p.a),function(iter){
    return(apply(abs(outer(dataset.subset[["std.GPS"]], std.p.a[iter], `-`)) * scale,
                 2,
                 function(x) which.min(abs(dataset.subset[["std.treat"]] - std.a) * (1 - scale) + x))
    )
  })
  dp <- dataset.subset[wm,]
  return(dp)
  gc()
}

matching_smooth<-function(pseudo.out=dose.response.mean,
                          a,
                          bw.seq=seq(1,1,length.out=10),
                          a.vals){
  kern <- function(t){ dnorm(t) }
  w.fn <- function(bw){ w.avals <- NULL; for (a.val in a.vals){
    a.std <- (a-a.val)/bw; kern.std <- kern(a.std)/bw
    w.avals <- c(w.avals, mean(a.std^2*kern.std)*(kern(0)/bw) /
                   (mean(kern.std)*mean(a.std^2*kern.std)-mean(a.std*kern.std)^2))
  }; return(w.avals/length(a)) }
  hatvals <- function(bw){ approx(a.vals,w.fn(bw),xout=a,rule=2)$y }
  cts.eff.fn <- function(out,bw){
    approx(locpoly(a,out,bandwidth=bw, gridsize=1000),xout=a,rule=2)$y }
  # note: choice of bandwidth range depends on specific problem,
  # make sure to inspect plot of risk as function of bandwidth
  risk.fn <- function(h){ hats <- hatvals(h); mean( ((pseudo.out - cts.eff.fn(pseudo.out,bw=h))/(1-hats))^2) }
  risk.est <- sapply(bw.seq,risk.fn); 
  h.opt <- bw.seq[which.min(risk.est)]
  bw.risk <- data.frame(bw=bw.seq, risk=risk.est)
  
  est <- approx(locpoly(a,pseudo.out,bandwidth=h.opt),xout=a.vals)$y
  return(est)
}

matching_SL<-function(pseudo.out,
                      a,
                      sl.lib=c("SL.xgboost","SL.earth","SL.gam","SL.ranger"),
                      bw.seq=seq(1,1,length.out=10),
                      a.vals){

    data_set<-data.frame(cbind(treat=a))

    matching_model<-SuperLearner(Y=pseudo.out, X= data_set, SL.library=sl.lib)
    data.a <-  data.frame(cbind(treat=a.vals))
    E.a<-predict(matching_model,data.a)[[1]]
    est <- matching_smooth(pseudo.out=E.a,
                    bw.seq= bw.seq,
                    a.vals= a.vals,
                    a=a.vals)


  return(est)
}

