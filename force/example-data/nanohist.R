library(ggplot2)
library(reshape)


# load data
melteddata <- read.table("nhistdata.csv",header=TRUE,sep=",")

# recast data?
castdata <- cast(melteddata,...~ channel)

# make a histogram
fig4 <- ggplot(data=melteddata,aes(value,fill=as.factor(spd)))+geom_density(alpha=0.2)+facet_wrap(~ channel,scales="free")

# save it
pdf("nanohist.pdf")
print(fig4)
dev.off()




