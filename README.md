# An Extension of [HHJMs](https://github.com/oliviayu/HHJMs) to some parametric survival models

## Project Overview

This project extends the work on jointly modelling mixed and truncated longitudinal data and survival data by Dr. Tingting Yu, Dr. Lang Wu and Dr. Peter B. Gilbert [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) to a couple of alternative survival models, *Weibull Regression Model* and *Loglogistic Accelarated Failure Time Model*. The project is motivated by higher efficiency of the parametric survival models compared to nonparametric ones when the distributional assumptions hold. 

### Motivation Case - The HIV Vaccine Data

The original study by Yu et al [1](https://academic.oup.com/biostatistics/article/19/3/374/4210131?login=true) is motivated by the VAX004 trial.  The special type of response variables *NAb* is visualized as in Figure 1 below. Figure 1 is from [1].
<img width="1199" alt="Screen Shot 2021-08-04 at 4 44 44 AM" src="https://user-images.githubusercontent.com/70077322/128175220-ff0a1735-f15f-4f65-9542-9a0ec45f9755.png">

### Some Contributions

This work extends the original work by replacing the nonparametric survival model, *Cox proportional hazards model*, by two parametric alternatives, *Weibull Regression Model* and *Loglogistic Accelarated Failure Time Model*, which are more efficient when the distributional assumptions hold.


## Documents in the Github Repository

The folder [*src*](src) contains the modified R package HHJMs.p based on HHJMs developed by Yu, R code for applying the joint models on real data in [*dat*] and also in the R packages. The folder *doc* includes the .tex files of the report.


## The Modified Package - [HHJMs.p](HHJMs-p.tar.gz)

The orignal package [HHJMs](https://github.com/oliviayu/HHJMs) was developed by Yu, Tingting. Here the models used in the package are extended to accepting alternative survival models, i.e., distributional assumptions. 

### Guide to use the package

Users can either clone the repo or solely downlown the package, and install the package locally. For Mac users,

`install.packages("~/HHJMs-p.tar.gz", repos = NULL, type = "source")

library(HHJMs.p)`

If you are interesed in the original package, it can be easily downloaded from the Github repo [HHJMs](https://github.com/oliviayu/HHJMs). Some helpful code is:

`library(devtools)

install_github('oliviayu/HHJMs')`

### Modification on the Original Package

The package is further modified in multiple ways to be more user-friendly; the modifications are listed below.

- Fix the issue that some dependencies are not successully loaded when installing the HHJMs package.

- Fix the issue that users need to source the R files locally when using some functions in the package.

- Fix the numeric issue when summarizing the fitted model.

- Add ellipses into some functions to call arguments in the functions they call.

- Example code is modified by combining repeated code.

## Acknowledgement

I'd like to thank Dr. Lang Wu for his generous help and precious advice.


## Some References

[1] Yu T, Wu L, Gilbert PB. A joint model for mixed and truncated longitudinal data and survival data, with application to HIV vaccine studies. Biostatistics. 2018 Jul 1;19(3):374-90.

[2] Lee Y, Nelder JA, Pawitan Y. Generalized linear models with random effects: unified analysis via H-likelihood. CRC Press; 2018 Jul 11.
