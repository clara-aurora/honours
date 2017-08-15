# dfs is a list of data.frames.
# You can generate this by reading all the csv files from a directory

setwd('C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\Rivers')

file_names <- dir('.')
dfs <- lapply(file_names, read.csv)

# this is just an example
dfs <- list(
  data.frame(date=c('1984/05/27','1984/05/28'), flow=c(10,20)),
  data.frame(date=c('1984/05/26','1984/05/27'), flow=c(30,40))
)

library(zoo)
dfs.zoo <- lapply(dfs, function(x) {
  zoo(x[,'Flow_ML'], as.Date(x[,'Date']))
})

all <- do.call(merge, dfs.zoo)

# you can set the name of the columns to the filename
# colnames(all) <- file_names
str(dfs)

