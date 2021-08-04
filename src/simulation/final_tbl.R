# ----------
srcpath='/Users/olivialiu/Library/Mobile Documents/com~apple~CloudDocs/Downloads/parametric-hhjms-main-3/src/HHJMs_simul0721-2/results'
setwd(srcpath)

file_list = list.files()
file_name = as.numeric(substr(file_list, 1,3))

convr <- numeric(length(file_name))
for(i in file_name){
  convr[i-300] <- readRDS(glue::glue('{i}.RDS'))$testjm$conv
}
sum(is.na(convr))
length(which(convr==0))
which(is.na(convr))+300

for(i in file_name){
    jmsum2 <- readRDS(glue::glue('{i}.RDS'))$sum_jm + jmsum2
}
jmsum2 = jmsum2/298

# ------------
srcpath2 = '/Users/olivialiu/Documents/UBC/21Sum_RA/simul_for_three_models/src/src-final/HHJMs_simul0721/results'
setwd(srcpath2)

file_list2 = list.files()
file_name2 = parse_number(file_list2)

convr2 <- numeric(length(file_name2))
for(i in file_name2){
  convr2[i] <- readRDS(glue::glue('{i}.RDS'))$testjm$conv
}
sum(is.na(convr2))
length(which(convr2==0))


jmsum1 = matrix(rep(0,17*4),nrow=17,ncol=4)
jmsum2 = matrix(rep(0,15*4),nrow=15,ncol=4)
for(i in file_name2){
  if (i  <= 300) {
    jmsum1 <- readRDS(glue::glue('{i}.RDS'))$sum_jm + jmsum1
  } else {
    jmsum2 <- readRDS(glue::glue('{i}.RDS'))$sum_jm + jmsum2
  }
}
jmsum1 = jmsum1/300
jmsum2 = jmsum2/300


beta = c(2, 1, -.3, 1.5)
alpha = c(-1.65, .15, 1.8, -.05)
gamma = c(-.75, -1.5, -2)
true_para <- c(beta, rep(0,4), alpha, gamma)

jmsum11 <- cbind(as.data.frame(true_para), jmsum1[1:15,])
jmsum22 <- cbind(as.data.frame(true_para), jmsum2[1:15,])

xtable(jmsum11,digit=3)
xtable(jmsum22,digit=3)


# ---
library(tidyverse)
# application
srcpath='/Users/olivialiu/Documents/UBC/21Sum_RA/simul_for_three_models/src/results-HHJMs_p'
setwd(srcpath)
jm1 = readRDS('jm1.RDS')
jm2 = readRDS('jm2.RDS')
jm3 = readRDS('jm3.RDS')

library(xtable)
xtable(cbind(jm1[1:15,-3],jm2[1:15,-3],jm3[1:15,-3]))


