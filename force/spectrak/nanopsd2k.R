library(ggplot2)
library(plyr)

# load data
psds <- read.table("npsdsk.csv",header=TRUE,sep=",")

# plot psd U
fig3 <- ggplot(data=psds,aes(kfrequency,Pxx,colour=spd))+geom_point()+scale_x_log10()+scale_y_log10()+xlab("wavenumber, 1/m")+ylab("PSD, (N or N-mm)^2/(1/m)")+facet_grid(treatname~from)
pdf("npsds2k.pdf")
print(fig3)
dev.off()



# alternative using grid faceting
#fig2 <- ggplot(data=covariances,aes(spd,cov,colour=modelname))+geom_point()+facet_grid(from ~ to)

# load and plot one-third octave-band data
tobs <- read.table("ntobk.csv",header=TRUE,sep=",",na.strings="nan")

fig5 <- ggplot(data=tobs,aes(x=as.factor(kcenterfreq),y=value,colour=spd,na.rm=TRUE))+geom_point()+geom_line(aes(group=spd))+scale_y_log10()+xlab("1/3 octave band center wavenumber, 1/m")+ylab("(N or N-mm)^2")+facet_grid(treatname~from)+opts(axis.text.x=theme_text(angle=-90,hjust=0))
pdf("ntobk.pdf")
print(fig5)
dev.off()


