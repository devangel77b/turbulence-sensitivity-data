library(ggplot2)

# load psd data
psd <- read.table("mikepsdk.csv",header=TRUE,sep=",")

# plot psd
fig6 <- ggplot(data=psd,aes(kfrequency,Pxx,colour=spd,shape=treatname))+geom_point()+scale_x_log10()+scale_y_log10()+xlab("wavenumber, 1/m")+ylab("PSD, ()^2/(1/m)")+facet_grid(treatname~.)
pdf("mikepsdk.pdf")
print(fig6)
dev.off()



# load third-octave-band data
tob <- read.table("miketobk.csv",header=TRUE,sep=",",na.strings="nan")

# plot tob
fig7 <- ggplot(data=tob,aes(x=as.factor(kcenterfreq),y=value,colour=spd,na.rm=TRUE))+geom_point()+geom_line(aes(group=spd))+scale_y_log10()+xlab("1/3 octave band center wavenumber, 1/m")+ylab("()^2")+facet_grid(treatname~.)+opts(axis.text.x=theme_text(angle=-90,hjust=0))
pdf("miketobk.pdf")
print(fig7)
dev.off()

