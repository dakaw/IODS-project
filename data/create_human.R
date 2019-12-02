## Create a human
## IODS Data Wrangling Exercise 4
## Daniel Kawecki 25.11.2019

# access the dplyr library
library(dplyr)

##Read data
  hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
  gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

##Explore data
  
  #Human development index
    str(hd)
    summary(hd)
    # The HD dataframe contains variables about the level and ranking of human development index (hdi) 
    # and the gross national income per capita (gni) in 195 countrie, and about expected and mean years of education.

  #Gender inequality index
    str(gii)
    summary(gii)
    # The GII dataframe contains variables about the rank and level of tge Gender Inequality Index (gii) in 195 countries.
    # Furthermore, the variables cover issues related to gender equality: maternal mortality ratio, adolescent birth rate,
    # percent woumen in parliment and the proportions of the male and female population with secondary education and 
    # within the labour force.
    
##Rename columns
  new_names_hd <- c("HDI.Rank","Country","HDI","Life.Exp","Edu.Exp","Edu.Mean","GNI","GNI.Minus.Rank")
  new_names_gii <- c("GII.Rank","Country","GII","Mat.Mor","Ado.Birth","Parli.F","Edu2.F","Edu2.M","Labo.F","Labo.M")

  colnames(hd)[1:8] <- new_names_hd
  colnames(gii)[1:10] <- new_names_gii

##New ratio variables
  #The ratio of females to males population percentages with secondary education
  gii <- mutate(gii, Edu2.FM = Edu2.F / Edu2.M)
  #The ratio of females to males population percentages in the labour force
  gii <- mutate(gii, Labo.FM = Labo.F / Labo.M)


##Join the dataframes by country
  human <- inner_join(x=hd,y=gii,by="Country",suffix=c("hd","gii"))
  str(human)
  #195 observations of 19 variables

##Save data
  write.table(human, file = "data/human.csv", col.names = TRUE, sep = ";")

  
##DATA WRANGLING EXERCISE 5 BEGINS HERE

  
## Replace commas in hdi
  library(stringr)  # access the stringr package
  human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
  
## Exclude unnecessary columns and rows with missing values
  keep <- c("Country", "Edu2.FM","Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
  human <- select(human,one_of(keep))
  #Filter out incomplete cases
  human_ <- filter(human, complete.cases(human) == TRUE)
  str(human_) #162 complete cases remaining
  
#Remove regions
  human_$Country #Last seven observations are regions
  human_ <- human_[1:(nrow(human_)-6), ]
  str(human_) #155 complete cases remaining
  
#Set Country as row name
  rownames(human_) <- human_$Country
  human_ <- select(human_,-Country)
  head(human_);str(human_) #Country as row name, 155 observations, 8 variables. 
  
#Create data file
  write.table(human_, file = "data/human2.csv", col.names = TRUE, sep = ";")
  