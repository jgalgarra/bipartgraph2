###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPolarPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles que se muestran en el interfaz para el diagrama 
#                 polar
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiPolarControls.R", encoding="UTF-8")

# panel del polar (configuracion + diagrama)
polarPanel<-function() {
  panel<-tabsetPanel(
    tabPanel("Diagrama Polar",  tags$div(class="panelContent", polarDiagramPanel())),
    tabPanel("Histogramas",     tags$div(class="panelContent", histogramPanel())),
    tabPanel("Configuración",   tags$div(class="panelContent", polarConfigPanel()))
  )
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

# panel con el gragico de histogramas
histogramPanel <- function() {
  control<-fluidRow(
    column(12, 
      fluidRow(groupHeader(text="Diagrama", image="bar.png")),
      fluidRow(
        column(4, plotOutput("histogramDist")),
        column(4, plotOutput("histogramCore")),
        column(4, plotOutput("histogramDegree"))
      )
    )
  )
  return(control)
}

# panel de configuracion del diagrama polar
polarConfigPanel <- function() {
  panel<-fluidRow(
    fluidRow(
      column(12, groupHeader(text="General", image="settings.png"))
    ),
    fluidRow(
      column(2, polarDisplayTextControl())
    ),
    fluidRow(    
      column(2, polarGuildLabelControl("A", "Etiqueta del clan A", "Plant")),
      column(2, polarGuildLabelControl("B", "Etiqueta del clan B", "Pollinator"))
    ),
    fluidRow(    
      column(2, polarGuildLabelControl("AShort", "Etiqueta corta del clan A", "pl")),
      column(2, polarGuildLabelControl("BShort", "Etiqueta corta del clan B", "pol"))
    ),
    fluidRow(
      column(12, groupHeader(text="Tamaño de las etiquetas", image="generic_text.png"))
    ),
    fluidRow(
      column(2, polarLabelsSizeControl("Title", "Título", 12))
    ),
    fluidRow(    
      column(2, polarLabelsSizeControl("Axis", "Ejes", 10)),
      column(2, polarLabelsSizeControl("Legend", "Leyenda", 10))
    ),
    fluidRow(
      column(2, polarLabelsSizeControl("AxisTitle", "Título de los ejes", 10)),
      column(2, polarLabelsSizeControl("LegendTitle", "Título de la leyenda", 10))
    )
  )
  return(panel)
}
