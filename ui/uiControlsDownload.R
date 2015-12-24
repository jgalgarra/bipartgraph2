###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiControlsDownload.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de descarga de ficheros en el interfaz de usuario (UI)
###############################################################################
library(shinyjs)
source("global.R", encoding="UTF-8")

# descarga del diagrama ziggurat
zigguratDownloadControl <- function() {
  control<-actionLink(
    inputId = "zigguratDownload",
    label   = linkLabel(text="Descargar diagrama ziggurat", img="network.png")
  )
  return(control)
}

# descarga del diagrama polar
polarDownloadControl <- function() {
  control<-actionLink(
    inputId = "polarDownload",
    label   = linkLabel(text="Descargar diagrama polar", img="air_force.png")
  )
  return(control)
}

# descarga de los histogramas
histogramDownloadControl <- function() {
  control<-actionLink(
    inputId = "histogramDownload",
    label   = linkLabel(text="Descargar histogramas", img="bar.png")
  )
  return(control)
}
