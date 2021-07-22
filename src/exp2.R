## set ahead of the experiments
## working directory
srcpath = "~/src" # load functions
#srcpath1 = paste(srcpath, "/HHJMs-l/R", sep='') # load the R files
ncpus = 8 # of CPUs used for parallel computing

## load the R packages for the experiment
setwd(srcpath)
source("load_packages.R")

## create the experiment --------------------------------------------
#HHJMs_tmp = makeExperimentRegistry("HHJMs_simul0721", packages = "HHJMs", seed = 20070943)
#HHJMs_tmp$cluster.functions = makeClusterFunctionsMulticore(ncpus = ncpus)
#getDefaultRegistry()
loadRegistry(file.dir="HHJMs_simul0721", writeable = TRUE)

##add experiments
removeExperiments(ids=1:9)
addProblem(name = "generate_data", data = NULL, fun = data_generator) # generate data
addAlgorithm(name = "fit_JMest", fun = JM_estimator) # fit the JM models

## add the experiment --------------------------------------------------------------
addExperiments(problem_designs, algo_designs, repls = 300L , combine = 'crossprod') # of replicates = 500
#getJobPas(reg = HHJMs_tmp)
summarizeExperiments()
#summarizeExperiments(reg = HHJMs_tmp, by = c('problem', 'algorithm'))

## submit the experiment -------
getStatus()
submitJobs()
getStatus()



## find errors ----------------
#getErrorMessages()
findErrors()$job.id
#getJobPars(ids = 1)$prob.pars

#addJobTags(findErrors()$job.id, 'fail')
#addJobTags(getJobPars()$job.id[-findErrors()$job.id], 'success')
#getJobTags()




