#### WC 1 ####
# Add a `dplyr` or `tidyr` function to the pipe chain in the code 
# at the bottom of this script to subset the `worldcup` dataset to 
# four columns, so that the first lines of the resulting data 
# frame (`wc_1`) look like this: 
#
##           Time   Passes  Tackles Saves
## Abdoun      16        6        0     0
## Abe        351      101       14     0
## Abidal     180       91        6     0
## Abou Diaby 270       111       5     0
#
# I have already loaded the `worldcup` data frame for you, so you 
# can explore it and test out your code in the console.
#
# When you are ready submit your answer, save the script and type 
# submit(), or type reset() to reset the script to its original 
# state. 

wc_1 <- worldcup %>% 
  select(Time,Passes,Tackles,Saves)

#### WC 2 ####
# After the previous question, you should have transformed the 
# `worldcup` data to look like this:
#
##           Time   Passes  Tackles Saves
## Abdoun      16        6        0     0
## Abe        351      101       14     0
## Abidal     180       91        6     0
## Abou Diaby 270       111       5     0
#
# Now add a `dplyr` or `tidyr` function to the pipe chain in the 
# code at the bottom of this script so that `wc_2` data frame looks 
# like this, with four columns, and a single observation (the 
# mean value of each variable): 
#
##       Time   Passes  Tackles     Saves
##   208.8639 84.52101 4.191597 0.6672269
#
# I have already loaded the `worldcup` data frame for you, so you 
# can explore it and test out your code in the console.
#
# When you are ready submit your answer, save the script and type 
# submit(), or type reset() to reset the script to its original 
# state. 

wc_2 <- worldcup %>% 
  select(Time, Passes, Tackles, Saves) %>%
  summarize(Time=mean(Time), Passes=mean(Passes), Tackles = mean(Tackles), Saves=mean(Saves))
  
#### WC 3 ####
# After the previous question, you should have transformed the 
# `worldcup` data to look like this:
#
##       Time   Passes  Tackles     Saves
##   208.8639 84.52101 4.191597 0.6672269
#
# Now add a `dplyr` or `tidyr` function to the pipe chain in the 
# code at the bottom of this script so that the `wc_3` data frame looks 
# like this, with variable names in one column and the mean value
# of each variable in another column: 
#
##      var           mean
##     Time    208.8638655
##   Passes     84.5210084
##  Tackles      4.1915966
##    Saves      0.6672269
#
# I have already loaded the `worldcup` data frame for you, so you 
# can explore it and test out your code in the console.
#
# When you are ready submit your answer, save the script and type 
# submit(), or type reset() to reset the script to its original 
# state. 

wc_3 <- worldcup %>% 
  select(Time, Passes, Tackles, Saves) %>%
  summarize(Time = mean(Time),
            Passes = mean(Passes),
            Tackles = mean(Tackles),
            Saves = mean(Saves)) %>%
  gather(key = var, value=mean)

#### WC 4 ####
# After the previous question, you should have transformed the `worldcup`
# data to look like this:
#
##      var           mean
##     Time    208.8638655
##   Passes     84.5210084
##  Tackles      4.1915966
##    Saves      0.6672269
#
# Now add a `dplyr` or `tidyr` function to the pipe chain in the 
# code at the bottom of this script so that the `wc_4` data frame looks 
# like this, with variable means rounded to one decimal place: 
#
##      var     mean
##     Time    208.9
##   Passes     84.5
##  Tackles      4.2
##    Saves      0.7
#
# I have already loaded the `worldcup` data frame for you, so you 
# can explore it and test out your code in the console.
#
# When you are ready submit your answer, save the script and type 
# submit(), or type reset() to reset the script to its original 
# state. 

wc_4 <- worldcup %>% 
  select(Time, Passes, Tackles, Saves) %>%
  summarize(Time = mean(Time),
            Passes = mean(Passes),
            Tackles = mean(Tackles),
            Saves = mean(Saves)) %>%
  gather(var, mean) %>%
  mutate(mean = round(mean,1))
