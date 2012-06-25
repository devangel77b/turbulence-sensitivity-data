library(ggplot2)
library(plyr)

# load data
means <- read.table("ameans.csv",header=TRUE,sep=",")
covariances <- read.table("acovariances.csv",header=TRUE,sep=",")

# plot anemometer means
fig1 <- ggplot(data=means,aes(spd,mean,colour=spd,shape=treatname))+geom_point()+facet_wrap(~ channel)+xlab("motor setting")+ylab("velocity, m/s")
pdf("ameans.pdf")
print(fig1)
dev.off()

# plot anemometer covariances
fig2 <- ggplot(data=covariances,aes(spd,cov,colour=spd,shape=treatname))+geom_point()+facet_grid(from ~ to)+xlab("motor setting")+ylab("cov(velocity) (m/s)^2")
pdf("acovariances.pdf")
print(fig2)
dev.off()



