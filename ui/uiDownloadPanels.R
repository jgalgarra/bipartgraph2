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
source("global.R", encoding="UTF-8")
source("ui/uiDownloadControls.R", encoding="UTF-8")

# panel de descargas
downloadPanel <- function() {
  panel<-tags$div(
    class="panelContent", 
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_DOWNLOAD_MAIN_HEADER"), image="download.png"))
    ),
    fluidRow(
      column(12, tags$h6(strings$value("LABEL_INDIVIDUAL_DOWNLOAD_TIP")))
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
      column(12, tags$h6(strings$value("LABEL_PDF_DOWNLOAD_TIP")))
    ),
    fluidRow(
      column(1, tags$span("")),
      column(11, pdfDownloadControl())
    ),
    fluidRow(
      column(
        12, 
        fluidRow(groupHeader(text=strings$value("LABEL_DOWNLOAD_SIZE_HEADER"), image="ruler.png"))
      )
    ),
    fluidRow(
      column(3, paperSizeControl()),
      column(3, ppiControl())
    )
  )
  return(panel)
}