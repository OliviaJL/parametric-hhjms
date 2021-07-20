# 21-summer-project

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
