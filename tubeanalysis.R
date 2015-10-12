#Youtube Reaper

library(bitops)
library(RCurl)
library(XML)
library(stringr)

#load the file containig the list of songs you want to track
wimbo = read.csv(file.choose())
songs = wimbo$Youtubelink

stats = data.frame()

#for each of the songs in your list of songs to track, get how many views.
#You will need to have downloaded certificate file from 
#download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

for (i in 1:length(songs)){
  html <- getURL(songs[i], cainfo="cacert.pem")
  doc = htmlParse(html, asText=TRUE)
  views=xpathSApply (doc,'//*[@class="watch-view-count"]',xmlValue)
  dateposted =xpathSApply (doc,'//*[@class="watch-time-text"]',xmlValue)
  total_views = gsub(",", "", views)
  dateposted = gsub("Published on ", "", dateposted)
  date_posted = as.character(as.Date(dateposted, "%b %d, %Y"))
  dislikes = xpathSApply (doc,'//*[@class="yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-dislike-button like-button-renderer-dislike-button-unclicked yt-uix-clickcard-target   yt-uix-tooltip"]',xmlValue)
  dislikes = gsub(",", "", dislikes)
  likes = xpathSApply (doc,'//*[@class="yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-like-button like-button-renderer-like-button-unclicked yt-uix-clickcard-target   yt-uix-tooltip"]',xmlValue)
  likes = gsub(",", "", likes)  
  song = str_trim(as.character(wimbo[i,1]))
  artist = str_trim(as.character(wimbo[i,2]))
  ylink = str_trim(as.character(wimbo[i,3]))
  timestamp = as.numeric(as.POSIXct(Sys.time()))

datas = data.frame(song,artist,ylink, date_posted, total_views, dislikes, likes, timestamp)
stats = rbind(stats, datas)
}


write.table(stats, file = "data.csv", col.names = if(file.exists("data.csv"))FALSE else  TRUE, row.names = FALSE, append = TRUE, sep = ",")
