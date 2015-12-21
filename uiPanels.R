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
source("global.R", encoding="UTF-8")

# panel de gestion de datos
dataPanel <- function() {
  panel<-tabsetPanel(
    id="dataPanel",
    tabPanel(
      "Seleccionar datos",
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
    ),
    tabPanel(
      "Gestionar ficheros",  
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
        column(12, groupHeader(text="General", image="settings.png"))
      ),
      fluidRow(
        column(3, displayLabelsControl()),
        column(3, paintLinksControl())
      ),
      fluidRow(
        column(6, flipResultsControl())
      ),
      fluidRow(
        column(12, groupHeader(text="Tamaños", image="ruler.png"))
      ),
      fluidRow(
        column(3, aspectRatioControl())
      ),
      fluidRow(
        column(3, sizeLinkControl()),
        column(3, sizeCoreBoxControl())
      ),
      fluidRow(
        column(3, yDisplaceControl("GuildA", "Desplazamiento vertical clan A")),
        column(3, yDisplaceControl("GuildB", "Desplazamiento vertical clan B"))
      ),
      fluidRow(
        column(3, heightExpandControl())
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
        column(12, groupHeader(text="Nodos", image="tree_structure.png"))
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
        column(12, groupHeader(text="Enlaces", image="link.png"))
      ),
      fluidRow(
        column(4, alphaLevelLinkControl())
      ),
      colorControl("Link", "Color", "#888888")
    ),
    tabPanel(
      "Etiquetas",
      fluidRow(
        column(12, groupHeader(text="Tamaño", image="generic_text.png"))
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
        column(12, groupHeader(text="Colores", image="border_color.png"))
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
    column(7,
      fluidRow(groupHeader(text="Diagrama", image="network.png")),
      fluidRow(uiOutput("ziggurat"))
    ),
    column(5, 
      fluidRow(groupHeader(text="Información", image="document.png")),
      fluidRow(tags$div(style="padding:8px", uiOutput("zigguratDetails"))),
      fluidRow(groupHeader(text="Wikipedia", image="wikipedia.png")),
      fluidRow(tags$div(style="padding:8px", uiOutput("zigguratWikiDetails")))
    )
  )
  return(control)
}

# panel con el gragico polar
polarPanel <- function() {
  control<-fluidRow(
    column(12, 
      fluidRow(groupHeader(text="Diagrama", image="air_force.png")),
      fluidRow(uiOutput("polar"))
    )
  )
  return(control)
}

# panel con el gragico de histogramas
histogramPanel <- function() {
  control<-fluidRow(
    column(12, 
      fluidRow(groupHeader(text="Diagrama", image="bar.png")),
      fluidRow(uiOutput("histogram"))
    )
  )
  return(control)
}

# panel de resumen
summaryPanel <- function() {
  info    <- ""
  info    <- paste0(info, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non felis sed egestas. ")
  info    <- paste0(info, "Nullam nec lorem orci. In volutpat urna sit amet porta vulputate. Quisque pharetra nunc ut fringilla vestibulum. ")
  info    <- paste0(info, "Quisque mauris augue, vehicula id porttitor feugiat, ornare sed nibh. Etiam sed lectus mauris. Aliquam placerat quam id nibh lobortis euismod. ")
  info    <- paste0(info, "Nam vel feugiat odio. Donec aliquet nibh quis felis aliquam accumsan. Aliquam elementum in neque et condimentum.")
  info    <- paste0(info, "Nunc et ullamcorper elit, in pellentesque tellus.")
  author  <- "Juan Manuel García Santi"
  version <- "v1.0 - Diciembre'15"
  control<-fluidRow(
    column(12, 
      fluidRow(groupHeader(text="Información", image="info.png")),
      fluidRow(tags$h5(style="padding:8px", info)),
      fluidRow(groupHeader(text="Autor", image="worker.png")),
      fluidRow(tags$h5(style="padding:8px", author)),
      fluidRow(groupHeader(text="Versión", image="product.png")),
      fluidRow(tags$h5(style="padding:8px", version))
    )
  )
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
        "EUITT - Universidad Politécnica de Madrid"
      )
    )
  )
  return(control)
}

groupHeader<-function(text, image) {
  header<-tags$div(
    style="padding:4px; margin:4px; border-bottom:1px dotted lightgray;",
    tags$span(
      style="vertical-align:middle; display:table-cell;",
      tags$img(style="vertical-align:middle; display:table-cell; padding:4px;", src=paste0("images/", image))
    ),
    tags$span(
      style="vertical-align:middle; display:table-cell;",
      tags$h5(text)
    )
  )
  return(header)
}