setwd("C:\\Users\\fvanogtrop.MCS\\Documents\\honours")
flow<-read.csv("C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\Rivers\\116010A.csv")
temp<-read.csv("C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\Climate\\Climate\\MaxT_116010A.csv")
rain<-read.csv("C:\\Users\\fvanogtrop.MCS\\Documents\\honours\\Climate\\Climate\\Rain_116010A.csv")

#change date format
flow$Date<-as.Date(as.character(flow$Date), "%m/%d/%Y")
flow$Date<-format(flow$Date, "%d/%m/%Y")

temp$time <- format(as.Date(temp$time), "%d/%m/%Y")
rain$time <- format(as.Date(rain$time), "%d/%m/%Y")

flow.1970 <- subset(flow, Date > as.Date("01/01/1970"))

flow.1970 <- flow[(flow$Date> "01/01/1970"),]
