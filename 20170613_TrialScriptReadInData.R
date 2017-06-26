setwd("C:\\Users\\cdac8824\\honours")

require(zoo)

hrs_stations<-read.csv("hrs_nearest_station.csv")

Station_id <- hrs_stations$station_number[7:17]
#Station_id<-hrs_stations$station_number[1:3]
# read in a station
datadir <- "Z:/Public/BOM_Stationdata/MergedUpToDateFiles"

MaxT <- list()
St_Rain <- list()


for (i in 1:length(Station_id)) {
  data <- read.csv(paste(datadir ,"/DC02D_Data_0",
                       Station_id[i],"_999999999142663.txt",sep="")) #not all files end with 142663

  Dates <- paste(data$Year,data$Month,data$Day, sep="-")
  MaxT[[i]] <- zoo(data[,10],order.by=as.Date(Dates))
  St_Rain[[i]]<- zoo(data[,6],order.by=as.Date(Dates))
  # use window() to cut the right length

}

# combine
test <- merge(St_Rain[[1]],St_Rain[[2]],all=T)
names(test) <- Station_id