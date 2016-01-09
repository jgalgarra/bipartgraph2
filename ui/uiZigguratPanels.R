###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiZigguratPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles que se muestran en el interfaz para el diagrama
#                 ziggurat
###############################################################################
library(shiny)
library(shinythemes)
source("global.R", encoding="UTF-8")
source("ui/uiZigguratControls.R", encoding="UTF-8")

# panel del ziggurat (configuracion + diagrama)
zigguratPanel<-function() {
  panel<-tabsetPanel(
    tabPanel(strings$value("LABEL_ZIGGURAT_DIAGRAM_PANEL"), tags$div(class="panelContent", zigguratDiagramPanel())),
    tabPanel(strings$value("LABEL_ZIGGURAT_CONFIG_PANEL"),  tags$div(class="panelContent", zigguratConfigPanel()))
  )
  return(panel)
}

# panel con el gragico ziggurat
zigguratDiagramPanel <- function() {
  control<-fluidRow(
    column(7,
      fluidRow(
        groupHeader(text=strings$value("LABEL_ZIGGURAT_DIAGRAM_HEADER"), image="network.png")
      ),
      fluidRow(
        tags$span(
          id="zoomPanel", 
          tags$img(id="zoomin",     onclick="svgZoomIn()",    src="images/zoom_in.png"), 
          tags$img(id="zoomout",    onclick="svgZoomOut()",   src="images/zoom_out.png"),
          tags$img(id="zoomfit",    onclick="svgZoomFit()",   src="images/fit_to_width.png"),
          tags$img(id="zoomreset",  onclick="svgZoomReset()", src="images/sinchronize.png")
        )
      ),
      fluidRow(
        uiOutput("ziggurat")
      )
    ),
    column(5, 
      fluidRow(
        groupHeader(text=strings$value("LABEL_ZIGGURAT_DIAGRAM_INFO_HEADER"), image="document.png")
      ),
      fluidRow(
        tags$div(uiOutput("zigguratDetails"))
      ),
      fluidRow(
        groupHeader(text=strings$value("LABEL_ZIGGURAT_DIAGRAM_WIKI_HEADER"), image="wikipedia.png")
      ),
      fluidRow(
        tags$div(uiOutput("zigguratWikiDetails"))
      )
    )
  )
  return(control)
}

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
      strings$value("LABEL_ZIGGURAT_CONFIG_VISUALIZATION_PANEL"),
      fluidRow(
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_VISUALIZATION_GENERAL_HEADER"), image="settings.png"))
      ),
      fluidRow(
        column(3, zigguratDisplayLabelsControl()),
        column(3, zigguratPaintLinksControl())
      ),
      fluidRow(
        column(6, zigguratFlipResultsControl())
      ),
      fluidRow(
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_VISUALIZATION_SIZES_HEADER"), image="ruler.png"))
      ),
      fluidRow(
        column(3, zigguratAspectRatioControl())
      ),
      fluidRow(
        column(3, zigguratLinkSizeControl()),
        column(3, zigguratCoreBoxSizeControl())
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
      strings$value("LABEL_ZIGGURAT_CONFIG_COLOURS_PANEL"),
      fluidRow(
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_COLOURS_NODES_HEADER"), image="tree_structure.png"))
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
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_COLOURS_LINKS_HEADER"), image="link.png"))
      ),
      fluidRow(
        column(4, zigguratAlphaLevelLinkControl())
      ),
      fluidRow(
        column(4, zigguratColorControl("Link", "Color", "#888888"))
      )
    ),
    tabPanel(
      strings$value("LABEL_ZIGGURAT_CONFIG_LABELS_PANEL"),
      fluidRow(
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_LABELS_SIZE_HEADER"), image="generic_text.png"))
      ),
      fluidRow(
        column(2, zigguratLabelsSizeControl("kCoreMax", "k-core máximo", 10)),
        column(2, zigguratLabelsSizeControl("Ziggurat", "Ziggurat", 9)),
        column(2, zigguratLabelsSizeControl("kCore1", "k-core 1", 8))
      ),
      fluidRow(
        column(2, zigguratLabelsSizeControl("", "General", 20)),
        column(2, zigguratLabelsSizeControl("CoreBox", "Core box", 8)),
        column(2, zigguratLabelsSizeControl("Legend", "Leyenda", 8))
      ),
      fluidRow(
        column(12, groupHeader(text=strings$value("LABEL_ZIGGURAT_CONFIG_LABELS_COLOUR_HEADER"), image="border_color.png"))
      ),
      fluidRow(
        column(2, zigguratColorControl("LabelGuildA", "Clan A", "#4169E1")),
        column(2, zigguratColorControl("LabelGuildB", "Clan B", "#F08080"))
      )
    )
  )
  return(panel)
}
