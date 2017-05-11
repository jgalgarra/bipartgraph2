rdef <- "http://cran.us.r-project.org"
list.of.packages <- c('ggplot2', 'scales',
                      'stringr', 'grid','igraph', 'bipartite',
                      'gridExtra', 'vegan', 'sna', 'fields',
                      'shiny', 'shinythemes', 'shinyjs')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = rdef)
library("devtools")
list.of.packages <- c('kcorebip')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install_github('jgalgarra/kcorebip')
