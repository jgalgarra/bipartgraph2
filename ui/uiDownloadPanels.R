###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : uiDownloadPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles para la descarga de los diagramas
###############################################################################
library(shiny)
library(shinythemes)
library(shinyjs)
source("ui/uiDownloadControls.R", encoding="UTF-8")

downloadPanel <- function() {
  panel<-tags$div(
    class="panelContent",
    fluidRow(
      column(3, paperLandscape()),
      column(3, paperSizeControl()),
      column(3, ppiControl())
    ),
    fluidRow(
     column(3, zigguratBckgdColorControl()),
     column(3, zigguratAspectRatio())
    ),
    fluidRow(div(
      tags$br()
    )),
    useShinyjs(),
    fluidRow(
      column(3, zigguratDownloadControl()),
      column(3, zigguratcodeDownloadControl())
    )


  )
  return(panel)
}
