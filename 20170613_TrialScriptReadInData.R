setwd("C:\\Users\\Clara\\Documents\\honours")

require(zoo)

hrs_stations<-read.csv("hrs_nearest_station.csv")

Station_id <- hrs_stations$station_number

Data1 <- vector()
for (i in 1:length(Station_id)){ 
  Data1[i] <- which(grepl(Station_id[i], dir("Y:/Public/BOM_Stationdata/MergedUpToDateFiles"))) #for the first station
}

Dir1 <- dir("Y:/Public/BOM_Stationdata/MergedUpToDateFiles")

Dir2 <- Dir1[Data1]

MaxT <- list()
St_Rain <- list()

for (i in 1:length(Station_id)) {
  data <- read.csv(paste("Y:/Public/BOM_Stationdata/MergedUpToDateFiles",Dir2[i],sep="/")) 
  Dates <- paste(data$Year,data$Month,data$Day, sep="-")
  MaxT[[i]] <- window(zoo(data[,10],order.by=as.Date(Dates)), start = as.Date("1970-01-01"), end = as.Date("2010-12-31"))
  St_Rain[[i]]<- window(zoo(data[,6],order.by=as.Date(Dates)), start = as.Date("1970-01-01"), end = as.Date("2010-12-31"))  # use window() to cut the right time frame
}

saveRDS(MaxT, 'MaxT.Rds')

# combine MaxT for all stations

MaxT<-readRDS('MaxT.Rds')

#checking empty columns
t<-sapply(MaxT, function(x) {
  t <- table(is.na(x))
  num_t <- t['TRUE']
  ifelse(num_t, num_t/sum(t), 0)
})
table(t==1)

test<-do.call(merge, MaxT) #give me "Large zoo" not dataframe

names(test) <- Station_id[!is.na(t)]
test2<-as.data.frame(test)
