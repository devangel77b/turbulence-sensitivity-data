library(ggplot2)
library(plyr)

# load data
lscale <- read.table("alscale.csv",header=TRUE,sep=",")

fig <- ggplot(data=lscale,aes(spd,lscale,colour=spd))+geom_point()+facet_grid(treatname ~ .)



