setwd("C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\Climate\\Climate")
dir()
station.dat <- read.csv("C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\selected_hrs_new.csv")

for(i in 1:NROW(station.dat)){
download.file(paste("http://dapds00.nci.org.au/thredds/ncss/rr9/eMAST_data/ANUClimate/ANUClimate_v1-0_rainfall_daily_0-01deg_1970-2014?var=lwe_thickness_of_precipitation_amount&latitude=",station.dat$Lat[i],"&longitude=",station.dat$Long[i],"&time_start=1970-01-01T00%3A00%3A00Z&time_end=2014-12-31T00%3A00%3A00Z&accept=csv_file", sep = ""),
              paste("Rain_", station.dat$ID[i], ".csv", sep = ""))
}

for(i in 1:NROW(station.dat)){
download.file(paste("http://dapds00.nci.org.au/thredds/ncss/rr9/eMAST_data/ANUClimate/ANUClimate_v1-1_temperature-max_daily_0-01deg_1970-2014?var=air_temperature&latitude=",station.dat$Lat[i],"&longitude=",station.dat$Long[i],"&time_start=1970-01-01T00%3A00%3A00Z&time_end=2014-12-31T00%3A00%3A00Z&accept=csv_file", sep = ""),
              paste("MaxT_", station.dat$ID[i], ".csv", sep = ""))
}


