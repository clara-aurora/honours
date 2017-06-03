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

library(doSNOW)
cl <- makeCluster(4) #Running 4 parallel processes at a time
registerDoSNOW(cl)
# run the foreach loop
Store<- foreach(i=8:9, #folders with decades required
                 .packages=c("raster","rgdal")) %dopar% {    

  # read in the list of years
  Years <- dir(paste("Daily-rainfall/",decades[i],sep=""))
  yearlist <- list()
  
  for (j in 1:length(Years)) {
    # read the grids
    files= list.files(paste("Daily-rainfall/",decades[i],"/",Years[j],sep=""),pattern=".txt", full.names=TRUE)
    # stack the grids
    s <- stack(files) #TAKES AGES ON MY LAPTOP
    # extract the stations
    df <- extract(s, SpatialPoints(points[,c("Long", "Lat")],
              proj4string=CRS("+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs")), 
              df=TRUE, method='simple')
    # store in the list
    yearlist[[j]] <- df
  }
  yearlist
}
stopCluster(cl)

#TESTED UP TO HERE#

output1 <- list()
# otherwise
for (i in 1:(length(decades)-1)) {
  output1[[i]] <- do.call(cbind,Store[[i]])
}

#remove ID column
for (i in 1:(length(decades)-1)) {
  remove <- grep("ID",names(output1[[i]]))
  output1[[i]] <- output1[[i]][,-as.numeric(remove)]
}

output2 <- t(do.call(cbind,output1))
# make into zoo data frame
require(zoo)
output.z <- zoo(output2,order.by=seq.Date(as.Date("1900-01-01"),length=nrow(output2),by="days"))
# save as an Rdata file`
save(output.z,file="h:/willem/teaching/afnr5512/pracs/8. WRSI practical/GriddedRainfallData.Rdata")
