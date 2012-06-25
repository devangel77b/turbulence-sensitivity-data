library(reshape2)

# load data
ameans <- read.table("../../flow/distribution/ameans.csv",header=TRUE,sep=",")
nmeans <- read.table("../../force/distribution/nmeans.csv",header=TRUE,sep=",")
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")

# subset and cast ameans
ameans <- ameans[,c(3,5,6,8)]
ameans <- dcast(ameans,treatname+spd~channel,mean)

# subset and cast nmeans
nmeans <- nmeans[,c(1,2,3,5,6,8)]
nmeans <- dcast(nmeans,run+modelname+treatname+spd~channel,mean)

# merge anemometer and force/torque measurements
allmeans <- merge(nmeans,ameans,by=c("treatname","spd"))
droplevels(allmeans)
meltmeans <- melt(allmeans,id=c("run","modelname","treatname","spd"))

# cleanup
rm(ameans)
rm(nmeans)

# make plot
