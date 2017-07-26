setwd("C:\\Users\\Clara\\Documents\\honours")

require(zoo)

hrs_stations<-read.csv("hrs_nearest_station.csv")

Station_id <- hrs_stations$station_number

Data1 <- vector()
for (i in 1:length(Station_id)){ 
  Data1[i] <- which(grepl(Station_id[i], dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles"))) #for the first station
}

Dir1 <- dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles")

Dir2 <- Dir1[Data1]

MaxT <- list()
St_Rain <- list()

for (i in 1:length(Station_id)) {
  data <- read.csv(paste("Z:/Public/BOM_Stationdata/MergedUpToDateFiles",Dir2[i],sep="/")) 
  Dates <- paste(data$Year,data$Month,data$Day, sep="-")
  MaxT[[i]] <- window(zoo(data[,10],order.by=as.Date(Dates)), start = as.Date("1970-01-01"), end = as.Date("2010-12-31"))
  St_Rain[[i]]<- window(zoo(data[,6],order.by=as.Date(Dates)), start = as.Date("1970-01-01"), end = as.Date("2010-12-31"))  # use window() to cut the right time frame
}

saveRDS(MaxT, 'MaxT.Rds')
saveRDS(St_Rain, 'St_Rain.Rds')

# combine MaxT for all stations

MaxT<-readRDS('MaxT.Rds')
St_Rain<-readRDS('St_Rain.Rds')
#checking empty columns
t<-sapply(MaxT, function(x) {
  t <- table(is.na(x))
  num_t <- t['TRUE']
  ifelse(num_t, num_t/sum(t), 0)
})
table(t==1)

test<-do.call(merge, MaxT)

names(test) <- Station_id[sapply(MaxT, length) > 0]
test2<-as.data.frame(test)

# combine St_Rain for all stations
s<-sapply(St_Rain, function(x) {
  s <- table(is.na(x))
  num_s <- s['TRUE']
  ifelse(num_s, num_s/sum(s), 0)
})
table(s==1) #check for lists that are NAs only


test3<-do.call(merge, St_Rain) 
names(test3) <- Station_id[sapply(St_Rain, length) > 0]

test4<-as.data.frame(test3)
