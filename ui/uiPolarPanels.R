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
    # tabPanel(strings$value("LABEL_POLAR_HISTOGRAM_PANEL"),      tags$div(class="panelContent", histogramPanel())),
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
      fluidRow(polarDownloadControl()),
      fluidRow(plotOutput("polar"))
      )
  )
  return(control)
}

# # panel con el gragico de histogramas
# histogramPanel <- function() {
#   control<-fluidRow(
#     column(12,
#       fluidRow(groupHeader(text=strings$value("LABEL_POLAR_HISTOGRAM_HEADER"), image="bar.png")),
#       fluidRow(
#         column(4, plotOutput("histogramDist")),
#         column(4, plotOutput("histogramCore")),
#         column(4, plotOutput("histogramDegree"))
#       )
#     )
#   )
#   return(control)
# }

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
      column(2, polarDisplayHistograms())#,
      #column(2, polardownloadLink())
    ),
    # fluidRow(
    #   column(2, polarGuildLabelControl("A", strings$value("LABEL_POLAR_GUILDA_LABEL_CONTROL"), "Plant")),
    #   column(2, polarGuildLabelControl("B", strings$value("LABEL_POLAR_GUILDB_LABEL_CONTROL"), "Pollinator"))#,
    #   column(2, polarGuildLabelControl("AShort", strings$value("LABEL_POLAR_GUILDA_SHORT_LABEL_CONTROL"), "pl")),
    #   column(2, polarGuildLabelControl("BShort", strings$value("LABEL_POLAR_GUILDB_SHORT_LABEL_CONTROL"), "pol"))
    # ),
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_POLAR_LABELS_CONFIG_HEADER"), image="generic_text.png"))
    ),
    fluidRow(
      column(2, polarLabelsSizeControl("Title", strings$value("LABEL_POLAR_TITLE_LABEL_SIZE_CONTROL"), 12)),
      column(2, polarLabelsSizeControl("Axis", strings$value("LABEL_POLAR_AXIS_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("Legend", strings$value("LABEL_POLAR_LEGEND_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("AxisTitle", strings$value("LABEL_POLAR_AXIS_TITLE_LABEL_SIZE_CONTROL"), 10)),
      column(2, polarLabelsSizeControl("LegendTitle", strings$value("LABEL_POLAR_LEGEND_TITLE_LABEL_SIZE_CONTROL"), 10))
    ),
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_POLAR_SCREEN_CONFIG_HEADER"), image="generic_text.png"))
    ),
    fluidRow(
      column(3, polarscreenwidthControl())
    )
  )
  return(panel)
}
