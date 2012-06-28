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
all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig3c <- ggplot(data=all,aes(x=as.factor(centerfreq),y=U,colour=as.factor(spd)))+geom_point()+geom_line(aes(group=as.factor(spd)))
fig3c <- fig3c+scale_x_discrete(labels=c(".02",".03",".06",".13",".25",".5","1","2","4","8","16","32","64","128"))
fig3c <- fig3c+scale_y_log10()#breaks=c(1e-6,1e-5,1e-4,1e-3,1e-2),labels=c("$10^{-6}$","$10^{-5}$","$10^{-4}$","$10^{-3}$","$10^{-2}$"))
fig3c <- fig3c+scale_colour_grey()
fig3c <- fig3c+xlab("third-octave-band center frequency, \\si{\\hertz}")+ylab("signal power, $(\\si{\\meter\\per\\second})^2$")

# save raw stand-in PDF version
pdf("fig3craw.pdf",width=3,height=2,family="Times")
print(fig3c)
dev.off()

# latex version
tikz("fig3c.tex",standAlone=TRUE,width=3,height=2)
print(fig3c+opts(legend.position="none"))
dev.off()


