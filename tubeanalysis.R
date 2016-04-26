
'
Script      : Youtube Reaper
Created     : April, 2016
Author(s)   : Elvis Bando, Chris Orwa
Version     : v1.5
License     : Apache License, Version 2.0

Description : Reap stats from a YouTube video
'

#load required libraries
source('packages.R')
loader()

track_song <-function(url_resource)
# ==============================================================================
#     Capture stastics of a YouTube video
#
# Args:
#   url: a string holds Youtube video URL
#
# Returns:
#   stats: a data frame with data posted,total views,dislikes, likes & timestamp
# ===============================================================================
{
  #get authentication
  source('settings.R')
  
  #get resource on provided URL
  html <- getURL(url_resource, cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
  
  #convert response to text
  doc = htmlParse(html, asText=TRUE)
  
  #extract views on video
  views=xpathSApply (doc,'//*[@class="watch-view-count"]',xmlValue)
  
  #extract videos
  dateposted =xpathSApply (doc,'//*[@class="watch-time-text"]',xmlValue)
  
  #extract views
  total_views = gsub(",", "", views)
  
  #extra date posted
  dateposted = gsub("Published on ", "", dateposted)
  date_posted = as.character(as.Date(dateposted, "%b %d, %Y"))
  
  #extract dislikes
  dislikes = xpathSApply (doc,'//*[@class="yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-dislike-button like-button-renderer-dislike-button-unclicked yt-uix-clickcard-target   yt-uix-tooltip"]',xmlValue)
  dislikes = gsub(",", "", dislikes)
  
  #extract likes
  likes = xpathSApply (doc,'//*[@class="yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-like-button like-button-renderer-like-button-unclicked yt-uix-clickcard-target   yt-uix-tooltip"]',xmlValue)
  likes = gsub(",", "", likes)  
  
  #put timestamp
  timestamp = as.numeric(as.POSIXct(Sys.time()))
  
  #combine all fields
  datas = data.frame(date_posted, total_views, dislikes, likes, timestamp)
  
  return(datas)
}



