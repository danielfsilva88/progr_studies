


#Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)
Factorial_loop <- function(n){
    if(n == 0){
        return 1
    }
    else if(n < 0){
        stop("Doesn't exist negative factorial.")
    }
    else{
        aux = 1
        for(i in 1:n){
            
        }
    }
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

