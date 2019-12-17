## týdenní csv ručně stažené z google analytics

library(tidyverse)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(readr)

soubory <- list.files("../data/ga-queries/")

for (i in 1:50) {
  vyber <- read_csv(readLines(paste0("../data/ga-queries/", soubory[i]))[8:107], col_names = F)
  vyber <- vyber %>% filter(vyber[,1] != "irozhlas")
  vyber <- vyber %>% filter(vyber[,1] != "irozhlas cz")
  vyber <- vyber %>% filter(vyber[,1] != "irozhlas.cz")
  vyber <- vyber %>% filter(vyber[,1] != "(other)")
  vyber <- vyber %>% filter(vyber[,1] != "i rozhlas")
  vyber <- vyber %>% filter(vyber[,1] != "rozhlas")
  vyber <- vyber %>% filter(vyber[,1] != "irozhlas volby")
  vyber <- vyber %>% filter(vyber[,1] != "seznam")
  png(paste0("../img/wordcloud/w", formatC(i, width = 2, format = "d", flag = "0"), ".png"), width=600, height=315)
  wordcloud(words=pull(vyber,1),
            freq=as.numeric(pull(vyber,2)),
            max.words=50,
            random.order=F,
            random.color=T,
            rot.per=0,
            colors=c("#e41a1c", "#377eb8", "#4daf4a"),
            use.r.layout=T,
            fixed.asp=F,
            scale=c(3.2,1))
  dev.off()
}