## Extract rainfall for the grid points
# from BOM gridded data 
library(zoo)
library(raster)
library(rgdal)

setwd("Z:\\Public\\BOM_GriddedRainfallData\\")

# read in the list of decades
decades <- dir("Daily-rainfall", pattern="rainfall_")

# store to put data in
Store <- list()

# Some test stations
stations <- read.csv("C:\\Users\\cdac8824\\Documents\\honours\\allstations.csv")# should be in decimal degrees and long first and then lat
points <- stations

# Willem's method
# library(doSNOW)
# cl <- makeCluster(4) #Running 4 parallel processes at a time
# registerDoSNOW(cl)
# # run the foreach loop
# Store<- foreach(i=8:9, #folders with decades required
#                  .packages=c("raster","rgdal")) %dopar% {    
# 
#   # read in the list of years
#   Years <- dir(paste("Daily-rainfall/",decades[i],sep=""))
#   yearlist <- list()
#   
#   for (j in 1:length(Years)) {
#     # read the grids
#     files= list.files(paste("Daily-rainfall/",decades[i],"/",Years[j],sep=""),pattern=".txt", full.names=TRUE)
#     # stack the grids
#     s <- stack(files) #TAKES AGES ON MY LAPTOP
#     # extract the stations
#     df <- extract(s, SpatialPoints(points[,c("Long", "Lat")],
#               proj4string=CRS("+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs")), 
#               df=TRUE, method='simple')
#     # store in the list
#     yearlist[[j]] <- df
#   }
#   yearlist
# }
# stopCluster(cl)

#Alternate method
library(doSNOW)
cl <- makeCluster(4) #Running 4 parallel processes at a time
registerDoSNOW(cl)
# run the foreach loop
Store<- foreach(i=8:12, #folders with decades required
                   .packages=c("raster","rgdal")) %dopar% {
  
  # read in the list of years
  Years <- dir(paste("Daily-rainfall/",decades[i],sep=""))

  # for (j in 1:length(Years)) {
  yearlist <- lapply(1:length(Years), function(j) {
    # read the grids
    files= list.files(paste("Daily-rainfall/",decades[i],"/",Years[j],sep=""),pattern=".txt", full.names=TRUE)
    # stack the grids
    s <- stack(files)
    # extract the stations
    df <- try(extract(s, SpatialPoints(points[,c("Long", "Lat")],
                                   proj4string=CRS("+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs")), 
                  df=TRUE, method='simple'))
    # store in the list
    if ( class(df) == 'try-error') return(NULL) else df #to find failures if any
  })
  yearlist
                   }

#Check if any df return NULL
lapply(Store,function(x) {
  sapply(x, function(y) {
    is.null(y)
  })
})
output1 <- list() #makes empty list

#Store is a list of lists of dataframes
for (i in 1:(length(Store))) {
  output1[[i]] <- do.call(cbind,Store[[i]]) #combines years in decade into one df
}

#remove ID column
for (i in 1:(length(Store))) {
  remove <- grep("ID",names(output1[[i]])) #gets rid of repeated station names
  output1[[i]] <- output1[[i]][,-as.numeric(remove)]
}

output2 <- t(do.call(cbind,output1)) #combines all decades in one df

# make into zoo data frame
require(zoo)

first_day <- as.Date(rownames(output2)[1], 'r%Y%m%d')

output.z <- zoo(output2,order.by=seq.Date(first_day,length=nrow(output2),by="days")) #change date format

# save as an Rdata file`
# save(output.z,file="h:/willem/teaching/afnr5512/pracs/8. WRSI practical/GriddedRainfallData.Rdata")
saveRDS(output.z, 'griddedrainfall.Rds')
