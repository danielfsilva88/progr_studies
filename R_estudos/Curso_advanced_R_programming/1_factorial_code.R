


#Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)
Factorial_loop <- function(n){
    aux = 1
    if(n < 0){
        stop("Doesn't exist negative factorial.")
    }
    else if (n > 0){
        for(i in 1:n){
            aux <- aux*i
        }
    }
    return aux
}


#Factorial_reduce: a version that computes the factorial using the reduce() function in the purrr package. Alternatively, you can use the Reduce() function in the base package.
Factorial_reduce <- function(){

}


#Factorial_func: a version that uses recursion to compute the factorial.
Factorial_func <- function(){

}


#Factorial_mem: a version that uses memoization to compute the factorial.
Factorial_mem <- function(){
    
}

