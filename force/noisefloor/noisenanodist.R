library(ggplot2)
library(plyr)

# load data
means <- read.table("nmeans.csv",header=TRUE,sep=",")
covariances <- read.table("ncovariances.csv",header=TRUE,sep=",")

# plot anemometer means
fig1 <- ggplot(data=means,aes(spd,mean,colour=spd,shape=treatname))+geom_point()+facet_wrap(~ channel)+xlab("motor setting")+ylab("force, N or torque N-mm")
pdf("nmeans.pdf")
print(fig1)
dev.off()

# plot anemometer covariances
fig2 <- ggplot(data=covariances,aes(spd,cov,colour=spd,shape=treatname))+geom_point()+facet_grid(from ~ to)+xlab("motor setting")+ylab("cov(force or torque)")
pdf("ncovariances.pdf")
print(fig2)
dev.off()



