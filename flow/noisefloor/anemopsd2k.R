library(ggplot2)
library(plyr)

# load data
psds <- read.table("apsdsk.csv",header=TRUE,sep=",")

# plot psd U
fig3 <- ggplot(data=psds,aes(kfrequency,Pxx,colour=spd,shape=treatname))+geom_point()+scale_x_log10()+scale_y_log10(limits=c(1e-7,1e-1))+xlab("wavenumber, 1/m")+ylab("PSD, (m/s)^2/(1/m)")+facet_grid(treatname~from)
pdf("apsdsk2.pdf")
print(fig3)
dev.off()



# alternative using grid faceting
#fig2 <- ggplot(data=covariances,aes(spd,cov,colour=modelname))+geom_point()+facet_grid(from ~ to)


# load and plot one-third-octave-band data
tobs <- read.table("atobk.csv",header=TRUE,sep=",",na.strings="nan")

fig5 <- ggplot(data=tobs,aes(x=as.factor(kcenterfreq),y=value,colour=spd,na.rm=TRUE))+geom_point()+geom_line(aes(group=spd))+scale_y_log10(limits=c(1e-8,1e-1))+xlab("1/3 octave band center wavenumber, 1/m")+ylab("(m/s)^2")+facet_grid(treatname~from)+opts(axis.text.x=theme_text(angle=-90,hjust=0))
pdf("atobk.pdf")
print(fig5)
dev.off()

