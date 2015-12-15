library(shiny)
library(shinythemes)
source("controls.R", encoding="UTF-8")

# panel de configuracion
configPanel <- function() {
  panel<-tabsetPanel(
    tabPanel(
      "Datos",
      fluidRow(
        column(3, tags$h5("Selección de fichero para análisis")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(12, tags$h6("Seleccione un fichero de datos de los existentes en el servidor para realizar el análisis"))
      ),
      fluidRow(
        column(12, filesInputControl(path="data", pattern="M_.*.csv"))
      ),
      fluidRow(
        column(3, tags$h5("Selección de fichero para subir al servidor")),
        column(9, tags$hr())
      ),
      fluidRow(
        column(12, tags$h6("Seleccione un fichero de datos de su equipo para subir al servidor y poder realizar el análisis posteriormente"))
      ),
      fluidRow(
        column(12, filesUploadControl())
      )
    ),
    tabPanel(
      "SVG",
      fluidRow(
        column(4, svgScaleFactorControl())
      )
    ),
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
          column(1, tags$h5("Clanes")),
          column(11, tags$hr())
      ),
      fluidRow(
        column(4, alphaLevelControl())
      ),
      fluidRow(
        column(2, colorControl("GuildA1", "Clan A (1)", "#4169E1")),
        column(2, colorControl("GuildA2", "Clan A (2)", "#00008B")),
        column(2, colorControl("GuildB1", "Clan B (1)", "#F08080")),
        column(2, colorControl("GuildB2", "Clan B (2)", "#FF0000"))
      ),
      fluidRow(
        column(1, tags$h5("Enlaces")),
        column(11, tags$hr())
      ),
      fluidRow(
        column(4, alphaLevelLinkControl())
      ),
      colorControl("Link", "Enlaces", "#888888")
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
      tags$h5("Diagrama"),tags$hr(), uiOutput("ziggurat")
    ),
    column(4, 
      fluidRow(column(12, tags$h5("Informacion"), tags$hr(), uiOutput("zigguratDetails"))),
      fluidRow(column(12, tags$h5(""))),
      fluidRow(column(12, tags$h5(""))),
      fluidRow(column(12, tags$h5("Wiki"), tags$hr(), uiOutput("zigguratWikiDetails")))
    )
  )
  return(control)
}

# panel con el gragico ziggurat
polarPanel <- function() {
  control<-fluidRow(
      column(8, tags$h5("Diagrama"))
  )
  return(control)
}

# panel con el gragico ziggurat
histogramPanel <- function() {
  control<-fluidRow(
      column(8, tags$h5("Diagrama"))
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
  control<-tags$script(src="redesbipartitas.js")
  return(control)
}

# pie de pagina comun
footerPanel <- function() {
  control<-tags$div(tags$hr(),tags$div(tags$h5(style="text-align:center", "(c) Juanma 2015")))
  return(control)
}

#
# interfaz de usuario
#
shinyUI(
  navbarPage(
    title   = "Redes Bipartitas",
    theme   = shinytheme("united"),
    header  = headerPanel(),
    footer  = footerPanel(),
    
    # controles de entrada para ajustar numero de nodos y numero de enlaces
    tabPanel(
      "Configuración",
      configPanel()
    ),
    # panel con el diagrama ziggurat
    tabPanel(
      "Ziggurat",
      zigguratPanel()
    ),
    # panel con el diagrama polar
    tabPanel(
      "Polar",
      polarPanel()
    ),
    # panel con los histogramas
    tabPanel(
      "Histogramas",
      histogramPanel()
    ),
    # acerca de
    tabPanel(
      "Acerca de...",
      summaryPanel()    
    )
  )
)