
## joint modeling using h-likelihood

## case 1: with a Cox PH model 
tic()
testjm1 <- try(HHJMs.p::JMfit(glmeObject, survObject1, 
                     long.data, surv.data,
                     idVar="sid", eventTime="obs_time",
                     survFit=fitCOX1,
                     method = "h-likelihood", lower=c(-1,-1)), silent=T)
## re-estimate SDs of parameter estimates by using the adaptive GH method
new_sd1 = HHJMs.p:::JMsd_aGH(testjm1, ghsize = 4, parallel = T)
ptm <- toc()
(ptm$toc-ptm$tic)/60  

## return coefficient table of Fixed effects 
JMsummary(testjm1)
jm1 <- JMsummary(testjm1, newSD=new_sd1)
saveRDS(jm1,'jm1.RDS')

## case 2: with a Weibull model
tic()
testjm2 <- try(HHJMs.p::JMfit(glmeObject, survObject2, 
                     long.data, surv.data,
                     idVar="sid", eventTime="obs_time",
                     survFit=fitCOX2,
                     method = "h-likelihood"), silent=F)
## re-estimate SDs of parameter estimates
new_sd2 = HHJMs.p:::JMsd_aGH(testjm2, ghsize=4, paralle=T)
ptm2 <- toc()
(ptm2$toc-ptm2$tic)/60  
#
JMsummary(testjm2)
jm2 <- JMsummary(testjm2, newSD=new_sd2)
saveRDS(jm2,'jm2.RDS')


## joint modeling using adaptive GH method
## the survival data must be modeled by a Weibull model 
tic()
testjm3 <- try(HHJMs.p::JMfit(glmeObject, survObject2,
                            long.data, surv.data,
                            idVar="sid", eventTime="obs_time",
                            survFit=fitCOX2,
                            method = "aGH", ghsize=3, 
                            parallel=T), silent=T)
ptm3 <- toc()
(ptm3$toc-ptm3$tic)/60  
JMsummary(testjm3)
# super slow!
# much slower than using h-likelihood


jm3 <- JMsummary(testjm3)
saveRDS(jm3,'jm3.RDS')

tic()
testjm4 <- try(HHJMs.p::JMfit(glmeObject, survObject3, 
                     long.data, surv.data,
                     idVar="sid", eventTime="obs_time",
                     survFit=fitCOX3,
                     method = "h-likelihood"), silent=F)
## re-estimate SDs of parameter estimates
new_sd4 = HHJMs.p:::JMsd_aGH(testjm4, ghsize=4, paralle=T)
ptm4 <- toc()
(ptm4$toc-ptm4$tic)/60  
#
JMsummary(testjm4)
jm4 <- JMsummary(testjm4, newSD=new_sd4)
saveRDS(jm4,'jm4.RDS')

## the survival data must be modeled by a LogLogis AFT model 
tic()
testjm5 <- try(HHJMs.p::JMfit(glmeObject, survObject3,
                            long.data, surv.data,
                            idVar="sid", eventTime="obs_time",
                            survFit=fitCOX3,
                            method = "aGH", ghsize=3, 
                            parallel=T), silent=T)
ptm5 <- toc()
(ptm5$toc-ptm5$tic)/60  
jm5 <- JMsummary(testjm5)
saveRDS(jm5,'jm5.RDS')
# super slow!
