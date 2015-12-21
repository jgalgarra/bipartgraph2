###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsPolar.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles que se muestran en el interfaz para el diagrama 
#                 polar
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiControlsPolar.R", encoding="UTF-8")

# panel de configuracion del diagrama polar
polarConfigPanel <- function() {
  panel<-tags$div(style="font-size:small", tabsetPanel(
    tabPanel(
      "Visualización",
      fluidRow(
        column(12, groupHeader(text="General", image="settings.png"))
      )
    )
  ))
  return(panel)
}

# panel con el diagrama polar
polarDiagramPanel <- function() {
  control<-fluidRow(
    column(12, 
      fluidRow(groupHeader(text="Diagrama", image="air_force.png")),
      fluidRow(plotOutput("polar"))
    )
  )
  return(control)
}

# panel del polar (configuracion + diagrama)
polarPanel<-function() {
  panel<-tabsetPanel(
    tabPanel("Diagrama",      tags$div(style="font-size:small; padding:10px", polarDiagramPanel())),
    tabPanel("Configuración", tags$div(style="font-size:small; padding:10px", polarConfigPanel()))
  )
  return(panel)
}
