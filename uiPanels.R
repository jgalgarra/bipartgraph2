###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles de informacion que se muestran en el interfaz
###############################################################################
library(shiny)
library(shinythemes)
source("uiControls.R", encoding="UTF-8")

# panel de gestion de datos
dataPanel <- function() {
  panel<-tabsetPanel(
    tabPanel(
      "Ficheros de datos",
      fluidRow(
        column(3, tags$h5("Selección de fichero de datos para diagramas")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(12, tags$h6("Seleccione un fichero de datos de los existentes en el servidor para realizar el análisis y mostrar los distintos diagramas disponibles (ziggurat, porlar e histogramas)"))
      ),
      fluidRow(
        column(12, selectFileControl(path="data", pattern="M_.*.csv"))
      ),
      fluidRow(
        column(3, tags$h5("Contenido del fichero")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(8, dataTableOutput("selectedFileContent"))
      )
    ),
    tabPanel(
      "Incorporar ficheros",  
      fluidRow(
        column(3, tags$h5("Incorporación de ficheros al sistema")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(12, tags$h6("Seleccione un fichero de datos de su equipo para incluir en el sistema y posteriormente poder realizar el análisis"))
      ),
      fluidRow(
        column(12, uploadFilesControl())
      ),
      fluidRow(
        column(3, tags$h5("Ultimos ficheros incorporados")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(8, dataTableOutput("uploadedFilesContent"))
      )
    )
  )
  return(panel)
}

# panel de configuracion
configPanel <- function() {
  panel<-tabsetPanel(
    #tabPanel(
    #  "SVG",
    #  fluidRow(
    #    column(4, svgScaleFactorControl())
    #  )
    #),
    tabPanel(
      "Visualización",
      fluidRow(
        column(6, paintLinksControl())
      ),
      fluidRow(
        column(6, displayLabelsControl())
      ),
      fluidRow(
        column(6, flipResultsControl())
      ),
      fluidRow(
        column(6, aspectRatioControl())
      ),
      fluidRow(
        column(6, sizeLinkControl())
      ),
      fluidRow(
        column(3, yDisplaceControl("GuildA", "Desplazamiento vertical clan A")),
        column(3, yDisplaceControl("GuildB", "Desplazamiento vertical clan B"))
      ),
      fluidRow(
        column(6, heightExpandControl())
      ),
      fluidRow(
        column(3, kcore2TailVerticalSeparationControl()),
        column(3, kcore1TailDistToCoreControl("1", "Distancia cola-kcore1 (1)")),
        column(3, kcore1TailDistToCoreControl("2", "Distancia cola-kcore1 (2)")),
        column(3, innerTailVerticalSeparationControl())
      )
    ),
    tabPanel(
      "Colores",
      fluidRow(
        column(1, tags$h5("Nodos")),
        column(11, tags$hr())
      ),
      fluidRow(
        column(4, alphaLevelControl())
      ),
      fluidRow(
        column(2, colorControl("GuildA1", "Color (1) del clan A", "#4169E1")),
        column(2, colorControl("GuildA2", "Color (2) del clan A", "#00008B")),
        column(2, colorControl("GuildB1", "Color (1) del clan B", "#F08080")),
        column(2, colorControl("GuildB2", "Color (2) del clan B", "#FF0000"))
      ),
      fluidRow(
        column(1, tags$h5("Enlaces")),
        column(11, tags$hr())
      ),
      fluidRow(
        column(4, alphaLevelLinkControl())
      ),
      colorControl("Link", "Color", "#888888")
    ),
    tabPanel(
      "Etiquetas",
      fluidRow(
        column(1, tags$h5("Tamaño")),
        column(11, tags$hr())
      ),
      fluidRow(
        column(2, labelsSizeControl("kCoreMax", "k-core máximo", 3.5)),
        column(2, labelsSizeControl("Ziggurat", "Ziggurat", 3)),
        column(2, labelsSizeControl("kCore1", "k-core 1", 2.5))
      ),
      fluidRow(
        column(2, labelsSizeControl("", "General", 3.5)),
        column(2, labelsSizeControl("CoreBox", "Core box", 2.5)),
        column(2, labelsSizeControl("Legend", "Leyenda", 4))
      ),
      fluidRow(
        column(1, tags$h5("Colores")),
        column(11, tags$hr())
      ),
      fluidRow(
        column(2, colorControl("LabelGuildA", "Clan A", "#4169E1")),
        column(2, colorControl("LabelGuildB", "Clan B", "#F08080"))
      )
    )
  )
  return(panel)
}       

# panel con el gragico ziggurat
zigguratPanel <- function() {
  control<-fluidRow(
    column(8, 
      tags$h5("Diagrama"), tags$hr(), uiOutput("ziggurat")
    ),
    column(4, 
      fluidRow(column(12, tags$h5("Informacion"), tags$hr(), uiOutput("zigguratDetails"))),
      fluidRow(column(12, tags$h5(""))),
      fluidRow(column(12, tags$h5(""))),
      fluidRow(column(12, tags$h5("Wikipedia"), tags$hr(), uiOutput("zigguratWikiDetails")))
    )
  )
  return(control)
}

# panel con el gragico ziggurat
polarPanel <- function() {
  control<-fluidRow(
    column(12, tags$h5("Diagrama"), tags$hr(), uiOutput("polar"))
  )
  return(control)
}

# panel con el gragico ziggurat
histogramPanel <- function() {
  control<-fluidRow(
    column(12, tags$h5("Diagrama"), tags$hr(), uiOutput("histogram"))
  )
  return(control)
}

# panel de resumen
summaryPanel <- function() {
  control<-htmlOutput("summary")
  return(control)
}

# cabecera de pagina comun
headerPanel <- function() {
  control<-""
  return(control)
}

# pie de pagina comun
footerPanel <- function() {
  control<-tags$div(
    style="padding:10px;margin:0px;font-size:x-small;",
    tags$hr(),
    tags$div(
      style="clear:both;padding:0px",
      tags$p(
        style="float:left", 
        "PFC Representación gráfica de redes bipartitas basada en descomposición k-core"
      ),
      tags$p(
        style="float:right", 
        "Juan Manuel García Santi"
      )
  ),
    tags$div(
      style="clear:both;padding:0px",
      tags$p(
        style="float:left", 
        "EUITT - Universidad Politécnica de Madrid"
      ),
      tags$p(
        style="float:right", 
        "jmgarciasanti@gmail.com"
      )
    )
  )
  return(control)
}