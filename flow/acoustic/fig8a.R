library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
psds <- read.table("../../flow/spectra/apsds.csv",header=TRUE,sep=",")
psds <- psds[,c(3,5,6,8,9)]
psds <- dcast(psds,treatname+spd+frequency~from,mean,value.var="Pxx")

# there is no model data for this; just for a given flow
all <- psds

# subset
all <- subset(all,(treatname=="med"))
#all <- subset(all,(spd %in% c(0,50,100,150,200,250)))
all <- subset(all,(spd == 250))

# now load mike
mike <- read.table("mikedata/mikepsd.csv",header=TRUE,sep=",")
mike <- mike[,c(3,5,6,7)]
#mike <- dcast(psds,treatname+spd+frequency~.,mean,value.var="Pxx")
#mike is already cast!
mike <- subset(mike,(treatname=="med"))
mike <- subset(mike,(spd==250))






theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig8a <- ggplot(data=all,aes(x=frequency,y=U))+geom_line()
fig8a <- fig8a+geom_line(data=mike,aes(x=frequency,y=Pxx*10),linetype=3)
fig8a <- fig8a+scale_x_log10(breaks=c(0.1,10,1000),labels=c("$10^{-1}$","$10$","$10^3$"))
fig8a <- fig8a+scale_y_log10(breaks=c(1e-9,1e-6,1e-3),labels=c("$10^{-9}$","$10^{-6}$","$10^{-3}$"))
fig8a <- fig8a+xlab("$f, \\si{\\hertz}$")+ylab("$E_{u_x}, (\\si{\\meter\\per\\second})^2 \\si{\\per\\hertz}$")

# save raw stand-in PDF version
pdf("fig8araw.pdf",width=3,height=2,family="Times")
print(fig8a)
dev.off()

# latex version
tikz("fig8a.tex",standAlone=TRUE,width=3,height=2)
print(fig8a+opts(legend.position="none"))
dev.off()


