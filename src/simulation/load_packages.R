## only for the first time use
#install.packages('Rlab')
#install.packages('lme4')
#install.packages('survival')
#install.packages('tidyverse')
#install.packages('eha')
#install.packages('batchtools')

## install the R package for the JM model locally
#install.packages('', repos=NULL)

## load R pacakges
library(lme4)
library(survival)
library(Rlab) # rbern
#library(eha) # rllogis
library(data.table)
library(tidyverse)
library(batchtools)

## load the R package for the JM model
## load its dependencies
library(Deriv)
library(matrixcalc)
library(lbfgs)
library(parallel)
library(foreach)
library(doParallel)
library(MASS)
library(ecoreg)

library(HHJMs.p)

