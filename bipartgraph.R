###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi        
# Módulo        : main.R
# Descricpción  : Ejecución de la aplicación
###############################################################################
library(shiny)
source("global.R", encoding="UTF-8")
source("strings.R", encoding="UTF-8")

# desambigua la funcion get.edges utilizada en el paquete kcorebip
# ya que colisionan los nombres de esta funcion en el paquete igraph en el
# paquete network
get.edges<-igraph::get.edges

# Remove global ziggurat colors data frame
if (exists("labelcolors"))
  rm("labelcolors")
f <- "CONFIG.txt"
if (file.exists(f)){
  config_params <- read.table(f, stringsAsFactors=FALSE, header = TRUE, sep = ";")
  strings<<-LocalizedStrings(config_params$LANGUAGE[1])
  czA1 <<- config_params$ColorGuildA1[1]
  czA2 <<- config_params$ColorGuildA2[1]
  czB1 <<- config_params$ColorGuildB1[1]
  czB2 <<- config_params$ColorGuildB2[1]
  labelA <<- config_params$LabelA[1]
  labelB <<- config_params$LabelB[1]
} else {
  strings<<-LocalizedStrings("en")
  czA1 <<- "#4169E1"
  czA2 <<- "#00008B"
  czB1 <<- "#F08080"
  czB2 <<- "#FF0000"
  labelA <<- strings$value("LABEL_ZIGGURAT_LABEL_GUILDA_DEFAULT")
  labelB <<- strings$value("LABEL_ZIGGURAT_LABEL_GUILDB_DEFAULT")
}


# ejecuta la aplicacion
runApp(
  appDir        = ".",
  port          = 8080,
  host          = "0.0.0.0",
  display.mode  = "normal"
)
