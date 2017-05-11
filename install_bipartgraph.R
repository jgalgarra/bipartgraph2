list.of.packages <- c('ggplot2', 'gridExtra', 'vegan', 'sna', 'fields', 'shiny', 'shinythemes', 'shinyjs')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library("devtools")
list.of.packages <- c('kcorebip')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install_github('jgalgarra/kcorebip')
