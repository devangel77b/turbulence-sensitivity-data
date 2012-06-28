library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
tob <- read.table("../../force/spectra/ntob.csv",header=TRUE,sep=",")
tob <- tob[,c(1,2,3,5,6,8,9)]
tob <- dcast(tob,run+modelname+treatname+spd+centerfreq~from,mean,value.var="value")

# load flow tob
flow <- read.table("../../flow/spectra/atob.csv",header=TRUE,sep=",")
flow <- flow[,c(3,5,6,8,9)]
flow <- dcast(flow,treatname+spd+centerfreq~from,mean,value.var="value")

# load model data
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")

# merge
all <- merge(tob,flow,by=c("treatname","spd","centerfreq"))
all <- merge(all,modeldata,by=c("modelname"))

# subset
all <- subset(all,(series=="new"))
all <- subset(all,(treatname=="med"))
all <- subset(all,(spd==250))
#all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig5c <- ggplot(data=all,aes(x=as.factor(centerfreq),y=TX/U,colour=as.factor(AR)))+geom_point()+geom_line(aes(group=run))
fig5c <- fig5c+scale_x_discrete(labels=c(".02",".03",".06",".13",".25",".5","1","2","4","8","16","32","64","128"))
fig5c <- fig5c+scale_y_log10()#breaks=c(1e-6,1e-5),labels=c("$10^{-6}$","$10^{-5}$"))
fig5c <- fig5c+scale_color_grey()
fig5c <- fig5c+xlab("third-octave-band center frequency, \\si{\\hertz}")+ylab("signal power, $(\\si{\\newton\\meter})^2/(\\si{\\meter\\per\\second})^2$")


# save raw stand-in PDF version
pdf("fig5ctraw.pdf",width=3,height=2,family="Times")
print(fig5c)
dev.off()

# latex version
tikz("fig5ct.tex",standAlone=TRUE,width=3,height=2)
print(fig5c+opts(legend.position="none"))
dev.off()


