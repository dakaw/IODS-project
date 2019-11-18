# IODS Exercise 3
# Daniel Kawecki 16.11.2019
# Data on student performance and alcohol consumtion from https://archive.ics.uci.edu/ml/datasets/Student+Performance

# access the dplyr library
library(dplyr)

# First task. Read and describe the data material.
  data_mat = read.table("data/student-mat.csv", header = TRUE, sep = ";") #Students in math course
  data_por = read.table("data/student-por.csv", header = TRUE, sep = ";") #Studends in portugese language course
  str(data_mat)
    #The data contains 395 observations of 33 variables related to the students life, health, school results and alcohol consumtion
  str(data_por)
    #The data contains 649 observations of the same 33 variables as the previous set.

# Second task, join data from two tables according to the list of columns used to identify the same students.

  #Column namns to identify same students in both tables
    join_cols <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

  #Joins data from both tables where all the columns match. The rest of the observations are dropped.
    joined_data <- inner_join(data_mat, data_por, by = join_cols, suffix = c(".mat",".por"))
    
  #Describe the joined dataframe
    str(joined_data)
    # We now have 382 observation with 53 variables. All columns except the joined columns appear twice with a suffix telling what dataframe they originated from
    
# Third task, combine duplicate data

  # We need to know which columns in the dataframes were not used for joining the data. These are the ones that appear twice in the joined data.
    notjoined_columns <- colnames(data_mat)[!colnames(data_mat) %in% join_cols]

  # Then we create a new dataframe with only the combined columnes
    alc <- select(joined_data, one_of(join_cols))
  
  # Then, we loop through all the dublicate columns. If the value is numeric, we add the mean value of both columns to the new data frame.
  # Else, we add the value from the first column. The loop is copied from the DataCamp exercise.
    for (column_name in notjoined_columns) {
      # select two columns from 'joined_data' with the same original name
      two_columns <- select(joined_data, starts_with(column_name))
      # select the first column vector of those two columns
      first_column <- select(two_columns, 1)[[1]]  
       # if that first column vector is numeric...
        if(is.numeric(first_column)) {
          # take a rounded average of each row of the two columns and
          # add the resulting vector to the alc data frame
          alc[column_name] <- round(rowMeans(two_columns))
        } else { # else if it's not numeric...
          # add the first column vector to the alc data frame
          alc[column_name] <- first_column
      }
    }
  #The structure of the data is back to the original 33 variables.
    str(alc)
  
#  Fourth task, alcohol use
    # Make new column with avarage alcohol use from weekend and weekday use
      alc <- mutate(alc, alc_use = (Dalc + Walc)/2)
    # Make new column with value TRUE if alcohol use is more than 2
      alc <- mutate(alc, high_use = alc_use > 2)
      
      
# Glimpse and save
  glimpse(alc)
    # The data has 382 observations and 35 variables including alc_use and high_use. Everything seems ok.
  # Write data to file
  write.table(alc, file = "data/alc.csv", sep =";")
  
### End of exercise
  