# dags used in 1, 2 and 3; weaker dag can be uncommented here if needs to be used;
# the definition of the original dag and its path coefficients
library(dagitty)
dag <- dagitty('dag {
    bb="0,0,1,1"
    "acne diagnosis" [pos="0.786,0.661"]
    "chin/lip" [pos="0.576,0.262"]
    "experienced examiner" [pos="0.788,0.849"]
    "experienced owner" [pos="0.623,0.038"]
    "skin infections" [pos="0.552,0.488"]
    "true acne" [pos="0.258,0.493"]
    Ni [pos="0.126,0.695"]
    alopecia [pos="0.428,0.479"]
    comedones [pos="0.384,0.256"]
    consultation [pos="0.696,0.663"]
    indoor [pos="0.149,0.441"]
    scenting [pos="0.314,0.371"]
    stress [pos="0.203,0.383"]
    "chin/lip" -> "acne diagnosis" [beta="0.4"]
    "chin/lip" -> "experienced examiner" [beta="0"]
    "chin/lip" -> "experienced owner" [beta="0.3"]
    "chin/lip" -> consultation [beta="0.001"]
    "experienced examiner" -> "acne diagnosis" [beta="0.25"]
    "experienced owner" -> "acne diagnosis" [pos="0.732,0.573",beta="0.01"]
    "experienced owner" -> "experienced examiner" [pos="0.716,0.482",beta="0"]
    "experienced owner" -> consultation [beta="0.1"]
    "skin infections" -> "acne diagnosis" [pos="0.618,0.515",beta="0.1"]
    "skin infections" -> "chin/lip" [beta="0.1"]
    "skin infections" -> "experienced examiner" [pos="0.601,0.574",beta="0"]
    "skin infections" -> "experienced owner" [beta="0.5"]
    "skin infections" -> consultation [beta="0.001"]
    "true acne" -> "acne diagnosis" [beta="0.2"]
    "true acne" -> "chin/lip" [beta="0.2"]
    "true acne" -> "experienced examiner" [beta="0"]
    "true acne" -> "experienced owner" [beta="0"]
    "true acne" -> "skin infections" [beta="0.01"]
    "true acne" -> alopecia [beta="0"]
    "true acne" -> comedones [beta="0.3"]
    "true acne" -> consultation [beta="0"]
    "true acne" -> scenting [beta="0.001"]
    alopecia -> "acne diagnosis" [pos="0.776,0.424",beta="0.01"]
    alopecia -> "chin/lip" [beta="0.01"]
    alopecia -> "experienced examiner" [beta="0"]
    alopecia -> "experienced owner" [beta="0.1"]
    alopecia -> "skin infections" [beta="0.1"]
    alopecia -> consultation [beta="0"]
    comedones -> "acne diagnosis" [beta="0.3"]
    comedones -> "chin/lip" [beta="0.3"]
    comedones -> "experienced examiner" [pos="0.513,0.570",beta="0"]
    comedones -> "experienced owner" [pos="0.442,0.189",beta="0.3"]
    comedones -> "skin infections" [beta="0.3"]
    comedones -> alopecia [beta="0.1"]
    comedones -> consultation [pos="0.592,0.484",beta="0.001"]
    consultation -> "acne diagnosis" [beta="0.022"]
    consultation -> "experienced examiner" [beta="0"]
    indoor -> "acne diagnosis" [pos="0.776,0.981",beta="0.01"]
    indoor -> "chin/lip" [pos="0.373,0.532",beta="0.01"]
    indoor -> "experienced examiner" [pos="0.186,0.677",beta="0"]
    indoor -> "experienced owner" [pos="0.480,0.634",beta="0"]
    indoor -> "skin infections" [pos="0.339,0.547",beta="-0.1"]
    indoor -> "true acne" [beta="0"]
    indoor -> alopecia [pos="0.290,0.512",beta="0.01"]
    indoor -> comedones [pos="0.191,0.310",beta="0.1"]
    indoor -> consultation [pos="0.546,0.698",beta="0.2"]
    indoor -> scenting [pos="0.280,0.391",beta="0.05"]
    indoor -> stress [beta="0.2"]
    scenting -> "acne diagnosis" [pos="0.754,0.421",beta="0.01"]
    scenting -> "chin/lip" [beta="0.3"]
    scenting -> "experienced examiner" [pos="0.591,0.707",beta="0"]
    scenting -> "experienced owner" [pos="0.357,0.376",beta="0.01"]
    scenting -> "skin infections" [beta="0.1"]
    scenting -> alopecia [beta="0.1"]
    scenting -> comedones [beta="0.2"]
    scenting -> consultation [beta="0"]
    stress -> "acne diagnosis" [pos="0.753,0.464",beta="0.1"]
    stress -> "chin/lip" [beta="0.01"]
    stress -> "experienced examiner" [pos="0.218,0.427",beta="0"]
    stress -> "experienced owner" [pos="0.323,0.526",beta="0.01"]
    stress -> "skin infections" [pos="0.367,0.524",beta="0.01"]
    stress -> "true acne" [beta="0.1"]
    stress -> alopecia [beta="0.4"]
    stress -> comedones [beta="0.1"]
    stress -> consultation [pos="0.342,0.475",beta="0"]
    stress -> scenting [beta="0.5"]
    }

    '
)



# weaker dag
# this dag has path coefficients 0.05 weaker than the original dag
# library(dagitty)
# dag <- dagitty('dag {
#     bb="0,0,1,1"
#            "acne diagnosis" [pos="0.786,0.661"]
#            "chin/lip" [pos="0.576,0.262"]
#            "experienced examiner" [pos="0.788,0.849"]
#            "experienced owner" [pos="0.623,0.038"]
#            "skin infections" [pos="0.552,0.488"]
#            "true acne" [pos="0.258,0.493"]
#            Ni [pos="0.126,0.695"]
#            alopecia [pos="0.428,0.479"]
#            comedones [pos="0.384,0.256"]
#            consultation [pos="0.696,0.663"]
#            indoor [pos="0.149,0.441"]
#            scenting [pos="0.314,0.371"]
#            stress [pos="0.203,0.383"]
#            "chin/lip" -> "acne diagnosis" [beta="0.35"]
#            "chin/lip" -> "experienced examiner" [beta="0"]
#            "chin/lip" -> "experienced owner" [beta="0.25"]
#            "chin/lip" -> consultation [beta="0.001"]
#            "experienced examiner" -> "acne diagnosis" [beta="0.2"]
#            "experienced owner" -> "acne diagnosis" [pos="0.732,0.573",beta="0.01"]
#            "experienced owner" -> "experienced examiner" [pos="0.716,0.482",beta="0"]
#            "experienced owner" -> consultation [beta="0.05"]
#            "skin infections" -> "acne diagnosis" [pos="0.618,0.515",beta="0.05"]
#            "skin infections" -> "chin/lip" [beta="0.05"]
#            "skin infections" -> "experienced examiner" [pos="0.601,0.574",beta="0"]
#            "skin infections" -> "experienced owner" [beta="0.45"]
#            "skin infections" -> consultation [beta="0.001"]
#            "true acne" -> "acne diagnosis" [beta="0.15"]
#            "true acne" -> "chin/lip" [beta="0.15"]
#            "true acne" -> "experienced examiner" [beta="0"]
#            "true acne" -> "experienced owner" [beta="0"]
#            "true acne" -> "skin infections" [beta="0.01"]
#            "true acne" -> alopecia [beta="0"]
#            "true acne" -> comedones [beta="0.25"]
#            "true acne" -> consultation [beta="0"]
#            "true acne" -> scenting [beta="0.001"]
#            alopecia -> "acne diagnosis" [pos="0.776,0.424",beta="0.01"]
#            alopecia -> "chin/lip" [beta="0.01"]
#            alopecia -> "experienced examiner" [beta="0"]
#            alopecia -> "experienced owner" [beta="0.05"]
#            alopecia -> "skin infections" [beta="0.05"]
#            alopecia -> consultation [beta="0"]
#            comedones -> "acne diagnosis" [beta="0.25"]
#            comedones -> "chin/lip" [beta="0.25"]
#            comedones -> "experienced examiner" [pos="0.513,0.570",beta="0"]
#            comedones -> "experienced owner" [pos="0.442,0.189",beta="0.25"]
#            comedones -> "skin infections" [beta="0.25"]
#            comedones -> alopecia [beta="0.05"]
#            comedones -> consultation [pos="0.592,0.484",beta="0.001"]
#            consultation -> "acne diagnosis" [beta="0.022"]
#            consultation -> "experienced examiner" [beta="0"]
#            indoor -> "acne diagnosis" [pos="0.776,0.981",beta="0.01"]
#            indoor -> "chin/lip" [pos="0.373,0.532",beta="0.01"]
#            indoor -> "experienced examiner" [pos="0.186,0.677",beta="0"]
#            indoor -> "experienced owner" [pos="0.480,0.634",beta="0"]
#            indoor -> "skin infections" [pos="0.339,0.547",beta="-0.05"]
#            indoor -> "true acne" [beta="0"]
#            indoor -> alopecia [pos="0.290,0.512",beta="0.01"]
#            indoor -> comedones [pos="0.191,0.310",beta="0.05"]
#            indoor -> consultation [pos="0.546,0.698",beta="0.15"]
#            indoor -> scenting [pos="0.280,0.391",beta="0.05"]
#            indoor -> stress [beta="0.15"]
#            scenting -> "acne diagnosis" [pos="0.754,0.421",beta="0.01"]
#            scenting -> "chin/lip" [beta="0.25"]
#            scenting -> "experienced examiner" [pos="0.591,0.707",beta="0"]
#            scenting -> "experienced owner" [pos="0.357,0.376",beta="0.01"]
#            scenting -> "skin infections" [beta="0.05"]
#            scenting -> alopecia [beta="0.05"]
#            scenting -> comedones [beta="0.15"]
#            scenting -> consultation [beta="0"]
#            stress -> "acne diagnosis" [pos="0.753,0.464",beta="0.05"]
#            stress -> "chin/lip" [beta="0.01"]
#            stress -> "experienced examiner" [pos="0.218,0.427",beta="0"]
#            stress -> "experienced owner" [pos="0.323,0.526",beta="0.01"]
#            stress -> "skin infections" [pos="0.367,0.524",beta="0.01"]
#            stress -> "true acne" [beta="0.05"]
#            stress -> alopecia [beta="0.35"]
#            stress -> comedones [beta="0.05"]
#            stress -> consultation [pos="0.342,0.475",beta="0"]
#            stress -> scenting [beta="0.45"]
#            }
#             '
#  )

# used in 1 and 2
GenData <- function(N, k, Prev, Data.Cor, seed = 0, N.Factors=0, Max.Trials=5, Initial.Multiplier=1)
{
    # Initialize variables and (if applicable) set random number seed (step 1) -------------------------------------
    Data <- matrix(0, nrow = N, ncol = k) # Matrix to store the simulated data
    Distributions <- matrix(0, nrow = N, ncol = k) # Matrix to store each variable’s score distribution
    Iteration <- 0 # Iteration counter
    Best.RMSR <- 1 # Lowest RMSR correlation
    Trials.Without.Improvement <- 0 # Trial counter
    if (seed != 0) set.seed(seed) # If user specified a nonzero seed, set it
    # Generate distribution for each variable (step 2) -------------------------------------------------------------
    for (i in 1:10)
    {
          Distributions[,i] <- sort(rbinom(N,1,Prev[i]))         # Binary distribution with p = Prev
    }
    Distributions[,11] <- sort(rnorm(N, 0, 1))                    # Standard normal distribution  
    Distributions[,12] <- sort(rbinom(N,1,Prev[12 - 1]))         # Binary distribution with p = Prev
    Distributions[,k]  <- sort(rnorm(N, 0, 1))                    # Standard normal distribution  
    Target.Corr <- Data.Cor
    Intermediate.Corr <- Target.Corr
    if (N.Factors == 0)
    {
        Eigenvalues.Observed <- eigen(Intermediate.Corr)$values
        Eigenvalues.Random <- matrix(0, nrow = 100, ncol = k)
        Random.Data <- matrix(0, nrow = N, ncol = k)
        for (i in 1:100)
        {
            for (j in 1:k)
            Random.Data[,j] <- sample(Distributions[,j], size = N, replace = TRUE)
            Eigenvalues.Random[i,] <- eigen(cor(Random.Data))$values
        }
        Eigenvalues.Random <- apply(Eigenvalues.Random, 2, mean) # calculate mean eigenvalue for each factor
        N.Factors <- max(1, sum(Eigenvalues.Observed > Eigenvalues.Random))
    }
    # Generate random normal data for shared and unique components, initialize factor loadings (steps 5, 6) --------
    Shared.Comp <- matrix(rnorm(N * N.Factors, 0, 1), nrow = N, ncol = N.Factors)
    Unique.Comp <- matrix(rnorm(N * k, 0, 1), nrow = N, ncol = k)
    Shared.Load <- matrix(0, nrow = k, ncol = N.Factors)
    Unique.Load <- matrix(0, nrow = k, ncol = 1)
    # Begin loop that ends when specified number of iterations pass without improvement in RMSR correlation --------
    while (Trials.Without.Improvement < Max.Trials)
    {
        Iteration <- Iteration + 1
        # Calculate factor loadings and apply to reproduce desired correlations (steps 7, 8) ---------------------------
        Fact.Anal <- Factor.Analysis(Intermediate.Corr, Corr.Matrix = TRUE, N.Factors = N.Factors)
        if (N.Factors == 1) Shared.Load[,1] <- Fact.Anal$loadings
        else Shared.Load <- Fact.Anal$loadings
        Shared.Load[Shared.Load > 1] <- 1
        Shared.Load[Shared.Load < -1] <- -1
        if (Shared.Load[1,1] < 0) Shared.Load <- Shared.Load * -1
        Shared.Load.sq <- Shared.Load * Shared.Load
        for (i in 1:k)
            if (sum(Shared.Load.sq[i,]) < 1) Unique.Load[i,1] <- (1 - sum(Shared.Load.sq[i,]))
            else Unique.Load[i,1] <- 0
        Unique.Load <- sqrt(Unique.Load)
        for (i in 1:k)
            Data[,i] <- (Shared.Comp %*% t(Shared.Load))[,i] + Unique.Comp[,i] * Unique.Load[i,1]
        # the %*% operator = matrix multiplication, and the t() function = transpose (both used again in step 13)
        # Replace normal with nonnormal distributions (step 9) ---------------------------------------------------------
        for (i in 1:k)
        {
            Data <- Data[sort.list(Data[,i]),]
            Data[,i] <- Distributions[,i]
        }
        # Calculate RMSR correlation, compare to lowest value, take appropriate action (steps 10, 11, 12) --------------
        Reproduced.Corr <- cor(Data)
        Residual.Corr <- Target.Corr - Reproduced.Corr
        RMSR <- sqrt(sum(Residual.Corr[lower.tri(Residual.Corr)] * Residual.Corr[lower.tri(Residual.Corr)]) / (.5 * (k * k - k)))
        if (RMSR < Best.RMSR)
        {
            Best.RMSR <- RMSR
            Best.Corr <- Intermediate.Corr
            Best.Res <- Residual.Corr
            Intermediate.Corr <- Intermediate.Corr + Initial.Multiplier * Residual.Corr
            Trials.Without.Improvement <- 0
        }
        else
        {
            Trials.Without.Improvement <- Trials.Without.Improvement + 1
            Current.Multiplier <- Initial.Multiplier * .5 ^ Trials.Without.Improvement
            Intermediate.Corr <- Best.Corr + Current.Multiplier * Best.Res
        }
    } # end of the while loop

    # Construct the data set with the lowest RMSR correlation (step 13) --------------------------------------------
    Fact.Anal <- Factor.Analysis(Best.Corr, Corr.Matrix = TRUE, N.Factors = N.Factors)
    if (N.Factors == 1) Shared.Load[,1] <- Fact.Anal$loadings
    else Shared.Load <- Fact.Anal$loadings
    Shared.Load[Shared.Load > 1] <- 1
    Shared.Load[Shared.Load < -1] <- -1
    if (Shared.Load[1,1] < 0) Shared.Load <- Shared.Load * -1
    Shared.Load.sq <- Shared.Load * Shared.Load
    for (i in 1:k)
        if (sum(Shared.Load.sq[i,]) < 1) Unique.Load[i,1] <- (1 - sum(Shared.Load.sq[i,]))
        else Unique.Load[i,1] <- 0
    Unique.Load <- sqrt(Unique.Load)
    for (i in 1:k)
        Data[,i] <- (Shared.Comp %*% t(Shared.Load))[,i] + Unique.Comp[,i] * Unique.Load[i,1]
    Data <- apply(Data, 2, scale) # standardizes each variable in the matrix
    for (i in 1:k)
    {
        Data <- Data[sort.list(Data[,i]),]
        Data[,i] <- Distributions[,i]
    }
    # Report the results and return the simulated data set (step 14) -----------------------------------------------
    Iteration <- Iteration - Max.Trials
    cat("\nN =",N,", k =",k,",",Iteration,"Iterations,",N.Factors,"Factors, RMSR r =",round(Best.RMSR,3),"\n")
    return(Data)
} # end of genData

# used in 1 and 2
Factor.Analysis <- function(Data, Corr.Matrix = FALSE, Max.Iter = 50, N.Factors = 0)
{
    Data <- as.matrix(Data)
    k <- dim(Data)[2]
    if (N.Factors == 0) N.Factors <- k
    if (!Corr.Matrix) Cor.Matrix <- cor(Data)
    else Cor.Matrix <- Data
    Criterion <- .001
    Old.H2 <- rep(99, k)
    H2 <- rep(0, k)
    Change <- 1
    Iter <- 0
    Factor.Loadings <- matrix(nrow = k, ncol = N.Factors)
    while ((Change >= Criterion) & (Iter < Max.Iter))
    {
        Iter <- Iter + 1
        Eig <- eigen(Cor.Matrix)
        L <- sqrt(Eig$values[1:N.Factors])
        for (i in 1:N.Factors)
        Factor.Loadings[,i] <- Eig$vectors[,i] * L[i]
        for (i in 1:k)
        H2[i] <- sum(Factor.Loadings[i,] * Factor.Loadings[i,])
        Change <- max(abs(Old.H2 - H2))
        Old.H2 <- H2
        diag(Cor.Matrix) <- H2
    }
    if (N.Factors == k) N.Factors <- sum(Eig$values > 1)
    return(list(loadings = Factor.Loadings[,1:N.Factors], factors = N.Factors))
}

# used in 1 and 2
# a function from graph4lg package
reorder_mat <- function(mat, order){

  # Number of elements in the vector 'order'
  n <- length(order)

  # Check whether 'mat' is a 'matrix'
  if(!inherits(mat, "matrix")){
    stop("'mat' must be a matrix")
  # Check whether 'order' is of class 'character'
  } else if (!inherits(order, "character")){
    stop("'order' must be a character vector")
  # Check whether 'mat' is a symmetric matrix
  } else if(!(isSymmetric(mat))){
    stop("The matrix 'mat' must be symmetric")
  # Check whether 'order' has as many elements as there are rows
  # and columns in 'mat'
  } else if (n != length(colnames(mat))){
    stop("'order' must have as many elements as there are rows and
         columns in 'mat'")
  # Check whether the column names are in the 'order' vector
  } else if(length(which(colnames(mat) %in% order)) != n){
    stop("The column names of the matrix you want to reorder must
         be present in the vector 'order'")
  # Check whether the row names are in the 'order' vector
  } else if (length(which(row.names(mat) %in% order)) != n){
    print("The row names of the matrix you want to reorder must
          be present in the vector 'order'")
  } else {

    # Reorder 'mat' according to 'order'
    mat2 <- mat[order, order]

    return(mat2)
  }
}

# used in 2 and 3
get_prevalence <- function(mydata)
{
    mydata_consult0 <- mydata[mydata$consultation==0,]
    mydata_consult1 <- mydata[mydata$consultation==1,]

    num_consult0 <- nrow(mydata_consult0)
    num_consult1 <- nrow(mydata_consult1)
    prevalence <- data.frame(covariate = character(0),
                                     dataset = character(0),
                                     percentage1 = numeric(0))
    # consulted
    prevalence <- rbind(prevalence,
                               c('experienced_owner','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'experienced_owner'==1,])/num_consult1*100),
                               c('chin_lip','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'chin_lip'==1,])/num_consult1*100),
                               c('skin_infections','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'skin_infections'==1,])/num_consult1*100),
                               c('alopecia','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'alopecia'==1,])/num_consult1*100),
                               c('comedones','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'comedones'==1,])/num_consult1*100),
                               c('scenting','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'scenting'==1,])/num_consult1*100),
                               c('true_acne','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'true_acne'==1,])/num_consult1*100),
                               c('stress','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'stress'==1,])/num_consult1*100),
                               c('indoor','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'indoor'==1,])/num_consult1*100),
                               c('acne_diagnosis','consulted',
                                 nrow(mydata_consult1[mydata_consult1$'acne_diagnosis'==1,])/num_consult1*100))
    # non-consulted
    prevalence <- rbind(prevalence,
                               c('experienced_owner','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'experienced_owner'==1,])/num_consult0*100),
                               c('chin_lip','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'chin_lip'==1,])/num_consult0*100),
                               c('skin_infections','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'skin_infections'==1,])/num_consult0*100),
                               c('alopecia','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'alopecia'==1,])/num_consult0*100),
                               c('comedones','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'comedones'==1,])/num_consult0*100),
                               c('scenting','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'scenting'==1,])/num_consult0*100),
                               c('true_acne','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'true_acne'==1,])/num_consult0*100),
                               c('stress','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'stress'==1,])/num_consult0*100),
                               c('indoor','non-consulted',
                                 nrow(mydata_consult0[mydata_consult0$'indoor'==1,])/num_consult0*100))
    colnames(prevalence) <- c('covariate','dataset','percentage1')
    prevalence$percentage1 <- round(as.numeric(prevalence$percentage1),2)
    return(prevalence)    
}

# a convenience function that creates a proper table 2;
# the input v to the function is a list in the format:
# v <- list('covariate1',model1,'covariate2',model2)
# with as many covariates and models as needed;
# odd elements are strings containing the name of the covariate of interest,
# even elements are objects that are the output of funtions like lmer or glm;
# then the estimate of the coefficient representing a total causal effect of covariate1 is extracted from model1
# together with the standard error and a set of covariates that the model adjusts for, is returned;
# and so on for the following covariates;
# ------------------------------------------------------
# for problems with a traditional table 2, see:
# Westreich D, Greenland S. The table 2 fallacy: presenting and interpreting confounder and modifier coefficients. 
# American Journal of Epidemiology. 2013;177:292–98
# used in 3 and 4
createT2 <- function(v)
{
    rows <- length(v)/2 # should break if v is misspecified, code can be improved to be robust to that
    
    # initialize
    T2 <- data.frame(matrix(ncol = 4, nrow = 0)) 
    colnames(T2) <- c('covariate','reg_coeff','std_error','adjusted_for')
    
    j <- 1 # row count
    
    # iterate over input list
    for (i in 1:rows)
    {
        covariate <- v[2*i-1]
        model <- v[2*i][[1]]
        covnames <- rownames(coef(summary(model)))[grep(paste('^',covariate,sep=''), rownames(coef(summary(model))))]
        numcov <- length(covnames)
        
        T2[j:(j+numcov-1),1] <- covnames
        
        col2 <- data.frame(coef(summary(model))[grep(paste('^',covariate,sep=''), rownames(coef(summary(model)))),])
        T2[j:(j+numcov-1),2] <- if (ncol(col2)==1) {col2['Estimate',]} else {col2[,'Estimate']}
        
        T2[j:(j+numcov-1),3] <- if (ncol(col2)==1) {col2['Std. Error',]} else {col2[,'Std..Error']}
        adj <- setdiff(all.vars(delete.response(terms(model))),covariate)
        
        T2[j:(j+numcov-1),4] <- paste(adj,collapse=", ")

        j <- j+numcov
    }
    return(T2)
}
