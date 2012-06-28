library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
psds <- read.table("../../force/spectrak/npsdsk.csv",header=TRUE,sep=",")
psds <- psds[,c(1,2,3,5,6,8,9)]
#psds <- subset(psds,(spd==250))
#psds <- subset(psds,(treatname=="med"))
psds <- dcast(psds,run+modelname+treatname+spd+kfrequency~from,mean,value.var="Pxx")

# load flow data
flow <- read.table("../../flow/spectrak/apsdsk.csv",header=TRUE,sep=",")
flow <- flow[,c(3,5,6,8,9)]
flow <- dcast(flow,treatname+spd+kfrequency~from,mean,value.var="Pxx")
#flow <- subset(flow,(spd==250))
#flow <- subset(flow,(treatname=="med"))

# load model data
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")

# merge
all <- merge(psds,flow,by=c("treatname","spd","kfrequency"))
all <- merge(all,modeldata,by=c("modelname"))

# subset
all <- subset(all,(series=="new"))
all <- subset(all,(treatname=="med"))
all <- subset(all,(spd==250))
#all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig5b <- ggplot(data=all,aes(x=kfrequency,y=TX/1000/U,colour=as.factor(AR)))+geom_line(aes(group=run))
fig5b <- fig5b+scale_x_log10(breaks=c(0.1,0.2,0.5,1,2,5,10,20,50,100),labels=c(0.1,0.2,0.5,1,2,5,10,20,50,100))
fig5b <- fig5b+scale_y_log10()#breaks=c(1e-6,1e-5),labels=c("$10^{-6}$","$10^{-5}$"))
fig5b <- fig5b+scale_color_grey()
fig5b <- fig5b+xlab("$k, \\si{\\per\\meter}$")+ylab("$E_{t_x}/E_{u_x}, (\\si{\\newton\\meter})^2 (\\si{\\meter\\per\\second})^{-2} \\si{\\meter}$")

# save raw stand-in PDF version
pdf("fig5btraw.pdf",width=3,height=2,family="Times")
print(fig5b)
dev.off()

# latex version
tikz("fig5bt.tex",standAlone=TRUE,width=3,height=2)
print(fig5b+opts(legend.position="none"))
dev.off()


