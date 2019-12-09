## Meet and repead
## IODS Data Wrangling Exercise 6
## Daniel Kawecki 08.12.2019

# Access the packages dplyr and tidyr
  library(dplyr)
  library(tidyr)

## Load datasets

  ## BPRS
    BPRS <- read.table(file = "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = T)
    str(BPRS)
    
    # The dataset has two categorical variables (treatment, subject) that will be converted to factors.
      BPRS$treatment <- factor(BPRS$treatment)
      BPRS$subject <- factor(BPRS$subject)
      
    # Then the data is converted into long format
      BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
      
    # Instead of a column for each weeks, observations are now represented as keys and values in two separate columns. 
    # A new columns where week is represented by an integer will be added
      BPRSL <- mutate(BPRSL, week = as.integer(substr(weeks,5,5))) #week is created by extracting the fifth character position from the weeks value.
      head(BPRSL)
      tail(BPRSL)
      # Worked!
      
  ## RATS  
  RATS <- read.table(file = "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)
  str(RATS)
  
  # The dataset has two categorical variables (ID and Group) that will be converted to factors.
    RATS$ID <- factor(RATS$ID)
    RATS$Group <- factor(RATS$Group)
  
  
  # Then the data is converted into long format, columns ID and Group are excluded
    RATSL <- RATS %>% gather(key = days, value = weight, -ID, -Group)
  
  # Instead of a column for each observation day, observations are now represented as keys and values in two separate columns. 
  # A new column, time, where the day of the obseration are represented by an integer will be added
    RATSL <- mutate(RATSL, time = as.integer(substr(days,3,4))) #week is created by extracting the fifth character position from the weeks value.
    head(RATSL)
    tail(RATSL)
  # Worked!
    
    
  ## Why the long format?
    # First, it seems to be a practical question. If all observation are taken at the exact same times, wide or long format don't matter
    # when storing the data. But if observations for each unit are taken at more random intervals, it makes no sense to have a column
    # for each point in time. Instead, the long format where unit, time and value are registered separaterly makes more sense. In the above
    # cases we only have fixed observation times.
    
    # Second, the format has practical implications when doing different types of analysis. When data is in the long format, it is easy
    # to use the observation time as a variable value. This is useful when for example visualising longitudinal data using the time 
    # variable on the x axis and the value on the y axis.

  ## Writing the data to disk
    write.table(BPRSL, file = "data/bprsl.csv", col.names = T, sep = ";")
    write.table(RATSL, file = "data/ratsl.csv", col.names = T, sep = ";")
