install.packages("googleAnalyticsR", dependencies = TRUE)

## setup
library(googleAnalyticsR)
library(lubridate)
library(tidyverse)
library(rvest)
library(stringr)
library(jsonlite)

## This should send you to your browser to authenticate your email. 
# Authenticate with an email that has access to the 
# Google Analytics View you want to use.
ga_auth()

## get your accounts
account_list <- ga_account_list()

## account_list will have a column called "viewId"
account_list$viewId

## View account_list and pick the viewId you want to extract data from. 
ga_id <- 114113324


## začátky a konce týdnů

tydny <- data.frame(
  tyden = 1:52,
  start = c(date("2019-01-01"), seq(date("2019-01-07"), date("2019-12-23"), 7)),
  end = c(date("2019-01-06"), seq(date("2019-01-13"), date("2019-12-29"), 7))
)


## stáhni URL tří nejčtenějších článků za každý týden

nejctenejsi <- data.frame(tyden=numeric(), url=character(), pageviews=numeric())

for (i in 1:52) {
  result <- google_analytics(ga_id,
                   date_range = c(tydny[i,2], tydny[i,2]),
                   metrics = "pageviews",
                   dimensions = "pagePath",
                   order= order_type("pageviews", "DESCENDING", "VALUE"),
                   max = 3)
  nejctenejsi <- rbind(nejctenejsi, data.frame(tyden=c(i,i,i), url=result$pagePath, pageviews=result$pageviews))
  print(result)
}

## vyber jeden nejčtenější pro každý týden

urls <- character()

for (i in 1:52) {
  result <- nejctenejsi %>%
    filter(tyden==i) %>%
    filter(url!="www.irozhlas.cz/") %>%
    slice(1) %>%
    .$url %>%
    as.character()
  print(result)
  urls <- c(urls, as.character(result))
}


## stáhni titulky nejčtenějších a URL fotek

nejctenejsi <- data.frame(url=urls)

nejctenejsi$url <- paste0("https://", nejctenejsi$url)

tit <- character()


for (i in nejctenejsi$url) {
  r <- read_html(i) %>%
    html_node("title") %>%
    html_text()
  print(r)
  tit <- append(tit, r)
}


tit <- str_remove(tit, "\ \\| iROZHLAS - spolehlivé zprávy")
tit <- str_trim(tit)
nejctenejsi$title <- tit


img <- character()

for (i in nejctenejsi$url) {
  t <- read_html(i) %>%
    html_nodes("head meta") %>%
    html_attrs()
  t <- t[[16]][2]
  img <- append(img, t)
  print(t)  
}

nejctenejsi$img <- img


list(nejctenejsi)

toJSON(nejctenejsi)
