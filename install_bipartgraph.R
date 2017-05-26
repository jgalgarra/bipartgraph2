# Installation script for BipartGraph.

# Create user library if it does not exist.
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
rdef <- "http://cran.us.r-project.org"
list.of.packages <- c('ggplot2', 'scales', 'colourpicker',
                      'grid','igraph', 'bipartite',
                      'gridExtra', 'vegan', 'sna', 'fields','DT',
                      'shiny', 'shinythemes', 'shinyjs','devtools')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = rdef)

# Check if kcorebip is installed and remove up to download the latest release
plic <- data.frame(installed.packages())
if (sum(grepl("kcorebip",plic$Package)))
  remove.packages("kcorebip")
library("devtools")
install_github('jgalgarra/kcorebip')
