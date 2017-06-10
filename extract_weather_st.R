setwd("C:\\Users\\Clara\\Documents\\honours")

library(sp)
library(rgeos)

hrs<-read.csv("allstations.csv")
hrs<-hrs[,c(1, 2, 3, 4, 5, 6, 8, 7)] #switch lat and long columns to be same order as stations.csv
stations<-read.csv("stations1.csv")

hrs_sp<-SpatialPoints(hrs[,7:8]) #just lat long columns
stations_sp<-SpatialPoints(stations[,7:8])
hrs$nearest_station<-apply(gDistance(stations_sp, hrs_sp, byid=TRUE), 1, which.min) #gives me a column with row numnbers of nearest station

#get station names

rn<-hrs$nearest_station #create vector with row numbers of required stations
test<-stations[rn,] #create dataframe of required stations only

#add weather station information to hrs dataframe
hrs$station_name<-test$Station.Name
hrs$lat<-test$Latitude.to.4.decimal.places.in.decimal.degrees
hrs$long<-test$Longitude.to.4.decimal.places.in.decimal.degrees
hrs$station_number<-test$Bureau.of.Meteorology.Station.Number

#export information
write.table(hrs, "hrs_nearest_station.txt", sep="\t")
