setwd("C:\\Users\\cdac8824\\honours")

require(zoo)

hrs_stations<-read.csv("hrs_nearest_station.csv")

Station_id <- hrs_stations$station_number
#Station_id<-hrs_stations$station_number[1:3]
# read in a station
#datadir <- "Z:/Public/BOM_Stationdata/MergedUpToDateFiles"

#MaxT <- list()
#St_Rain <- list()

### PROBLEM WITH FILE NAMES ###

#for (i in 1:length(Station_id)) {
 # data <- read.csv(paste(datadir ,"/DC02D_Data_0",
  #                     Station_id[i],"_999999999142663.txt",sep="")) #not all files end with 142663

  #Dates <- paste(data$Year,data$Month,data$Day, sep="-")
  #MaxT[[i]] <- zoo(data[,10],order.by=as.Date(Dates))
  #St_Rain[[i]]<- zoo(data[,6],order.by=as.Date(Dates))
  # use window() to cut the right length

#}

## SOLUTION USING GREPL ##

which(grepl(Station_id[1], dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles"))) #for the first station

#attempt at "for loop"
for (i in 1:length(Station_id)) {
  which(grepl(Station_id[i], dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles")))
} #how to do this?

#another way
matches <- unique (grep(paste(Station_id,collapse="|"), 
                        dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles"), value=TRUE))
#> head(matches)
#[1] "DC02D_Data_009538_999999999142658.txt" "DC02D_Data_009624_999999999142658.txt"
#[3] "DC02D_Data_009904_999999999142658.txt" "DC02D_Data_009968_999999999142658.txt"
#[5] "DC02D_Data_009971_999999999142658.txt" "DC02D_Data_009980_999999999142658.txt"
#> head(Station_id)
#[1] 72000 72089 61415 60140 41533 40183

#or this?
which(sapply(Station_id, function(x) grepl(x, dir("Z:/Public/BOM_Stationdata/MergedUpToDateFiles"))))

#[1]   5413  12320  18652  25389  31310  37735  43353  54078  60986  67896  74749  82014  88663  95583 102230 109041
#[17] 115599 122445 129226 133420 140274 146948 153670 160527 167430 178999 185677 192749 199642 205700 212909 219653
#[33] 226541 233362 240242 247129 253960 261025 268098 274923 276758 283136 290031 296913 309920 310546 322093 328457
#[49] 335115 341162 348039 354702 361650 368597 375478 382284 389231 395275 402211 408885 415832 422777 429627 440612
#[65] 446705 453623 460516 467337 474281 481459 488219 495047 502181 509043 515504 517810 524187 530998

# Folder only has 6890 files??????

# combine
test <- merge(St_Rain[[1]],St_Rain[[2]],all=T)
names(test) <- Station_id