library(jsonlite)
library(ggplot2)
library(lubridate)
library(tidyverse)

wiki <- fromJSON("../data/data.json")

Sys.setlocale(category = "LC_ALL", locale = "cs_CZ.UTF-8")
Sys.getlocale(category = "LC_ALL")


for (i in 1:50) {
  tyden <- as.data.frame(wiki[[i]])
  nazev <- as.character(tyden[1,1])
  tyden <- tyden[,-1]
  tyden <- t(tyden)
  tyden <- data.frame(datum=row.names(tyden), visits=tyden)
  tyden$datum <- as.character(tyden$datum)
  tyden$datum <- str_remove(tyden$datum, "X")
  tyden$datum <- paste0(tyden$datum, "2019")
  tyden$datum <- as.Date(tyden$datum, format = "%m%d%Y")
  
  #doplnit chybějící dny
  if (tyden$datum[1]>as.Date("2019-01-01")) {
    zacatek <- tyden$datum[1]
    while (zacatek>as.Date("2018-12-31"))
    {
      zacatek <- zacatek - 1
      tyden <- rbind(data.frame(datum=zacatek, visits=0), tyden)
    }
  }
  
  png(paste0("../img/wiki/week", formatC(i, width = 2, format = "d", flag = "0"), ".png"), width=600, height=315)
  par(mar=c(2,0,0,0.8))
  
  nejden <- tyden %>% filter(visits==max(visits))
  plot(tyden$datum, tyden$visits, type="l", yaxt="n", xaxt="n", ylab="", xlab="", las=1, col="red", lwd=2, bty="n", ylim=c(0, nejden$visits))
  
  # Annotate
  axis(side=1, at=as.Date(c("2019-01-01", "2019-03-15", "2019-06-15", "2019-09-15", "2019-12-15"),'%Y-%m-%d'), cex.axis=1.4, labels=c("leden", "březen", "červen", "září", "prosinec"))
  veta <- paste0(day(nejden$datum), ". ", month(nejden$datum, label=T, abbr=F), ": ", floor(nejden$visits/1000), " tisíc návštěv")
  symbols(nejden$datum, nejden$visits, circles=5, inches=FALSE, add=TRUE, lwd=2)
  if (i<30||i==31) {text(nejden$datum+2, nejden$visits, veta, cex=1.6, font=3, pos=4)} else {text(nejden$datum-2, nejden$visits, veta, cex=1.6, font=3, pos=2)}
  
  
  
  dev.off()
}
