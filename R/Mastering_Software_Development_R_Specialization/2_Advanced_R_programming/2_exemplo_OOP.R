## Read in the data
library(readr)
library(magrittr)
#setwd("C:/Users/dferreira/Documents") #-> origem
setwd("SEE/estudos_R/Curso_advanced_R_programming/")
getwd()

## Load any other packages that you may need to execute your code
data <- read_csv("C:/Users/dferreira/Documents/SEE/estudos_R/Curso_advanced_R_programming/2_data/data/MIE.csv")

source("Submission/2_oop_code.R")

# S3 first
sink("Submission/2_oop_output.txt")
x <- make_LD_S3(data) # ok
x <- make_LD_S4(data) 
x <- make_LD_RC(data) 
print(class(x)) 
print(x)        

## Subject 10 doesn't exist
out <- subject(x, 10)  
print(out)            

out <- subject(x, 14)  
print(out)             

out <- subject(x, 54) %>% summary 
print(out)                        

out <- subject(x, 14) %>% summary 
print(out)                        

out <- subject(x, 44) %>% visit(0) %>% room("bedroom") 
print(out)                                             

## Show a summary of the pollutant values
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary 
print(out)                                                         

out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary 
print(out)                                                             

sink()
