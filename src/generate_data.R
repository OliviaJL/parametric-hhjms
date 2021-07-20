## setting of data -------------
problem_designs <- list(
  generate_data = data.table::CJ(
    N0 = 100L, # of subjects # c(50L, 100L)
    LLOQ = 2L, #c(2, 4),
    #JJ = c(10L, 20L) # of measurements
    disper = .3, #.3
    true_dist = 'weibull'#c('weibull', 'loglogistic')
  )
)


## generate data -----------------------
data_generator <- function(data = NULL, job, N0 = 100L, LLOQ = 2, disper = .5, 
                           true_dist = c('weibull', 'loglogistic'), ...) {
  
  true_dist = match.arg(true_dist)
  
  long.data0 = c()
  surv.data0 = c()
  
  ## set true parameters and create covariates --------------
  ## fixed effects
  beta = c(2, 1, -.3, 1.5)
  alpha = c(-1.65, .15, 1.8, -.05, .4)
  gamma = c(-.75, -1.5, -2)
  ## dispersion
  sigma = .75
  R = array(c(2, disper, disper, 1), c(2, 2))
  ## scale
  d1 = .5
  d2 = .15
  ## null hazard
  h0 = 800
  ## random effects
  set.seed(1119)
  b = MASS::mvrnorm(n = N0, mu = rep(0,2), Sigma = R) # dim=c(N,2)
  ## months of injection
  jj = c(0,1,6,12,18,24,30,36)
  injectionNO = c()
  for(j in 1:length(jj[-1])){
    injectionNO = c(injectionNO, rep(j, 2*(jj[j+1]-jj[j])))
  }
  ## of time points: fixed for all data
  J = length(injectionNO)
  sid = rep(1:N0, each=J) # subjects' ID
  time_o = seq.int(from = 1, by = 14, length.out = J)
  t_max = 1+14*(J-1) #995
  doest = c() # T_d
  for(j in 1:length(jj[-1])){
    doest = c(doest, seq.int(from=1,by=14,length.out=length(injectionNO[injectionNO==j])))
  }
  perd <- c()
  for(j in 1:length(jj[-1])){
    ll = length(injectionNO[injectionNO == j])
    perd = c(perd, rep(ll * 14, length.out = ll))
  }
  doest = rep(doest, N0)
  perd = rep(perd, N0)
  sindoes = sin(pi*doest / perd)
  doesW = doest/7
  
  ## create base covariate ----------------------------------------------------------------
  eps = rnorm(N0 * J, mean = 0, sd = sigma)# noise ~ N(0,sigma)
  X = rnorm(N0) # X ~ N(0,1), time-independent variable
  base = rep(X, each=J)
  
  ## create event time and observed time variables
  if (true_dist == 'weibull')  {
    event_time = rweibull(N0, 15, scale = h0 * (exp(gamma[1] * X + b %*% gamma[-1]))^(-1/15))
  } else if (true_dist ==  'loglogistic') {
    event_time = eha::rllogis(N0, 15, scale = h0 * (exp(gamma[1] * X + b %*% gamma[-1]))^(-1/15))
  } 
  
  event = ifelse(event_time > t_max, 0, 1)
  cc_s = rweibull(N0, 5, 1000) # C
  obs_time = round(apply(cbind(event_time, cc_s), 1, min), 0)
  time = c()
  for(i in 1:N0){
    time_o[time_o > event_time[i]] = -1
    time = c(time, time_o)
  }
  month = time/28
  month2 = month^2
  year = time/365
  year2 = year^2
    
  ## survival data: combine variables
  surv.data0 = as.data.frame(cbind(sid = unique(sid), event_time, event, obs_time, base = X))
  
  ## ctn, longitudinal response
  y = beta[1] + beta[2] * year + beta[3] * year2 + beta[4] * sindoes + unlist(b[, 1]) * d1 + eps
  c = y
  c = ifelse(c > LLOQ, 0, 1)
  
  ## discrete, longitudinal response
  z = c()
  for(i in 1:N0){
    xi_z = alpha[1] + alpha[2] * time[sid == i] + alpha[3] * sindoes[sid == i] + alpha[4] * doesW[sid == i] + alpha[5] * b[i, 1] + d2 * b[i, 2] * time[sid == i] 
    p_z = exp(xi_z) / (1 + exp(xi_z))
    z_o = rbern(J, prob = p_z)
    z = c(z, z_o)
  }
    
  long.data0 = as.data.frame(cbind(sid, time, injectionNO, doest, perd, base, sindoes, doesW, year, year2, month, month2, z, y, c))
  long.data0 = long.data0[long.data0$time != -1,]
  
  ## return data sets ----------------------------------------------
  return(list(long_data = long.data0, surv_data = surv.data0, LLOQ = LLOQ)) 
}

