library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
psds <- read.table("../../force/spectra/npsds.csv",header=TRUE,sep=",")
psds <- psds[,c(1,2,3,5,6,8,9)]
psds <- dcast(psds,run+modelname+treatname+spd+frequency~from,mean,value.var="Pxx")

# there is no model data for this; just for a given flow
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")
all <- merge(psds,modeldata,by=c("modelname"))

# subset
all <- subset(all,(series=="new"))
all <- subset(all,(treatname=="med"))
all <- subset(all,(spd==250))
#all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig4a <- ggplot(data=all,aes(x=frequency,y=TX,colour=as.factor(AR)))+geom_line(aes(group=run))
fig4a <- fig4a+scale_x_log10(breaks=c(0.1,0.2,0.5,1,2,5,10,20,50,100),labels=c(0.1,0.2,0.5,1,2,5,10,20,50,100))
fig4a <- fig4a+scale_y_log10()#breaks=c(1e-6,1e-5),labels=c("$10^{-6}$","$10^{-5}$"))
fig4a <- fig4a+scale_color_grey()
fig4a <- fig4a+xlab("$f, \\si{\\hertz}$")+ylab("$E_{f_x}, (\\si{\\newton\\milli\\meter})^2 \\si{\\per\\hertz}$")

# save raw stand-in PDF version
pdf("fig4atraw.pdf",width=3,height=2,family="Times")
print(fig4a)
dev.off()

# latex version
tikz("fig4at.tex",standAlone=TRUE,width=3,height=2)
print(fig4a+opts(legend.position="none"))
dev.off()


