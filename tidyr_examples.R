rm(list=ls())
gc(verbose=TRUE, full=TRUE)
.rs.restartR()
cat("\014")

require(tidyr)

df <- data.frame(month=rep(1:3,2),
                 student=rep(c("Amy", "Bob"), each=3),
                 A=c(9, 7, 6, 8, 6, 9),
                 B=c(6, 7, 8, 5, 6, 7))

df %>% 
  gather(variable, value, -(month:student)) %>%
  unite(temp, student, variable) %>% 
  spread(temp, value)


my_data <- USArrests[c(1, 10, 20, 30), ]
my_data <- cbind(state = rownames(my_data), my_data)
my_data

my_data2 <- gather(my_data,
                   key = "arrest_attribute",
                   value = "arrest_estimate",
                   -state)
my_data2
