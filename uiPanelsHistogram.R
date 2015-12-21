###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsHistogram.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles que se muestran en el interfaz para los histogramas
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")

# panel con el gragico de histogramas
histogramPanel <- function() {
  control<-tags$div(style="font-size:small; padding:10px",
    fluidRow(
      column(12, fluidRow(groupHeader(text="Diagrama", image="bar.png")))
    ),
    fluidRow(
      column(4, plotOutput("histogramDist")),
      column(4, plotOutput("histogramCore")),
      column(4, plotOutput("histogramDegree"))
    )
  )
  return(control)
}
