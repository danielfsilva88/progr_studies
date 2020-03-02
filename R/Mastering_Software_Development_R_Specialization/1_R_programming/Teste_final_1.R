install.packages(c("dplyr", "tidyr", "readr", "readxl", "lubridate"))
#library(c("dplyr", "tidyr", "readr", "readxl", "lubridate"))
library("readr")
library("dplyr")
library("tidyr")
library("readxl")
library("lubridate")

origem <- getwd()
setwd("SEE/estudos_R/swirl_learning/quiz_data/")

# dados_1
d1 <- read_csv("data/daily_SPEC_2014.csv.bz2");
View(head(d1), "d1");

q1p <- d1[grepl("Bromine PM2.5 LC", d1$`Parameter Name`),] ; 
q1 <- q1p %>%
  filter(`State Name` == "Wisconsin") %>%
  summarise(media = mean(`Arithmetic Mean`, na.rm = TRUE))

q2 <- d1 %>%
  group_by(`Parameter Name`, `State Name`, `State Code`,
           `County Code`, `Site Num`, `Sample Duration`) %>%
  summarise(medias = mean(`Arithmetic Mean`, na.rm = TRUE))

q3 <- d1 %>%
  filter(`Parameter Name` %in% "Sulfate PM2.5 LC") %>%
  group_by(`State Name`, `State Code`, `County Code`,
           `Site Num`, `Sample Duration`) %>%
  summarise(medias = mean(`Arithmetic Mean`, na.rm = TRUE))

q4p <- d1 %>%
  filter(`State Name` %in% c("California", "Arizona") & 
           `Parameter Name` %in% "EC PM2.5 LC TOR") %>%
  group_by(`Parameter Name`, `State Name`) %>%
  summarise(medias = mean(`Arithmetic Mean`, na.rm = TRUE))
q4 <-  abs(q4p[2,3] - q4p[1,3])

q5 <- d1 %>%
  filter(`Parameter Name` %in% "OC PM2.5 LC TOR" &
           Longitude < -100) %>%
  group_by(`Sample Duration`) %>%
  summarise(median(`Arithmetic Mean`, na.rm = TRUE))

d2 <- read_xlsx("data/aqs_sites.xlsx");
View(head(d2), "d2");

q6 <- d2 %>%
  filter(`Land Use` %in% "RESIDENTIAL" &
           `Location Setting` %in% "SUBURBAN")

q7p <- d1 %>%
  filter(`Parameter Name` %in% "EC PM2.5 LC TOR" &
           Longitude >= -100) %>%
  mutate(`State Code` = as.numeric(`State Code`))
q7 <- left_join(q6, q7p, by=c("Latitude", "Longitude")) %>%
  group_by("Latitude", "Longitude") %>%
  summarise(median(`Arithmetic Mean`, na.rm = TRUE))

q8p1 <- d2 %>%
  select(Latitude, Longitude, `Land Use`) %>%
  filter(`Land Use` %in% "COMMERCIAL");
# abaixo com left_join leva a um resultado errado
q8 <- inner_join(d1, q8p1, by=c("Latitude", "Longitude")) %>%
  filter(`Parameter Name` %in% "Sulfate PM2.5 LC") %>%
  mutate(month = month(`Date Local`)) %>%
  group_by(month) %>%
  summarise(mean(`Arithmetic Mean`, na.rm = TRUE))


q9p1 <- d1 %>%
  filter(`State Code` == "06" & `County Code` == "065" & `Site Num` == "8001")
q9p2 <- q9p1 %>% 
  filter(`Parameter Name` %in% c("Sulfate PM2.5 LC", "Total Nitrate PM2.5 LC")) %>% 
  group_by(`Date Local`, `Parameter Name`) %>% 
  summarise(AM = mean(`Arithmetic Mean`))
q9 <- q9p2 %>%
  group_by(`Date Local`) %>% 
  summarise(Sum = sum(`AM`)) %>% 
  filter(`Sum` >= 10)

q10p1 <- d1 %>% 
  filter(`Parameter Name` %in% c("Sulfate PM2.5 LC", "Total Nitrate PM2.5 LC")) %>% 
  group_by(`State Code`, `County Code`, `Site Num`, `Date Local`, `Parameter Name`) %>% 
  summarise(AM = mean(`Arithmetic Mean`))
q10p2 <- q10p1 %>% 
  spread(key = `Parameter Name`, value = `AM`)
q10 <-  q10p2 %>%
  group_by(`State Code`, `County Code`, `Site Num`) %>%
  summarize(Cor = cor(`Sulfate PM2.5 LC`, `Total Nitrate PM2.5 LC`))

setwd(origem)
