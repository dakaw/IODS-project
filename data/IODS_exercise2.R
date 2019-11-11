# 09-11-2019. Exercise 2 in IODS. Daniel Kawecki.

# Access the dplyr library
library(dplyr)
library(GGally)
library(ggplot2)

#Load data with first row as column headers and tab as separator
  learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE, sep = "\t")

#Explore the loaded dataset
  dim(learning2014)
  str(learning2014)
  #Results return 183 rows and 60 columns of data. The first 59 data types are integers, the last one is a two level factor (gender) with values 1="F" and 2="M"

# Create an analysis dataset
  # Taking code from DataCamp exercises to define which questions are related to deep, surface and strategic learning
    deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
    surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
    strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
  
  #Select the columns and add the mean values of each row as a new column to the dataset:
    deep_columns <- select(learning2014, one_of(deep_questions)) #Select deep learning columns
      learning2014$deep <- rowMeans(deep_columns) #Add row means as new column to the main data set
    surface_columns <- select(learning2014, one_of(surface_questions)) #Select surface learning columns
      learning2014$surf <- rowMeans(surface_columns) #Add row means as new column to the main data set
    strategic_columns <- select(learning2014, one_of(strategic_questions)) #Select strategic learning columns
      learning2014$stra <- rowMeans(strategic_columns) #Add row means as new column to the main data set
  
  # choose which column to keep for a smaller analysys dataset
    keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
  # Create new dataset from the columns while at the same time filtering out rows with zero points
    lrn2014 <- filter(select(learning2014, one_of(keep_columns)), Points > 0)
    # fix column names to lower case
    colnames(lrn2014)[c(2,3,7)] <- c("age", "attitude", "points")

# Write dataset to data directory, then read again to verify
  write.table(lrn2014, file = "data/analysis_lrn2014.csv", sep = ";")
  str(read.table("data/analysis_lrn2014.csv", sep = ";"))
  # Output shows the correct dimensions (166 obs. of 7 varables)  
