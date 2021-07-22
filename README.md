# Introduction to the project

This project extends the work on jointly modelling mixed and truncated longitudinal data and survival data by Tingting Yu, Dr. Lang Wu and Dr. Peter B. Gilbert [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) to a couple of alternative survival models, *Weibull Regression Model* and *Loglogistic Accelarated Failure Time Model*. The work is motivated by higher efficiency of the parametric survival models compared to nonparametric ones when the distributional assumptions hold. 

## Motivation Case: The HIV Vaccine Data

The original study by Tingting et al [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) is motivated by the VAX004 trial. 
......

The special type of response variables... visualized as in Fig.1 below.





# Guide to the implementation

Guide to use the modified version of Tingting Yu's package and conduct simulation

## Update R package

remove old versions:
`
remove.packages('HHJms')
`

install new versions:
`install.packages("~/HHJMs-c.tar.gz", repos = NULL, type = "source")`

## Run experiments

Download the *src* foler, and run *exp.R*.

- For the first time, run lines 12-13 in *exp.R* to create an experiment.
- Otherwise, run line 15 to load an existing experiment.

## Remove jobs

- remove problems, algorithms or experiments by lines 35-37 in *exp.R*.

E.g., remove experiments with specific ids 1:3 by 
`removeExperiments(ids=1:3)`.

