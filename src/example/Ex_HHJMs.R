## load packages
library(lme4)
library(tictoc)
library(survival)
# Dependencies for the function estFixeff
library(Deriv) #Simplify
library(matrixcalc) #matrix.trace
# dependencies for JMfit_HL
library(MASS) #ginv
# for JMfit (in joint model 3)
library(ecoreg) #gauss.hermite
# for JMsd_aGH (get_aGH_sd2)
library(parallel) #detectCores
library(doParallel) # registerDoParallel
library(foreach)
library(tgp)
library(HHJMs.p)

## read the data
srcpath='~/'
setwd(srcpath)
long.data <- read.csv("Longdata.csv")
surv.data <- read.csv("Survdata.csv")

## fit the separate models using two-step method to get the start value

## Model 1: a LME model of Y 
fm1 <- y ~ 1 + year + year2 + sindoes + (1|sid)
md1 <- lmer(fm1, data = long.data)
estBi <- data.frame(row.names(ranef(md1)$sid), scale(ranef(md1)$sid, center=T, scale=T)) # get the estimated random effect by observation
names(estBi) <- c("sid", "estb11")
mydat <- merge(long.data, estBi, by='sid', all=T)

## Model 2: a GLME model of C
fm2 <- c ~ 1 + year + year2 + sindoes + estb11 # using the estimated random intercept from model 1 (i.e. estb11, scaled) as a covariate
md2 <- glm(fm2, family = binomial, data = mydat)

## Model 3: a GLME model of Z
fm3 <- z ~ 1+month+sindoes+doesW+estb11+(month-1|sid) # using the estimated random intercept from model 1 (i.e. estb11, scaled) as a covariate
md3 <- glmer(fm3, family="binomial", data=mydat)

## Model 4: a survival model
Sdata <- surv.data
Sdata$estb11 <- scale(ranef(md1)$sid[,1], center=T, scale=T)
Sdata$estb21 <- scale(ranef(md3)$sid[,1], center=T, scale=T)
## using the estimated random intercept from model 1 (i.e. estb11, scaled) 
## and the estimate random slope from model 3 (i.e. estb21, scaled) as covariates.

## a Cox PH model
fitCOX1 <- coxph(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata)   
## a Weibull model
fitCOX2 <- survreg(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata, dist = 'weibull')
## a Log-logistic AFT model
fitCOX3 <- survreg(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata, dist = 'loglogistic')

## Create objects for joint modeling

## for longitudinal models
LLOQ = 2 # lower limit of quantification of Y
CenObject <- list(
  fm= c ~ 1  + year +year2 +sindoes + b11,
  family='binomial', par='eta', ran.par="b11",
  disp="eta4",
  lower= -Inf, upper=Inf,
  str_val=coef(md2),
  Cregime=1,
  truncated=T, delim_val=LLOQ)

glmeObject1 <- list(
  fm= y ~ 1 + year + year2 + sindoes + b11,
  family='normal', par="beta", ran.par='b11', sigma='sigma',
  disp='beta4',
  lower=0, upper=Inf,   
  str_val=c(fixef(md1), sd(ranef(md1)$sid[,1])),
  CenObject=CenObject)

glmeObject2 <- list(
  fm= z ~ 1 + month + sindoes +doesW + b11 + month * b21,
  family='binomial', par="alpha", ran.par=c('b11','b21'),
  sigma=NULL, 
  disp=c("alpha4", 'alpha5'),
  lower=c(-Inf,0),
  upper=rep(Inf,2),
  str_val=c(fixef(md3), sd(ranef(md3)$sid[,1])),
  CenObject=NULL)

glmeObject <- list(glmeObject1, glmeObject2)

## for survival model
## case 1: if a Cox PH model is fit for survival data
survObject1 <- list(
  fm= obs_time ~ base+b11+b21,
  event="event", 
  par='lambda',
  disp=NULL,
  lower=NULL, upper=NULL,
  distribution=NULL,
  str_val= summary(fitCOX1)$coeff[,1])

## case 2: if a Weibull model is fit for survival data
survObject2 <- list(
  fm= obs_time ~ base+b11+b21,
  event="event", 
  par='lambda',
  disp=NULL,
  lower=NULL, upper=NULL,
  distribution='weibull',
  str_val= -summary(fitCOX2)$coeff[-1]/summary(fitCOX2)$scale)

## case 3: log-logistic model
survObject3 <- list(
  fm= obs_time ~ base+b11+b21,
  event="event", 
  par='lambda',
  disp=NULL,
  lower=NULL, upper=NULL,
  distribution='loglogistic',
  str_val= - summary(fitCOX3)$coeff[-1]/summary(fitCOX3)$scale) 

