
'
Script      : Install Packages
Created     : April, 2016
Author(s)   : Chris Orwa
Version     : v1.1
License     : Apache License, Version 2.0

Description : Install required packages
'

#load configuration script
source('conf.R')

#function for checking installed packages and installing missing ine
packs <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  
  #print to console
  print("Done!")
}