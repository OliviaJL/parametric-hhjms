# Introduction on the Project - An Extension of [HHJMs](https://github.com/oliviayu/HHJMs) to some parametric survival models

## Project Overview

This project extends the work on jointly modelling mixed and truncated longitudinal data and survival data by Tingting Yu, Dr. Lang Wu and Dr. Peter B. Gilbert [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) to a couple of alternative survival models, *Weibull Regression Model* and *Loglogistic Accelarated Failure Time Model*. The project is motivated by higher efficiency of the parametric survival models compared to nonparametric ones when the distributional assumptions hold. 

### Motivation Case - The HIV Vaccine Data

The original study by Tingting et al [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) is motivated by the VAX004 trial. 
......

The special type of response variables... visualized as in Fig.1 below. (add a figure illustrating the longitudinal variables as Fig.1 in the [paper](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) )

### Some Contributions

This work extends the original work by replacing the nonparametric survival model, *Cox proportional hazards model*, by two parametric alternatives, *Weibull Regression Model* and *Loglogistic Accelarated Failure Time Model*, which are more efficient when the distributional assumptions hold.


## Documents in the Github Repository

...


## The Modified Package - [HHJMs.c](HHJMs-l.tar.gz)

The orignal package [HHJMs](https://github.com/oliviayu/HHJMs) was developed by Tingting Yu. Here, the models used in the package are extended to accepting alternative survival models, i.e. distributional assumptions. 

### Guide to use the package

Users can either clone the repo or solely downlown the package, and install the package locally. For Mac users,

`install.packages("~/HHJMs-c.tar.gz", repos = NULL, type = "source")`

If you are interesed in the original package, it can be easily downloaded from the Github repo [HHJMs](https://github.com/oliviayu/HHJMs). Some helpful code is:

`library(devtools)
install_github('oliviayu/HHJMs')`

### Modification on the Original Package

The package is further modified in multiple ways to be more user-friendly; the modifications are listed in the issue-solution pairs below.

- Issue 1: Some dependencies are not successully loaded when installing the HHJMs package.
- Solution: Re-document the package by importing the dependencies in NAMESPACE.

- Issue 2: Users need to source the R file locally when using some functions in the package.
- Solution: Same as for issue 1 with removing the code for sourcing the files.

- Issue 3: Numeric issue when summarizing the fitted model.
- Solution: Use `as.numeric` to transform vectors to be numerical, and assign nonpositive standard errors to be an arbitrarily small scalar.

- Issue 4: Some arguments called by defining a function cannot work.
- Solution: Add ellipses as the last arguments of functions. 


### Troubleshooting

Load the package in the end.
`library(HHJMs.c)`


### Run experiments

Download the *src* foler, and run *exp.R*.

- For the first time, run lines 12-13 in *exp.R* to create an experiment.
- Otherwise, run line 15 to load an existing experiment.

### Remove jobs

- remove problems, algorithms or experiments by lines 35-37 in *exp.R*.

E.g., remove experiments with specific ids 1:3 by 
`removeExperiments(ids=1:3)`.

