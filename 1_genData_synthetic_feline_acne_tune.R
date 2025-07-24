# this code tunes the genData algorithm from:
# Ruscio J, Kaczetow W. Simulating Multivariate Nonnormal Data Using an Iterative Algorithm. Multivariate Behavioral Research. 2008;43:355–381


#courtesy of MSG


rm(list=ls())
library(dagitty)
library(tidyverse)
# source the file with functions used in the project, includes DAG definitions:
# dag - dag definition
# functions: GenData, Factor.Analysis, reorder_mat, get_prevalence
source('0_supporting_functions.r')



Ndags     <- 1                      # number of DAGs if we are testing mulltiple models
Nobs      <- 100000                 # study sample size
Nreps     <- 1000                   # number of bootstrap simulations/replications

VarNames  <- c("indoor","stress","true acne",
               "scenting","comedones","alopecia","skin infections",
               "chin/lip","experienced owner","consultation",
               "experienced examiner","acne diagnosis","Ni")      # variables to be simulated and their order

Nvar      <- length(VarNames)
Prev      <- c(0.261 ,0.25 ,0.05 ,
               0.25  ,0.03 ,0.01 ,0.02,
               0.03  ,0.34 ,0.217,
               0.0028)                                            # prevalence of observations
num_lat_f <- 9

Optimise_N.Factors <- function (dag, Nobs, Nreps, Prev) 
{     
  # routine to explore optimal number of N.Factors to minimise bias and optimise speed
  Eval    <- Opt <- NULL
  Cor     <- reorder_mat(round(cor(simulateSEM(dag, b.default = 0, N = Nobs, empirical = TRUE)),3), VarNames)
  Target  <- Cor[lower.tri(Cor)]
  
  for (nF in 1:num_lat_f) 
  {
    print(paste0("Factor ", nF))
    Start <- Sys.time()
    Miss  <- NULL
    for (itn in 1:Nreps) 
    {
      seed          <- 17*Nreps*itn
      MyData        <- data.frame(GenData(N = Nobs, k = Nvar, Prev = Prev, Data.Cor = Cor,
                                          seed = seed, N.Factors=nF, Max.Trials=5, Initial.Multiplier=0.5))
      names(MyData) <- VarNames
      MyData        <- tibble(MyData)
      MyCor         <- cor(MyData)
      Shot          <- MyCor[lower.tri(MyCor)]
      Miss          <- c(Miss, sqrt(sum((Target - Shot)^2)))
    }
    
    Time  <- Sys.time() - Start; print(Time)
    Opt   <- rbind(Opt, data.frame(nF = nF, Bias = median(Miss), Spread = 2*sd(Miss), Time = Time)) 
  }
  
  return(Opt) 
} 
# end routine to explore optimal number of N.Factors to minimise bias and optimise speed


OptN     <- Nreps/2                                                           # number of repeat simulations for optimisation
FileName <- paste0(Sys.Date()," Optimisation_",OptN,".csv")                   # date & label the save file
Opt      <- list()                                                            # summary of optimisation findings

for (itn in 1:Ndags) 
{
  print(paste0("DAG configuration ", itn))                                    # signpost progress
  Opt[[itn]] <- Optimise_N.Factors(dag, Nobs, OptN, Prev)                     # optimise the factor numbers & save to disk 
}

write.table(do.call(rbind, Opt), file = FileName, sep = ",", row.names = FALSE) 

