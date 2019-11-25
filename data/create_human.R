## Create a human
## IODS Data Wrangling Exercise 4
## Daniel Kawecki 25.11.2019

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
  new_names_hd <- c("hdi_rank","country","hdi","life_exp","exp_ed","mead_ed","gni","gni_hdi_diff")
  new_names_gii <- c("gii_rank","country","gii","mmr","abr","rep","seced_fem","seced_male","labour_fem","labour_male")

  colnames(hd)[1:8] <- new_names_hd
  colnames(gii)[1:10] <- new_names_gii


##New ratio variables
  #The ratio of females to males population percentages with secondary education
  gii <- mutate(gii, fm_secedrat = seced_fem / seced_male )
  #The ratio of females to males population percentages in the labour force
  gii <- mutate(gii, fm_labourrat = labour_fem / labour_male )


##Join the dataframes by country
  data_joined <- inner_join(x=hd,y=gii,by="country",suffix=c("hd","gii"))
  str(data_joined)
  #195 observations of 19 variables

##Save data
  write.table(data_joined, file = "data/human.csv", col.names = TRUE, sep = ";")
