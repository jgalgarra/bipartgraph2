###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsZiggurat.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles que se muestran en el interfaz para el diagrama
#                 ziggurat
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiControlsZiggurat.R", encoding="UTF-8")

# panel de configuracion del diagrama ziggurat
zigguratConfigPanel <- function() {
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
        column(3, zigguratDisplayLabelsControl()),
        column(3, zigguratPaintLinksControl())
      ),
      fluidRow(
        column(6, zigguratFlipResultsControl())
      ),
      fluidRow(
        column(12, groupHeader(text="Tamaños", image="ruler.png"))
      ),
      fluidRow(
        column(3, zigguratAspectRatioControl())
      ),
      fluidRow(
        column(3, zigguratSizeLinkControl()),
        column(3, zigguratSizeCoreBoxControl())
      ),
      fluidRow(
        column(3, zigguratYDisplaceControl("GuildA", "Desplazamiento vertical clan A")),
        column(3, zigguratYDisplaceControl("GuildB", "Desplazamiento vertical clan B"))
      ),
      fluidRow(
        column(3, zigguratHeightExpandControl())
      ),
      fluidRow(
        column(3, zigguratKcore2TailVerticalSeparationControl()),
        column(3, zigguratKcore1TailDistToCoreControl("1", "Distancia cola-kcore1 (1)")),
        column(3, zigguratKcore1TailDistToCoreControl("2", "Distancia cola-kcore1 (2)")),
        column(3, zigguratInnerTailVerticalSeparationControl())
      )
    ),
    tabPanel(
      "Colores",
      fluidRow(
        column(12, groupHeader(text="Nodos", image="tree_structure.png"))
      ),
      fluidRow(
        column(4, zigguratAlphaLevelControl())
      ),
      fluidRow(
        column(2, zigguratColorControl("GuildA1", "Color (1) del clan A", "#4169E1")),
        column(2, zigguratColorControl("GuildA2", "Color (2) del clan A", "#00008B")),
        column(2, zigguratColorControl("GuildB1", "Color (1) del clan B", "#F08080")),
        column(2, zigguratColorControl("GuildB2", "Color (2) del clan B", "#FF0000"))
      ),
      fluidRow(
        column(12, groupHeader(text="Enlaces", image="link.png"))
      ),
      fluidRow(
        column(4, zigguratAlphaLevelLinkControl())
      ),
      fluidRow(
        column(4, zigguratColorControl("Link", "Color", "#888888"))
      )
    ),
    tabPanel(
      "Etiquetas",
      fluidRow(
        column(12, groupHeader(text="Tamaño", image="generic_text.png"))
      ),
      fluidRow(
        column(2, zigguratLabelsSizeControl("kCoreMax", "k-core máximo", 3.5)),
        column(2, zigguratLabelsSizeControl("Ziggurat", "Ziggurat", 3)),
        column(2, zigguratLabelsSizeControl("kCore1", "k-core 1", 2.5))
      ),
      fluidRow(
        column(2, zigguratLabelsSizeControl("", "General", 3.5)),
        column(2, zigguratLabelsSizeControl("CoreBox", "Core box", 2.5)),
        column(2, zigguratLabelsSizeControl("Legend", "Leyenda", 4))
      ),
      fluidRow(
        column(12, groupHeader(text="Colores", image="border_color.png"))
      ),
      fluidRow(
        column(2, zigguratColorControl("LabelGuildA", "Clan A", "#4169E1")),
        column(2, zigguratColorControl("LabelGuildB", "Clan B", "#F08080"))
      )
    )
  )
  return(panel)
}       

# panel con el gragico ziggurat
zigguratDiagramPanel <- function() {
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

# panel del ziggurat (configuracion + diagrama)
zigguratPanel<-function() {
  panel<-tabsetPanel(
    tabPanel("Diagrama",      tags$div(style="font-size:small; padding:10px", zigguratDiagramPanel())),
    tabPanel("Configuración", tags$div(style="font-size:small; padding:10px", zigguratConfigPanel()))
  )
  return(panel)
}
