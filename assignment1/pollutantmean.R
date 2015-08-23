getdata <- function(directory, id) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a consolidated data frame containing data from all
  ## indicated files
  
  ## get the full names of all CSV files in the directory
  ## ASSUME the directory has CSV files in it
  ## ASSUME full_files will have 1+ entries
  full_files <- list.files(directory, pattern = "[.]csv$", full.names = T, ignore.case = T)
  
  ## read in the indicated files
  ## ASSUME that indices match id file names
  ## ASSUME indices in range of size of full_files
  l <- lapply(full_files[id], read.csv)
  
  ## consolidate the list of data frames into a single new data frame
  ## and return it
  do.call(rbind, l)
}

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  ## NOTE: Do not round the result!
  
  data <- getdata(directory, id)
  mean(data[,pollutant], na.rm = T)
}
