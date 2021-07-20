algo_designs <- list( # both tf_versions, all other params the same
  fit_JMest = data.table(
    distribution = c('No_distribution','weibull','loglogistic','weibull', 'loglogistic'), #, 'weibull', 'loglogistic'),
    method = c('h-likelihood', 'h-likelihood', 'h-likelihood', 'aGH', 'aGH'),
    itertol = 1e-3,
    iterMax = 10L
  )
)


## get initial values of model parameters ----------------
pre_estimator <- function(data, job, instance, distribution, ...){
  
  LLOQ = instance$LLOQ
  long_data = instance$long_data
  
  ## get initial values ------------------------
  ## LME models
  ## Model 1: a LME model of Y 
  fm1 = y ~ 1 + year + year2 + sindoes + (1|sid)
  md1 <- lmer(fm1, data = long_data)
  estBi = data.frame(row.names(ranef(md1)$sid), scale(ranef(md1)$sid, center = T, scale = T)) # get the estimated random effect by observation
  names(estBi) = c("sid", "estb11")
  mydat = merge(long_data, estBi, by = 'sid', all = T)
  
  ## Model 2: a GLME model of C
  fm2 = c ~ 1 + year + year2 + sindoes + estb11
  md2 <- glm(fm2, family = binomial, data = mydat)
  print('get initial values for LME & GLM models --- done.')
  
  fm3 = z ~ 1 + month + sindoes + doesW + estb11 + (month - 1 | sid)
  defaultW = getOption('warn')
  options(warn = -1)
  md3 = glmer(fm3, family = "binomial", data = mydat)
  options(warn = defaultW)
  print("get initial values for GLME model --- done.")
  
  ## get model objects --------------------------
  ## longitudinal models -----
  CenObject <- list(
    fm = c ~ 1 + year +year2 +sindoes + b11,
    family = 'binomial', par = 'eta', ran.par = "b11",
    disp = "eta4",
    lower = -Inf, upper = Inf,
    str_val = coef(md2),
    Cregime = 1,
    truncated = T, delim_val = LLOQ)
  
  glmeObject1 <- list(
    fm = y ~ 1 + year + year2 + sindoes + b11,
    family = 'normal', par = "beta", ran.par = 'b11', sigma = 'sigma',
    disp = 'beta4',
    lower = 0, upper = Inf,   
    str_val = c(fixef(md1), sd(ranef(md1)$sid[,1])),
    CenObject = CenObject)

  glmeObject2 <- list(
    fm = z ~ 1 + month + sindoes +doesW + b11 + month*b21,
    family = 'binomial', par = "alpha", ran.par = c('b11','b21'),
    sigma = NULL, 
    disp = c("alpha4", 'alpha5'),
    lower = c(-Inf,0),
    upper = rep(Inf,2),
    str_val = c(fixef(md3), sd(ranef(md3)$sid[,1])),
    CenObject = NULL)
  
  glmeObject = c()
  glmeObject = list(glmeObject1, glmeObject2)
  
  ## survival models --------
  datt <- instance$surv_data
  datt$estb11 <- scale(ranef(md1)$sid[,1], center = T, scale = T)
  datt$estb21 <- scale(ranef(md3)$sid[,1], center = T, scale = T)
  # using the estimated random intercept from model 1 (i.e. estb11, scaled) 
  # and the estimate random slope from model 3 (i.e. estb21, scaled) as covariates.
  Sdata <- datt
  
  if (distribution == 'No_distribution'){
    # a Cox PH
    survFit <- coxph(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata)
    print("get initial values for survival models --- done.")
    ## case 1: if a Cox PH model is fit for survival data
    survObject = list(
      fm = obs_time ~ base+b11+b21,
      event = "event", 
      par = 'lambda',
      disp = NULL,
      lower = NULL, upper = NULL,
      distribution = NULL,
      str_val = summary(survFit)$coeff[,1]
    )
  } else if (distribution == 'weibull'){
    # a Weibull AFT model
    survFit <- survreg(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata, dist = 'weibull')
    print("get initial values for survival models --- done.")
    ## case 2: if a Weibull model is fit for survival data
    survObject = list(
      fm = obs_time ~ base+b11+b21,
      event = "event", 
      par = 'lambda',
      disp = NULL,
      lower = NULL, upper = NULL,
      distribution = 'weibull',
      str_val = -summary(survFit)$coeff[-1] / summary(survFit)$scale
    )
  } else if (distribution == 'loglogistic'){
    # a log-logistic AFT model
    survFit <- survreg(Surv(obs_time, event) ~ base + estb11 + estb21, data = Sdata, dist = 'loglogistic')
    print("get initial values for survival models --- done.")
    ## case 3: a loglogistic AFT model for survival data
    survObject = list(
      fm = obs_time ~ base+b11+b21,
      event = "event", 
      par = 'lambda',
      disp = NULL,
      lower = NULL, upper = NULL,
      distribution = 'loglogistic',
      str_val = -summary(survFit)$coeff[-1] / summary(survFit)$scale
    )
  }
  
  ## return -------------------------------------------------------------------------------------
  return(list(survFit = survFit, glmeObject = glmeObject, survObject = survObject))
}

JM_summary <- function(testjm, newSD = FALSE, digits = 3){
  est = testjm$fixedest
  if (newSD == FALSE){
    Sd = as.numeric(testjm$fixedsd)
  } else if (newSD == TRUE) {
    Sd = as.numeric(testjm$new_sd)
  }
  for(i in 1:length(Sd)){Sd[i] = ifelse(Sd[i] <= 0, 1e-5, Sd[i])}
  
  Zvalue = testjm$fixedest / Sd
  Pvalue = (1 - pnorm(abs(Zvalue), 0, 1))*2
  Coeff = data.table(Estimate = est, Std_Error = Sd, Zvalue, Pvalue)
  Coeff = as.data.frame(Coeff)
  rownames(Coeff) = names(testjm$fixedest)
  
  return(Coeff = round(Coeff, digits = digits))
}

## fit the HHJMs models -----------------------------------------------------------
JM_estimator <- function(data, job, instance, method = c('h-likelihood', 'aGH'), 
                         distribution = c('No_distribution', 'weibull', 'loglogistic'), ...){
  
  method = match.arg(method)
  distribution = match.arg(distribution)
  
  long_data = instance$long_data
  surv_data = instance$surv_data
  
  pre_est = pre_estimator(data, job, instance, distribution)
  glmeObject = pre_est$glmeObject
  survObject = pre_est$survObject
  survFit = pre_est$survFit
  
  if (method == 'h-likelihood'){
      testjm <- JMfit(glmeObject, survObject, long_data, surv_data, idVar ="sid", eventTime = "obs_time", 
                      survFit, method=method)
      ## re-estimate SDs of parameter estimates by using the adaptive GH method
      new_sd = HHJMs:::JMsd_aGH(testjm, ghsize = 4, parallel = F)
      testjm$new_sd = new_sd
      sum_jm = JM_summary(testjm, newSD = TRUE)
      
  } else if (method == 'aGH') { 
      ## case 3: joint modeling using adaptive GH method
      ## the survival data must be modeled by a Weibull model 
      testjm <- JMfit(glmeObject, survObject, long_data, surv_data, idVar = "sid", eventTime = "obs_time", 
                      survFit, method=method, ghsize = 3, parallel = F, ...)
      sum_jm = JM_summary(testjm)
    } 
  
  return(list(testjm = testjm, sum_jm = sum_jm))
  
}


