text <- rep("To byl ale zajímavý týden! Čím byl tento týden zajímavý? Tohle lidi zajímalo.", 50)

wiki <- fromJSON("../data/data.json")
wiki <- sapply(wiki, function(x) {return(x[[1]])})

ir <- fromJSON("../data/nejctenejsi.json")

soubory <- list.files("../data/ga-queries/")
google <- character()
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
  vyber <- as.character(vyber[1,1])
  google <- c(google, vyber)
}


export <- list()

for (i in 1:50) {
r <- list(week=
  list(
  text=text[i],
  wiki=list(
    title=wiki[i]
  ),
  ir=list(
    url=ir[i,1],
    title=ir[i,2],
    img=ir[i,3]
  ),
  google=list(
    title=google[i]
    )
  )
)
export <- c(export, r)
}

names(export) <- c(paste0("week", 1:50))

library(tfse)
pbcopy(toJSON(export, auto_unbox=T, pretty=T))

