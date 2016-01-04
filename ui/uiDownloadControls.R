###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiDownloadControls.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de descarga de ficheros en el interfaz de usuario (UI)
###############################################################################
library(shinyjs)
source("global.R", encoding="UTF-8")

# descarga del diagrama ziggurat
zigguratDownloadControl <- function() {
  control<-downloadLink(
    outputId  = "zigguratDownload",
    label     = linkLabel(text="Descargar diagrama ziggurat", img="network.png")
  )
  return(control)
}

# descarga del diagrama polar
polarDownloadControl <- function() {
  control<-downloadLink(
    outputId  = "polarDownload",
    label     = linkLabel(text="Descargar diagrama polar", img="air_force.png")
  )
  return(control)
}

# descarga de los histogramas
histogramDownloadControl <- function() {
  control<-downloadLink(
    outputId  = "histogramDownload",
    label     = linkLabel(text="Descargar histogramas", img="bar.png")
  )
  return(control)
}

# descarga de todos los diagramas en PDF
pdfDownloadControl <- function() {
  control<-downloadLink(
    outputId  = "pdfDownload",
    label     = linkLabel(text="Descargar todos los diagramas en PDF", img="pdf.png")
  )
  return(control)
}

# tamanyo del diagrama a descargar
paperSizeControl <- function() {
  values<-1:6
  names(values)<-paste0("A", values)
  control<-selectInput(
    inputId   = "paperSize", 
    label     = controlLabel("Tamaño del papel"),
    choices   = values,
    selected  = 4,
    multiple  = FALSE
  )
  return(control)
}

# resolucion del diagrama a descargar
ppiControl <- function() {
  values<-c(72, 96, 150, 300, 600)
  names(values)<-values
  control<-selectInput(
    inputId   = "ppi", 
    label     = controlLabel("Resolución"),
    choices   = values,
    selected  = 300,
    multiple  = FALSE
  )
  return(control)
}
