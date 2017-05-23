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
source("ui/uiPolarControls.R", encoding="UTF-8")

# panel del polar (configuracion + diagrama)
polarPanel<-function() {
  panel<-tabsetPanel(
    tabPanel(strings$value("LABEL_POLAR_DIAGRAM_PANEL"),        tags$div(class="panelContent", polarDiagramPanel())),
    tabPanel(strings$value("LABEL_POLAR_CONFIGURATION_PANEL"),  tags$div(class="panelContent", polarConfigPanel()))
  )
  return(panel)
}

# panel con el diagrama polar
polarDiagramPanel <- function() {
  if (exists("zgg"))
    nfic <- zgg$polar_file
  else
    nfic <- ""
  control<-fluidRow(
    column(12,
      fluidRow(div(
        tags$br()
      )),
      fluidRow(column(4,polarDownloadControl()),
               column(4,polarcodeDownloadControl())
      ),
      fluidRow(div(
        tags$br()
      )),
      fluidRow(plotOutput("polar"))
      )
  )
  return(control)
}


# panel de configuracion del diagrama polar
polarConfigPanel <- function() {
  panel<-fluidRow(
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_POLAR_GENERAL_CONFIG_HEADER"), image="settings.png"))
    ),
    fluidRow(
      column(2, polarDisplayTextControl()),
      column(2, polarAlphaLevelControl()),
      column(2, polarFillNodesControl()),
      column(2, polarDisplayHistograms()),
      column(2, polarscreenwidthControl())

    ),

    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_POLAR_LABELS_CONFIG_HEADER"), image="generic_text.png"))
    ),
    fluidRow(
      column(2, polarLabelsSizeControl("Title", strings$value("LABEL_POLAR_TITLE_LABEL_SIZE_CONTROL"), 12)),
      column(2, polarLabelsSizeControl("Axis", strings$value("LABEL_POLAR_AXIS_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("Legend", strings$value("LABEL_POLAR_LEGEND_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("AxisTitle", strings$value("LABEL_POLAR_AXIS_TITLE_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("LegendTitle", strings$value("LABEL_POLAR_LEGEND_TITLE_LABEL_SIZE_CONTROL"), 10))
    )

  )
  return(panel)
}
