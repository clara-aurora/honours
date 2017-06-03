
#
setwd("C:\\Users\\Clara\\Google Drive\\Honours")

Today <- format(Sys.Date(),"%Y%m%d")
library(oz)
# MAP STATIONS # #####
Stations <- read.csv("agricultural.csv")
Stations1 <- read.csv("forested.csv")
Stations2 <- read.csv("mixed.csv")
# production quality
tiff(paste(Today,"_Figure1_MapOZMDPaper.tif",sep=""),res=600,compression="lzw",
     width=10*480,height=10*480)
# quicktiff
# tiff(paste(Today,"_DraftMapOZ.tif",sep=""),
#      width=960,height=960)
oz(col="gray",lwd=2)
points(Stations$Long, Stations$Lat, pch = 1, cex=1)
points(Stations1$Long, Stations1$Lat, pch = 16, cex=1)
points(Stations2$Long, Stations2$Lat, pch = 4, cex=1)
legend("topleft", legend=c("Agricultural", "Forested", "Mixed"), bty="n", pch=c(1,16,4))
#text(x=Stations$Long,y=Stations$Lat,Station$Station, cex=0.8, pos=c(2,4,4,4,4,4,4,2,4,2,4,2,2), offset=0.2)
dev.off()
#####
