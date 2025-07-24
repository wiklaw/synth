#This code is creating and analysing a synthetic dataset for simple feline acne DAG using dagitty. It also pulls in results on analysis on gendata datasets.

# if not yet installed, install the required packages
# packgs <- c('ggplot2','dagitty','lme4','corrplot','semPlot','stringr','boot','tidyverse')
# install.packages(packgs)

rm(list=ls()) 
library(ggplot2)
library(dagitty)
library(lme4)
library(corrplot)
library(semPlot)
library(stringr)
library(boot)
# source the file with functions used in the project, includes DAG definitions: dag
# dag definition functions: GenData, Factor.Analysis, reorder_mat, get_prevalence, createT2
source('0_supporting_functions.r')


# plot dag ####
# options(repr.plot.width=15, repr.plot.height=8)
# the plot can include path coefficients but it might be busy
# plot(dag, show.coefficients=TRUE)
# plot(dag)


# simulate data from the dag####
N <- 100000 # number of data points
mydataSEM <- simulateSEM(dag, N=N, empirical=TRUE, b.default=0) # Gaussian dagitty dataset

# correlation matrix
options(repr.plot.width=20, repr.plot.height=12)
corrplot(round(cor(mydataSEM),2), addCoef.col = "black", tl.col="black", col=c("lightblue", "yellow"),
         tl.cex = 1.3, number.cex = 1.1, cl.cex = 1.1, tl.srt = 65)


#This section uses covariate Ni to generate clustering and examiner's experience; it is divided into six steps; N/C must be an integer but the code can be improved to skip that requirement####

C <- 50 # number of examiners
sdev_examiners <- 0.9 # standard deviation of the number of consultations per examiner
mean_examiners <- 1.2 # mean of the number of consultations per examiner
if (floor(N/C)!=ceiling(N/C)) print('Make sure N/C is an integer!')


# 1. order Ni ascending
Nhat <- mydataSEM[order(mydataSEM$Ni),'Ni']

# 2. rescale, with mean and standard deviation as defined above
Nhat <- Nhat*sdev_examiners + mean_examiners
# exponentiate to get the lognormal distribution 'back'
Nhat <- exp(Nhat)

# 3. divide the vector into C equal-size subgroups by creating 'subgroup' column
Nhat <- data.frame(Nhat)
Nhat$subgroup <- rep(1:C, each=N/C)

# 4. select 1 value in each subgroup and round it to the nearest integer to get C numbers of cluster size (Njhat)
select_rows <- runif(C)*N/C
# add a vector of 1, 2001, 4001,...
select_rows <- select_rows + seq(1,length.out = length(select_rows), by=N/C)
select_rows <- round(select_rows,0)
Njhat <- Nhat[select_rows,]
Njhat$Nhat <- round(Njhat$Nhat,0)
rm(select_rows)
rm(Nhat)

# 5. make Njhat sum to the population size by adding +/- 1 randomly -> Nj
while (N-sum(Njhat$Nhat)!=0)
{
  sample_rows <- sample(1:nrow(Njhat), size=min(abs(N-sum(Njhat$Nhat)),nrow(Njhat)))
  Njhat[sample_rows, 'Nhat'] <- Njhat[sample_rows, 'Nhat'] + 1*if(N-sum(Njhat$Nhat)<0){-1}else{1}
}
Nj <- Njhat$Nhat
rm(Njhat)

# 6. divide original Ni into C clusters of size Nj, j=1,2,...,C
mydataSEM <- mydataSEM[order(mydataSEM$Ni),]

Nj <- round(Nj/sum(Nj)*N,0)
# randomly +/-1 if sum(Nj)!=N
while (N-sum(Nj)!=0)
{
  sample_rows <- sample(1:length(Nj), size=min(abs(N-sum(Nj)),length(Nj)))
  Nj[sample_rows] <- Nj[sample_rows] + 1*if(N-sum(Nj)<0){-1}else{1}
}
options(repr.plot.width=8, repr.plot.height=8)
plot(Nj)

# 6. continued
mydataSEM$cluster <- rep(1:C,Nj)


Nj

rm(Nj)



# average examiner's experience by cluster
mydataSEM$'experienced examiner j' <- ave(mydataSEM$'experienced examiner', mydataSEM$cluster, FUN = mean, na.rm = TRUE)

head(mydataSEM)

#dichotomise the covariates####

mydataSEM <- mydataSEM[order(mydataSEM$'acne diagnosis',decreasing = TRUE),]
percent_of1s <- 0.28
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'acne diagnosis' <- 0
mydataSEM[1:num_rows_of1s,'acne diagnosis'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'chin/lip',decreasing = TRUE),]
percent_of1s <- 3
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'chin/lip' <- 0
mydataSEM[1:num_rows_of1s,'chin/lip'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'experienced owner',decreasing = TRUE),]
percent_of1s <- 34
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'experienced owner' <- 0
mydataSEM[1:num_rows_of1s,'experienced owner'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'skin infections',decreasing = TRUE),]
percent_of1s <- 2
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'skin infections' <- 0
mydataSEM[1:num_rows_of1s,'skin infections'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'true acne',decreasing = TRUE),]
percent_of1s <- 5
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'true acne' <- 0
mydataSEM[1:num_rows_of1s,'true acne'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'alopecia',decreasing = TRUE),]
percent_of1s <- 1
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'alopecia' <- 0
mydataSEM[1:num_rows_of1s,'alopecia'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'comedones',decreasing = TRUE),]
percent_of1s <- 3
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'comedones' <- 0
mydataSEM[1:num_rows_of1s,'comedones'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'consultation',decreasing = TRUE),]
percent_of1s <- 21.7
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'consultation' <- 0
mydataSEM[1:num_rows_of1s,'consultation'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'indoor',decreasing = TRUE),]
percent_of1s <- 26.1
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'indoor' <- 0
mydataSEM[1:num_rows_of1s,'indoor'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'scenting',decreasing = TRUE),]
percent_of1s <- 25
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'scenting' <- 0
mydataSEM[1:num_rows_of1s,'scenting'] <- 1

mydataSEM <- mydataSEM[order(mydataSEM$'stress',decreasing = TRUE),]
percent_of1s <- 25
num_rows_of1s <- round(percent_of1s*N/100,0)
mydataSEM$'stress' <- 0
mydataSEM[1:num_rows_of1s,'stress'] <- 1


# plot the correlations
# options(repr.plot.width=8, repr.plot.height=8)
# corrplot(round(cor(mydataSEM[,c('acne diagnosis','chin/lip',
#                                 'skin infections','true acne','alopecia',
#                                 'comedones','consultation','indoor','scenting','stress')]),2),
#          addCoef.col = "black", tl.col="black", col=c("lightblue", "yellow"),
#          tl.cex = 1.3, number.cex = 1.1, cl.cex = 1.1, tl.srt = 65)


# create 'table 2' for dichotomised covariates####

# solvers don't like names with spaces
names2change <- colnames(mydataSEM)
new_names <- str_replace(names2change, " ", "_")
new_names <- str_replace(new_names, " ", "_")
new_names <- str_replace(new_names, " ", "_")
new_names <- str_replace(new_names, "/", "_")
colnames(mydataSEM) <- new_names

# data for pets that have had a consultation
mydata_consult1 <- mydataSEM[mydataSEM$consultation==1,]


# example 1) outcome: consultation####

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
             data = mydataSEM, family = binomial)

m2  <-   glm(consultation ~ 1 
             + chin_lip     
             + skin_infections       
             + alopecia       
             + comedones           
             + scenting     
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m3  <-   glm(consultation ~ 1 
             + skin_infections       
             + alopecia       
             + comedones           
             + scenting     
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m4  <-   glm(consultation ~ 1 
             + alopecia       
             + comedones           
             + scenting     
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m5  <-   glm(consultation ~ 1 
             + comedones           
             + scenting     
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m6  <-   glm(consultation ~ 1 
             + scenting     
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m7  <-   glm(consultation ~ 1 
             + stress         
             + indoor,
             data = mydataSEM, family = binomial)

m8  <-   glm(consultation ~ 1 
             + indoor,
             data = mydataSEM, family = binomial)

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
T2

# read in gendata files
gendata7      <- read.csv('gendata7/example1.csv')
gendata8      <- read.csv('gendata8/example1.csv')
gendata8_weak <- read.csv('gendata8_weaker_dag/example1.csv')

gendata7 <- aggregate(gendata7[,c('exp_reg_coeff')],
                      by=list(covariate=gendata7$covariate,
                              adjusted_for=gendata7$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8 <- aggregate(gendata8[,c('exp_reg_coeff')],
                      by=list(covariate=gendata8$covariate,
                              adjusted_for=gendata8$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8_weak <- aggregate(gendata8_weak[,c('exp_reg_coeff')],
                           by=list(covariate=gendata8_weak$covariate,
                                   adjusted_for=gendata8_weak$adjusted_for),
                           function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

# get all results together
T2 <- merge(T2[,c('covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right')], 
            gendata7, by=c("covariate", "adjusted_for"))
T2 <- merge(T2, gendata8, by=c("covariate", "adjusted_for"))
T2 <- merge(T2, gendata8_weak, by=c("covariate", "adjusted_for"))

colnames(T2) <- c('covariate','adjusted_for','exp_reg_coeff_dagitty','CI_left_dagitty','CI_right_dagitty',
                  'gendata7',
                  'gendata8',
                  'gendata8_weak')


T2



T2_plot <- data.frame(type='dagitty',
                      covariate=T2$covariate,
                      left=T2$CI_left_dagitty,
                      estimate=T2$exp_reg_coeff_dagitty,
                      right=T2$CI_right_dagitty)

T2_plot <- rbind(T2_plot,
                 data.frame(type='gendata7', 
                            covariate=T2$covariate,
                            left=T2$gendata7[,1], 
                            estimate=T2$gendata7[,2], 
                            right=T2$gendata7[,3]))
T2_plot <- rbind(T2_plot,
                 data.frame(type='gendata8', 
                            covariate=T2$covariate,
                            left=T2$gendata8[,1], 
                            estimate=T2$gendata8[,2], 
                            right=T2$gendata8[,3]))
T2_plot <- rbind(T2_plot,
                 data.frame(type='gendata8_weak', 
                            covariate=T2$covariate,
                            left=T2$gendata8_weak[,1], 
                            estimate=T2$gendata8_weak[,2], 
                            right=T2$gendata8_weak[,3]))


ggplot(T2_plot, aes(x=covariate,y=estimate,ymin=left,ymax=right,color=type)) +
  geom_pointrange(position = position_dodge2(width = 0.2)) + 
  theme(text = element_text(size = 20)) +
  theme_classic(base_size = 18) +
  coord_flip()





# example 2) outcome: skin infections





# the whole population
m1_pop  <- glm(skin_infections ~ 1 
               + alopecia 
               + comedones           
               + scenting     
               + stress       
               + indoor,
               data = mydataSEM, family = binomial)
m2_pop  <- glm(skin_infections ~ 1 
               + comedones           
               + scenting     
               + stress       
               + indoor,
               data = mydataSEM, family = binomial)
m3_pop  <- glm(skin_infections ~ 1 
               + scenting     
               + stress       
               + indoor,
               data = mydataSEM, family = binomial)
m4_pop  <- glm(skin_infections ~ 1 
               + stress       
               + indoor,
               data = mydataSEM, family = binomial)
m5_pop  <- glm(skin_infections ~ 1 
               + indoor,
               data = mydataSEM, family = binomial)

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
                + indoor            ,
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


v  <- list('alopecia',m1_pop,'comedones',m2_pop,'scenting',m3_pop,'stress',m4_pop,'indoor',m5_pop)
T2 <- createT2(v)
# since it is logistic, exponentiate and create CI
T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
#read the coefficients into the data frame 
T2$modeltype <- 'T2 -> skin inf, population'
e2 <- T2
v  <- list('alopecia',m1_cons,'comedones',m2_cons,'scenting',m3_cons,'stress',m4_cons,'indoor',m5_cons)
T2 <- createT2(v)
# since it is logistic, exponentiate and create CI
T2$'exp_reg_coeff' <- exp(T2$'reg_coeff')
T2$'CI_left'       <- exp(T2$'reg_coeff'-1.96*T2$'std_error')
T2$'CI_right'      <- exp(T2$'reg_coeff'+1.96*T2$'std_error')
#read the coefficients into the data frame 
T2$modeltype <- 'T2 -> skin inf, consultation'

e2 <- rbind(e2,T2)


gendata7      <- read.csv('gendata7/example2.csv')
gendata8      <- read.csv('gendata8/example2.csv')
gendata8_weak <- read.csv('gendata8_weaker_dag/example2.csv')

gendata7 <- aggregate(gendata7[,c('exp_reg_coeff')],
                      by=list(modeltype=gendata7$modeltype,
                              covariate=gendata7$covariate, 
                              adjusted_for=gendata7$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8 <- aggregate(gendata8[,c('exp_reg_coeff')],
                      by=list(modeltype=gendata8$modeltype,
                              covariate=gendata8$covariate, 
                              adjusted_for=gendata8$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8_weak <- aggregate(gendata8_weak[,c('exp_reg_coeff')],
                           by=list(modeltype=gendata8_weak$modeltype,
                                   covariate=gendata8_weak$covariate, 
                                   adjusted_for=gendata8_weak$adjusted_for),
                           function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))                   

# get all results together
e2 <- merge(e2[,c("modeltype", "covariate",'adjusted_for', 'exp_reg_coeff','CI_left','CI_right')], gendata7, 
            by=c("modeltype", "covariate",'adjusted_for'))

e2 <- merge(e2, gendata8, by=c("modeltype", "covariate",'adjusted_for'))

e2 <- merge(e2, gendata8_weak, by=c("modeltype", "covariate",'adjusted_for'))                           
colnames(e2) <- c('modeltype','covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right',
                  'gendata7',
                  'gendata8',
                  'gendata8_weak')


e2







#this should not be pasted but will have to do for now
e2_plot <- data.frame(type='dagitty',
                      modeltype=e2$modeltype,
                      covariate=e2$covariate,
                      left=e2$CI_left,
                      estimate=e2$exp_reg_coeff,
                      right=e2$CI_right)

e2_plot <- rbind(e2_plot,data.frame(type='gendata7',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata7[,1],
                                    estimate=e2$gendata7[,2],
                                    right=e2$gendata7[,3]))

e2_plot <- rbind(e2_plot,data.frame(type='gendata8',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata8[,1],
                                    estimate=e2$gendata8[,2],
                                    right=e2$gendata8[,3]))

e2_plot <- rbind(e2_plot,data.frame(type='gendata8_weak',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata8_weak[,1],
                                    estimate=e2$gendata8_weak[,2],
                                    right=e2$gendata8_weak[,3]))


options(repr.plot.width=16, repr.plot.height=7)
ggplot(e2_plot, aes(x=covariate,y=estimate,ymin=left,ymax=right,color=type)) +
  geom_pointrange(position = position_dodge2(width = 0.2)) + 
  theme(text = element_text(size = 20)) +
  coord_flip() +
  theme_classic(base_size = 18) +
  facet_wrap(~modeltype)






#example 3) outcome: acne diagnosis




# examiner
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
#read the coefficients into the data frame 
T2$modeltype <- 'T2 -> acne diag, examiner'
e2 <- T2
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
#read the coefficients into the data frame 
T2$modeltype <- 'T2 -> acne diag, cluster'

e2 <- rbind(e2,T2)


# we only want comedones here
gendata7      <- read.csv('gendata7/example3.csv')
gendata8      <- read.csv('gendata8/example3.csv')
gendata8_weak <- read.csv('gendata8_weaker_dag/example3.csv')


gendata7 <- aggregate(gendata7[,c('exp_reg_coeff')],
                      by=list(modeltype=gendata7$modeltype,
                              covariate=gendata7$covariate, 
                              adjusted_for=gendata7$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8 <- aggregate(gendata8[,c('exp_reg_coeff')],
                      by=list(modeltype=gendata8$modeltype,
                              covariate=gendata8$covariate, 
                              adjusted_for=gendata8$adjusted_for),
                      function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))

gendata8_weak <- aggregate(gendata8_weak[,c('exp_reg_coeff')],
                           by=list(modeltype=gendata8_weak$modeltype,
                                   covariate=gendata8_weak$covariate, 
                                   adjusted_for=gendata8_weak$adjusted_for),
                           function(i, na.rm) quantile(i, probs=c(0.025,0.5,0.975)))                   

# get all results together
e2 <- merge(e2[,c("modeltype", "covariate",'adjusted_for', 'exp_reg_coeff','CI_left','CI_right')], gendata7, 
            by=c("modeltype", "covariate",'adjusted_for'))

e2 <- merge(e2, gendata8, by=c("modeltype", "covariate",'adjusted_for'))

e2 <- merge(e2, gendata8_weak, by=c("modeltype", "covariate",'adjusted_for'))                           
colnames(e2) <- c('modeltype','covariate','adjusted_for','exp_reg_coeff','CI_left','CI_right',
                  'gendata7',
                  'gendata8',
                  'gendata8_weak')


e2







#this should not be pasted but will have to do for now
e2_plot <- data.frame(type='dagitty',
                      modeltype=e2$modeltype,
                      covariate=e2$covariate,
                      left=e2$CI_left,
                      estimate=e2$exp_reg_coeff,
                      right=e2$CI_right)

e2_plot <- rbind(e2_plot,data.frame(type='gendata7',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata7[,1],
                                    estimate=e2$gendata7[,2],
                                    right=e2$gendata7[,3]))

e2_plot <- rbind(e2_plot,data.frame(type='gendata8',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata8[,1],
                                    estimate=e2$gendata8[,2],
                                    right=e2$gendata8[,3]))

e2_plot <- rbind(e2_plot,data.frame(type='gendata8_weak',
                                    modeltype=e2$modeltype,
                                    covariate=e2$covariate,
                                    left=e2$gendata8_weak[,1],
                                    estimate=e2$gendata8_weak[,2],
                                    right=e2$gendata8_weak[,3]))


options(repr.plot.width=16, repr.plot.height=7)
ggplot(e2_plot, aes(x=covariate,y=estimate,ymin=left,ymax=right,color=type)) +
  geom_pointrange(position = position_dodge2(width = 0.2)) + 
  theme(text = element_text(size = 20)) +
  coord_flip() +
  facet_wrap(~modeltype) +
  theme_classic(base_size = 18) +
  scale_y_continuous(trans='log10')






head(e2_plot,20)





#Prevalence tables


mydata_consult0 <- mydataSEM[mydataSEM$consultation==0,]
mydata_consult1 <- mydataSEM[mydataSEM$consultation==1,]


num_consult0 <- nrow(mydata_consult0)
num_consult1 <- nrow(mydata_consult1)
print(num_consult0)
print(num_consult1)


prevalence_dagitty <- get_prevalence(mydataSEM)


head(prevalence_dagitty)




ggplot(data=prevalence_dagitty, aes(x=covariate, y=percentage1, fill=dataset)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_minimal() + scale_fill_manual(values=c('#E69F00','#999999')) +
  theme(text = element_text(size = 20)) +
  theme_classic(base_size = 18) +
  coord_flip()




