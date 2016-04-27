
'
Script      : Load Packages
Created     : April, 2016
Author(s)   : Chris Orwa
Version     : v1.0
License     : Apache License, Version 2.0

Description : Load required libraries
'

#load pre-defined scripts
source('conf.R')
source('install_packages.R')

#function to load specific library
loader <-function()
{
  #extract and load packages
  for(k in pkg)
  {
    suppressMessages(suppressWarnings(library(k,character.only = TRUE,warn.conflicts = FALSE,quietly = TRUE)))
  }
}