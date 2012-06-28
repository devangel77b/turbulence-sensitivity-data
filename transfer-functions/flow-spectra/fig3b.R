library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
psds <- read.table("../../flow/spectrak/apsdsk.csv",header=TRUE,sep=",")
psds <- psds[,c(3,5,6,8,9)]
psds <- dcast(psds,treatname+spd+kfrequency~from,mean,value.var="Pxx")

# there is no model data for this; just for a given flow
all <- psds

# subset
all <- subset(all,(treatname=="med"))
all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig3b <- ggplot(data=all,aes(x=kfrequency,y=U,colour=as.factor(spd)))+geom_line()
fig3b <- fig3b+scale_x_log10()#breaks=c(0.1,0.2,0.5,1,2,5,10,20,50,100),labels=c(0.1,0.2,0.5,1,2,5,10,20,50,100))
fig3b <- fig3b+scale_y_log10()#breaks=c(1e-6,1e-5,1e-4,1e-3,1e-2),labels=c("$10^{-6}$","$10^{-5}$","$10^{-4}$","$10^{-3}$","$10^{-2}$"))
fig3b <- fig3b+scale_color_grey()
fig3b <- fig3b+xlab("$k, \\si{\\per\\meter}$")+ylab("$E_{u_x}, (\\si{\\meter\\per\\second})^2 \\si{\\meter}$")

# save raw stand-in PDF version
pdf("fig3braw.pdf",width=3,height=2,family="Times")
print(fig3b)
dev.off()

# latex version
tikz("fig3b.tex",standAlone=TRUE,width=3,height=2)
print(fig3b+opts(legend.position="none"))
dev.off()


