#### Functions ####

#Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)
factorial_loop <- function(n){
  stopifnot(n%%1==0)
  aux = 1
  if(n < 0){
    stop("Doesn't exist negative factorial.")
  }
  else if (n > 0){
    for(i in 1:n){
      aux <- aux*i
    }
  }
  return(aux) 
}

#Factorial_reduce: a version that computes the factorial using the reduce()
# function in the purrr package. Alternatively, you can use the 
#Reduce() function in the base package.
library("purrr")
factorial_reduce <- function(n){
  stopifnot(n>=0 & n%%1==0)
  if(n==0){return(1)}
  reduce(1:n, function(x,y){x*y})
}

#Factorial_func: a version that uses recursion to compute the factorial.
factorial_func <- function(n){
  stopifnot(n>=0 & n%%1==0)
  if(n==0){
    return(1)
  } else{
      n*factorial_func(n-1)
    }
}

#Factorial_mem: a version that uses memoization to compute the factorial.
fac_mem <- c(1)
factorial_mem <- function(n){
  stopifnot(n>=0 & n%%1==0)
  if (n==0) { 
    return(fac_mem[1])
  } else if(!is.na(fac_mem[n])){
    return(fac_mem[n])
  } else{
    fac_mem[n] <<- n*factorial_mem(n-1)
    return(fac_mem[n])
  }
}

#### Benchmark ####

library(microbenchmark)
loop_data <- map(1:10, function(x){microbenchmark(factorial_loop(x), times = 100)$time})

reduce_data <- map(1:10, function(x){microbenchmark(factorial_reduce(x), times = 100)$time})

factorial_data <- map(1:10, function(x){microbenchmark(factorial_func(x), times = 100)$time})

mem_data <- map(1:10, function(x){microbenchmark(factorial_mem(x), times = 100)$time})