library(ggplot2)
library(plyr)

# load data
psds <- read.table("apsds.csv",header=TRUE,sep=",")

# plot psd U
fig3 <- ggplot(data=psds,aes(frequency,Pxx,colour=spd,shape=treatname))+geom_point()+scale_x_log10()+scale_y_log10()+xlab("frequency, Hz")+ylab("PSD, (m/s)^2/Hz")+facet_grid(treatname~from)
pdf("apsds.pdf")
print(fig3)
dev.off()



# alternative using grid faceting
#fig2 <- ggplot(data=covariances,aes(spd,cov,colour=modelname))+geom_point()+facet_grid(from ~ to)




