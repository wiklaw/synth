# alternative data generation technique from Ruscio and Kaczetow
# code by MSG


rm(list=ls())
library(dagitty)
library(tidyverse)
library(lme4)
# source the file with functions used in the project, includes DAG definitions: dag 
# dag definition functions: GenData, Factor.Analysis, reorder_mat, get_prevalence
source('0_supporting_functions.r')


N      <- 100000                                                     # study sample size
Nreps  <- 100                                                        # number of replications

VarNames  <- c("indoor","stress","true acne",
               "scenting","comedones","alopecia","skin infections",
               "chin/lip","experienced owner","consultation",
               "experienced examiner","acne diagnosis","Ni")            # variables to be simulated and their order

Nvar      <- length(VarNames)
Prev      <- c(0.261 ,0.25 ,0.05 ,
               0.25  ,0.03 ,0.01 ,0.02,
               0.03  ,0.34 ,0.217,
               0.0028)                                                  # prevalence of observations
num_lat_f <- 8
#output_foldername <- paste0('gendata',num_lat_f)
# for the weaker dag we used 
 output_foldername <- paste0('gendata',num_lat_f,'_weaker_dag')
# create folder for output if it doesn't exist
if (!dir.exists(file.path(getwd(), output_foldername)))
{
  dir.create(file.path(getwd(), output_foldername))
}

# for creating cluster
C <- 50                                                                 # number of clusters
sdev_examiners <- 0.9
mean_examiners <- 1.2
if (floor(N/C)!=ceiling(N/C)) print('Make sure N/C is an integer!')
#-----------------------------------------------------------------------------------

Cor       <- reorder_mat(round(cor(simulateSEM(dag, b.default = 0, N = N, empirical = TRUE)),3), VarNames)

for (i in 1:Nreps)
{
  print(paste0("dataset ", i))
  Start <- Sys.time()
  
  seed          <- 17*Nreps*i
  MyData        <- data.frame(GenData(N = N, k = Nvar, Prev = Prev, Data.Cor = Cor,
                                      seed = seed, N.Factors=num_lat_f, Max.Trials=5, Initial.Multiplier=1))
  names(MyData) <- VarNames
  #----------------------------------------------------
  #--------------------------------------create cluster
  # 1. ascending
  Nhat <- MyData[order(MyData$Ni),'Ni']
  # 2. rescaled, mean and sdev set above
  Nhat <- Nhat*sdev_examiners + mean_examiners 
  # exponentiate to get the lognormal distribution 'back'
  Nhat <- exp(Nhat)
  # 3. divide into C equal size subgroups
  Nhat <- data.frame(Nhat)
  Nhat$subgroup <- rep(1:C, each=floor(N/C))
  # 4. select 1 value and round to int (any non-positive?), 100 numbers of cluster size -> Njhat
  select_rows <- runif(C)*N/C
  # add a vector of 1, 2001, 4001,...
  select_rows <- select_rows + seq(1,length.out = length(select_rows), by=N/C)
  select_rows <- round(select_rows,0)
  Njhat <- Nhat[select_rows,]
  Njhat$Nhat <- round(Njhat$Nhat,0)
  # 5. make Njhat sum to the population size by adding +/- 1 randomly -> Nj
  while (N-sum(Njhat$Nhat)!=0)
  {
    sample_rows <- sample(1:nrow(Njhat), size=min(abs(N-sum(Njhat$Nhat)),nrow(Njhat)))
    Njhat[sample_rows, 'Nhat'] <- Njhat[sample_rows, 'Nhat'] + 1*if(N-sum(Njhat$Nhat)<0){-1}else{1}
  }
  Nj <- Njhat$Nhat
  rm(Njhat)
  # 6. divide original Ni into C clusters of size Nj, j=1,2,...,C
  MyData <- MyData[order(MyData$Ni),]
  Nj <- round(Nj/sum(Nj)*N,0)
  # randomly +/-1 if sum(Nj)!=N
  while (N-sum(Nj)!=0)
  {
    sample_rows <- sample(1:length(Nj), size=min(abs(N-sum(Nj)),length(Nj)))
    Nj[sample_rows] <- Nj[sample_rows] + 1*if(N-sum(Nj)<0){-1}else{1}
  }
  MyData$cluster <- rep(1:C,Nj)
  # average by cluster to create examiner's experience
  MyData$'experienced examiner j' <- ave(MyData$'experienced examiner', MyData$cluster, FUN = mean, na.rm = TRUE)
  #-------------------------------end of create cluster
  #----------------------------------------------------
  MyData        <- tibble(MyData)
  
  Time          <- Sys.time() - Start; print(Time)
  
  FileName      <- paste0(output_foldername,'/',Sys.Date()," dataset_",i,".csv")          # date & label the save file
  
  write.csv(MyData, file = FileName, row.names = FALSE) 
}


#run analysis on these datasets and save to folder####
#prevalence

# prevalence for all datasets
output <- data.frame(datasetname = character(0),
                     covariate = character(0),
                     dataset = character(0),
                     percentage1 = numeric(0))

Start <- Sys.time()

for (i in 1:Nreps)
{
  set.seed(13*i)
  #read the file in
  dataset_name <- paste0(output_foldername,'/',Sys.Date()," dataset_",i,".csv")
  mydata       <- read.csv(dataset_name)
  #rename columns
  colnames(mydata) <- c('indoor','stress','true_acne','scenting',
                        'comedones','alopecia','skin_infections','chin_lip',
                        'experienced_owner','consultation','experienced_examiner',
                        'acne_diagnosis','Ni','cluster','experienced_examiner_j')
  
  prevalence <- get_prevalence(mydata)
  output <- rbind(output,
                  data.frame(datasetname = dataset_name, prevalence))
  
}

FileName <- paste0(output_foldername,"/prevalence.csv") 
Time <- Sys.time() - Start; print(Time)
write.csv(output, file = FileName, row.names = FALSE) 



# Three examples discussed in the paper####
#example 1) outcome = consultation

output <- data.frame(datasetname = character(0),
                     modeltype = character(0),
                     coeff_name = character(0),
                     adjusted_for = character(0),
                     Estimate = numeric(0),
                     LeftCI = numeric(0),
                     RightCI = numeric(0))

Start <- Sys.time()

for (i in 1:Nreps)
{
  set.seed(13*i)
  #read gendata file in
  dataset_name <- paste0(output_foldername,'/',Sys.Date()," dataset_",i,".csv")
  mydata       <- read.csv(dataset_name)
  #rename columns
  colnames(mydata) <- c('indoor','stress','true_acne','scenting',
                        'comedones','alopecia','skin_infections','chin_lip',
                        'experienced_owner','consultation','experienced_examiner',
                        'acne_diagnosis','Ni','cluster','experienced_examiner_j')
  
  #fit the two models
  # whole population T2, no examiner experience, no cluster
  m1  <-   glm(consultation ~ 1 
               + experienced_owner   
               + chin_lip     
               + skin_infections       
               + alopecia       
               + comedones           
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m2  <-   glm(consultation ~ 1 
               + chin_lip     
               + skin_infections       
               + alopecia       
               + comedones           
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m3  <-   glm(consultation ~ 1 
               + skin_infections       
               + alopecia       
               + comedones           
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m4  <-   glm(consultation ~ 1 
               + alopecia       
               + comedones           
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m5  <-   glm(consultation ~ 1 
               + comedones           
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m6  <-   glm(consultation ~ 1 
               + scenting     
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m7  <-   glm(consultation ~ 1 
               + stress         
               + indoor,
               data = mydata, family = binomial)
  
  m8  <-   glm(consultation ~ 1 
               + indoor,
               data = mydata, family = binomial)
  
  v <- list('experienced_owner',m1,
            'chin_lip',m2,
            'skin_infections',m3,
            'alopecia',m4,
            'comedones',m5,
            'scenting',m6,
            'stress',m7,
            'indoor',m8)
  T2 <- createT2(v)
  # since it is logistic, exponentiate and create CI
  T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
  T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
  T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
  #read the coefficients into the data frame
  output <- rbind(output,
                  data.frame(datasetname = dataset_name,
                             modeltype = 'T2',
                             T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')]))
}

FileName <- paste0(output_foldername,"/example1.csv")  
Time <- Sys.time() - Start; print(Time)
write.csv(output, file = FileName, row.names = FALSE) 



#example 2) outcome = skin_infections

output <- data.frame(datasetname = character(0),
                     modeltype = character(0),
                     coeff_name = character(0),
                     Estimate = numeric(0),
                     LeftCI = numeric(0),
                     RightCI = numeric(0))
Start <- Sys.time()

for (i in 1:Nreps)
{
  set.seed(13*i)
  #read gendata file in
  dataset_name <- paste0(output_foldername,'/',Sys.Date()," dataset_",i,".csv")
  mydata       <- read.csv(dataset_name)
  #rename columns
  colnames(mydata) <- c('indoor','stress','true_acne','scenting',
                        'comedones','alopecia','skin_infections','chin_lip',
                        'experienced_owner','consultation','experienced_examiner',
                        'acne_diagnosis','Ni','cluster','experienced_examiner_j')
  mydata_consult1 <- mydata[mydata$consultation==1,]
  
  # the whole population
  m1_pop  <- glm(skin_infections ~ 1 
                 + alopecia 
                 + comedones           
                 + scenting     
                 + stress       
                 + indoor,
                 data = mydata, family = binomial)
  m2_pop  <- glm(skin_infections ~ 1 
                 + comedones           
                 + scenting     
                 + stress       
                 + indoor,
                 data = mydata, family = binomial)
  m3_pop  <- glm(skin_infections ~ 1 
                 + scenting     
                 + stress       
                 + indoor,
                 data = mydata, family = binomial)
  m4_pop  <- glm(skin_infections ~ 1 
                 + stress       
                 + indoor,
                 data = mydata, family = binomial)
  m5_pop  <- glm(skin_infections ~ 1 
                 + indoor,
                 data = mydata, family = binomial)
  
  # consulted pets only
  m1_cons <- glm(skin_infections ~ 1 
                 + alopecia 
                 + comedones           
                 + scenting     
                 + stress       
                 + indoor,
                 data = mydata_consult1, family = binomial)
  m2_cons  <- glm(skin_infections ~ 1 
                  + comedones           
                  + scenting     
                  + stress       
                  + indoor,
                  data = mydata_consult1, family = binomial)
  m3_cons  <- glm(skin_infections ~ 1 
                  + scenting     
                  + stress       
                  + indoor,
                  data = mydata_consult1, family = binomial)
  m4_cons  <- glm(skin_infections ~ 1 
                  + stress       
                  + indoor,
                  data = mydata_consult1, family = binomial)
  m5_cons  <- glm(skin_infections ~ 1 
                  + indoor,
                  data = mydata_consult1, family = binomial)
  
  #read the coefficients into the data frame    
  v <- list('alopecia',m1_pop,'comedones',m2_pop,'scenting',m3_pop,'stress',m4_pop,'indoor',m5_pop)
  T2 <- createT2(v)
  # since it is logistic, exponentiate and create CI
  T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
  T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
  T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
  #read the coefficients into the data frame    
  output <- rbind(output,
                  data.frame(datasetname = dataset_name,
                             modeltype = 'T2 -> skin inf, population',
                             T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')]))
  
  v <- list('alopecia',m1_cons,'comedones',m2_cons,'scenting',m3_cons,'stress',m4_cons,'indoor',m5_cons)
  T2 <- createT2(v)
  # since it is logistic, exponentiate and create CI
  T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
  T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
  T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
  
  output <- rbind(output,
                  data.frame(datasetname = dataset_name,
                             modeltype = 'T2 -> skin inf, consultation',
                             T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')]))
}

FileName <- paste0(output_foldername,"/example2.csv") 
Time <- Sys.time() - Start; print(Time)
write.csv(output, file = FileName, row.names = FALSE) 



#example 3) outcome = acne_diagnosis

output <- data.frame(datasetname = character(0),
                     modeltype = character(0),
                     coeff_name = character(0),
                     Estimate = numeric(0),
                     LeftCI = numeric(0),
                     RightCI = numeric(0))
Start <- Sys.time()

for (i in 1:Nreps)
{
  set.seed(13*i)
  #read gendata file in
  dataset_name <- paste0(output_foldername,'/',Sys.Date()," dataset_",i,".csv")
  mydata       <- read.csv(dataset_name)
  #rename columns
  colnames(mydata) <- c('indoor','stress','true_acne','scenting',
                        'comedones','alopecia','skin_infections','chin_lip',
                        'experienced_owner','consultation','experienced_examiner',
                        'acne_diagnosis','Ni','cluster','experienced_examiner_j')
  mydata_consult1 <- mydata[mydata$consultation==1,]
  
  #fit the two models
  m1_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + experienced_owner   
                      + chin_lip     
                      + skin_infections       
                      + alopecia       
                      + comedones           
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m2_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + chin_lip     
                      + skin_infections       
                      + alopecia       
                      + comedones           
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m3_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + skin_infections       
                      + alopecia       
                      + comedones           
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m4_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + alopecia       
                      + comedones           
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m5_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + comedones           
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m6_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + scenting     
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m7_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + stress         
                      + indoor,
                      data = mydata_consult1, family = binomial)
  m8_examiner  <- glm(acne_diagnosis ~ 1 + experienced_examiner_j 
                      + indoor,
                      data = mydata_consult1, family = binomial)
  
  # cluster
  m1_cluster   <- glmer(acne_diagnosis ~ 1 
                        + experienced_owner   
                        + chin_lip     
                        + skin_infections       
                        + alopecia       
                        + comedones           
                        + scenting     
                        + stress         
                        + indoor              
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m2_cluster   <- glmer(acne_diagnosis ~ 1 
                        + chin_lip     
                        + skin_infections       
                        + alopecia       
                        + comedones           
                        + scenting     
                        + stress         
                        + indoor              
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m3_cluster   <- glmer(acne_diagnosis ~ 1 
                        + skin_infections       
                        + alopecia       
                        + comedones           
                        + scenting     
                        + stress         
                        + indoor               
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m4_cluster   <- glmer(acne_diagnosis ~ 1 
                        + alopecia       
                        + comedones           
                        + scenting     
                        + stress         
                        + indoor              
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m5_cluster   <- glmer(acne_diagnosis ~ 1   
                        + comedones           
                        + scenting     
                        + stress         
                        + indoor              
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m6_cluster   <- glmer(acne_diagnosis ~ 1 
                        + scenting     
                        + stress         
                        + indoor               
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m7_cluster   <- glmer(acne_diagnosis ~ 1 
                        + stress         
                        + indoor               
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  m8_cluster   <- glmer(acne_diagnosis ~ 1   
                        + indoor              
                        + (1|cluster),
                        data = mydata_consult1, family = binomial, control = glmerControl(optimizer = "bobyqa"))
  
  # read the coefficients into the data frame
  v <- list('experienced_owner',m1_examiner,
            'chin_lip',m2_examiner,
            'skin_infections',m3_examiner,
            'alopecia',m4_examiner,
            'comedones',m5_examiner,
            'scenting',m6_examiner,
            'stress',m7_examiner,
            'indoor',m8_examiner)
  T2 <- createT2(v)
  # since it is logistic, exponentiate and create CI
  T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
  T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
  T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
  # read the coefficients into the data frame    
  output <- rbind(output,
                  data.frame(datasetname = dataset_name,
                             modeltype = 'T2 -> acne diag, examiner',
                             T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')]))
  
  v <- list('experienced_owner',m1_cluster,
            'chin_lip',m2_cluster,
            'skin_infections',m3_cluster,
            'alopecia',m4_cluster,
            'comedones',m5_cluster,
            'scenting',m6_cluster,
            'stress',m7_cluster,
            'indoor',m8_cluster)
  T2 <- createT2(v)
  # since it is logistic, exponentiate and create CI
  T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
  T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
  T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
  
  output <- rbind(output,
                  data.frame(datasetname = dataset_name,
                             modeltype = 'T2 -> acne diag, cluster',
                             T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')]))
  
}

FileName <- paste0(output_foldername,"/example3.csv") 
Time <- Sys.time() - Start; print(Time)
write.csv(output, file = FileName, row.names = FALSE)



