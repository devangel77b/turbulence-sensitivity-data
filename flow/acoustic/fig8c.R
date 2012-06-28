library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
tob <- read.table("../../flow/spectra/atob.csv",header=TRUE,sep=",")
tob <- tob[,c(3,5,6,8,9)]
tob <- dcast(tob,treatname+spd+centerfreq~from,mean,value.var="value")

# there is no model data for this; just for a given flow
all <- tob

# subset
all <- subset(all,(treatname=="med"))
#all <- subset(all,(spd %in% c(0,50,100,150,200,250)))
all <- subset(all,(spd==250))

# now load mike
mike <- read.table("mikedata/miketob.csv",header=TRUE,sep=",")
mike <- mike[,c(3,5,6,7)]
#mike <- dcast(psds,treatname+spd+frequency~.,mean,value.var="Pxx")
#mike is already cast!
mike <- subset(mike,(treatname=="med"))
mike <- subset(mike,(spd==250))



theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig8c <- ggplot(data=all,aes(x=centerfreq,y=U))+geom_point()+geom_line(aes(group=as.factor(spd)))
fig8c <- fig8c+geom_point(data=mike,aes(x=centerfreq,y=value*10))+geom_line(data=mike,aes(x=centerfreq,y=value*10),linetype=3)
#fig8c <- fig8c+scale_x_discrete(labels=c(".02",".03",".06",".13",".25",".5","1","2","4","8","16","32","64","128"))
fig8c <- fig8c+scale_x_log10()
fig8c <- fig8c+scale_y_log10()#breaks=c(1e-6,1e-5,1e-4,1e-3,1e-2),labels=c("$10^{-6}$","$10^{-5}$","$10^{-4}$","$10^{-3}$","$10^{-2}$"))
fig8c <- fig8c+scale_colour_grey()
fig8c <- fig8c+xlab("third-octave-band center frequency, \\si{\\hertz}")+ylab("signal power, $(\\si{\\meter\\per\\second})^2$")

# save raw stand-in PDF version
pdf("fig8craw.pdf",width=3,height=2,family="Times")
print(fig8c)
dev.off()

# latex version
tikz("fig8c.tex",standAlone=TRUE,width=3,height=2)
print(fig8c+opts(legend.position="none"))
dev.off()


