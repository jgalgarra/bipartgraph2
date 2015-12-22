###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsData.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles de gestion de datos que se muestran en el interfaz
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiControlsData.R", encoding="UTF-8")

# panel de seleccion de ficheros
selectDataPanel<-function() {
  panel<-fluidRow(
    fluidRow(
      column(12, groupHeader(text="Selección de fichero de datos para diagramas", image="scv.png"))
    ),
    fluidRow(
      column(12, tags$h6("Seleccione un fichero de datos de los existentes en el servidor para realizar el análisis y mostrar los distintos diagramas disponibles (ziggurat, porlar e histogramas)"))
    ),
    fluidRow(
      column(12, selectDataFileControl(path=dataDir, pattern=dataFilePattern))
    ),
    fluidRow(
      column(12, groupHeader(text="Contenido del fichero", image="grid.png"))
    ),
    fluidRow(
      column(8, dataTableOutput("selectedDataFileContent"))
    )
  )
  return(panel)
}

# panel de gestion de ficheros
manageFilesPanel<-function() {
  panel<-fluidRow(
    fluidRow(
      column(6, groupHeader(text="Incorporación de ficheros al sistema", image="upload.png")),
      column(6, groupHeader(text="Ultimos ficheros incorporados", image="file.png"))
    ),
    fluidRow(
      column(6,
        tags$h6("Seleccione un fichero de datos de su equipo para incluir en el sistema y posteriormente poder realizar el análisis"),
        uploadFilesControl()
      ),
      column(6, dataTableOutput("uploadedFilesTable"))
    ),
    fluidRow(
      column(12, groupHeader(text="Ficheros disponibles", image="documents.png"))
    ),
    fluidRow(
      column(12, dataTableOutput("availableFilesTable"))
    ),
    fluidRow(
      column(12, refreshFilesControl(), deleteFilesControl())
    )
  )
  return(panel)
}

# panel de gestion de datos
dataPanel <- function() {
  panel<-tabsetPanel(
    id="dataPanel",
    tabPanel("Seleccionar datos",   tags$div(class="panel", selectDataPanel())),
    tabPanel("Gestionar ficheros",  tags$div(class="panel", manageFilesPanel()))
  )
  return(panel)
}
