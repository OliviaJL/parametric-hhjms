The R code for simulation study of semi-parametric joint model using Cox proportional models and parametric joint model using Weibull regression
models are here. 

The simulation uses the R package *batchtools* to design the experiments. The main experiment is created in [*exp.R*](exp.R). It sources all the other R files. Data generation process are defined [here](generate_data.R), and the models are defined [here](design_model.R). All the R packages used in the experiment are included [here](load_packages.R).
