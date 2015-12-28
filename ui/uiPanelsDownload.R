###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsDownload.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles para la descarga de los diagramas
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiControlsDownload.R", encoding="UTF-8")

# panel de descargas
downloadPanel <- function() {
  panel<-tags$div(
    class="panelContent", 
    fluidRow(
      column(12, groupHeader(text="Descarga de diagramas", image="download.png"))
    ),
    fluidRow(
      column(12, tags$h5("Descarga individual en formato imagen"))
    ),
    fluidRow(
      column(1, tags$span("")),
      column(11, zigguratDownloadControl())
    ),
    fluidRow(
      column(12, tags$h5(""))
    ),
    fluidRow(
      column(1, tags$span("")),
      column(11, polarDownloadControl())
    ),
    fluidRow(
      column(12, tags$h5(""))
    ),
    fluidRow(
      column(1, tags$span("")),
      column(11, histogramDownloadControl())
    ),
    fluidRow(
      column(12, tags$h5(""))
    ),
    fluidRow(
      column(12, tags$h5("Descarga en PDF"))
    ),
    fluidRow(
      column(1, tags$span("")),
      column(11, pdfDownloadControl())
    ),
    fluidRow(
      column(
        12, 
        fluidRow(groupHeader(text="Tamaño de los diagramas", image="ruler.png"))
      )
    ),
    fluidRow(
      column(3, paperSizeControl()),
      column(3, ppiControl())
    )
  )
  return(panel)
}