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
  info    <- ""
  info    <- paste0(info, "Descarga en formato imagen de los distintos diagramas")
  panel<-tags$div(
    class="panelContent", 
    fluidRow(
      column(
        12, 
        fluidRow(groupHeader(text="Descarga de diagramas", image="download.png")),
        fluidRow(tags$h5(info))
      )
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
    )
  )
  return(panel)
}