###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : uiDataPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles de gestion de datos que se muestran en el interfaz
###############################################################################
library(shiny)
library(shinythemes)
source("ui/uiDataControls.R", encoding="UTF-8")

# panel de gestion de datos
dataPanel <- function() {
  panel<-tabsetPanel(
    id="dataPanel",
    tabPanel(strings$value("LABEL_SELECT_DATA_PANEL"),   tags$div(class="panelContent", selectDataPanel())),
    tabPanel(strings$value("LABEL_MANAGE_FILES_PANEL"),  tags$div(class="panelContent", manageFilesPanel()))
    #tabPanel(strings$value("LABEL_SELECT_LANGUAGE"),  tags$div(class="panelContent", manageLanguages()))
  )
  return(panel)
}

# panel de seleccion de ficheros
selectDataPanel<-function() {
  panel<-fluidRow(
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_SELECT_DATA_HEADER"), image="scv.png"))
    ),
    fluidRow(
      column(12, tags$h6(strings$value("LABEL_SELECT_DATA_TIP")))
    ),
    fluidRow(
      column(8, selectDataFileControl(path=dataDir, pattern=dataFilePattern)),
      column(4, actionButton("ResetAll", label = strings$value("LABEL_ACTION_RESET")))
    ),

    fluidRow(
      column(3, DataLabelGuildAControl()),
      column(3, DataLabelGuildBControl())
    ),
    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_DATA_CONTENT_HEADER"), image="grid.png"))
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
      column(6, groupHeader(text=strings$value("LABEL_FILE_UPLOAD_HEADER"), image="upload.png")),
      column(6, groupHeader(text=strings$value("LABEL_FILE_LAST_UPLOADED_HEADER"), image="file.png"))
    ),
    fluidRow(
      column(6,
        tags$h6(strings$value("LABEL_FILE_UPLOAD_TIP")),
        uploadFilesControl()
      ),
      column(6, dataTableOutput("uploadedFilesTable"))
    ),

    fluidRow(
      column(12, groupHeader(text=strings$value("LABEL_AVAILABLE_FILES"), image="documents.png"))
    ),
    # fluidRow(
    #   column(12, dataTableOutput("availableFilesTable"))
    # ),
    fluidRow(
    column(12, DT::dataTableOutput('availableFilesTable'))
    ),

    fluidRow(
      column(12, deleteFilesControl())
    )
  )
  return(panel)
}

# panel de gestion de idiomas
manageLanguages<-function() {
  panel<-fluidRow(
    # fluidRow(
    #   column(12, groupHeader(text=strings$value("LABEL_SELECT_LANGUAGE"), image="generic_text.png"))
    # ),
    fluidRow(
      column(3, selectLanguage())
    )
  )
  return(panel)
}
