###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : uiCommonPanels.R
# Descricpción  : Contiene las funciones que permiten representar los distintos
#                 paneles comunes que se muestran en el interfaz
###############################################################################
library(shiny)
library(shinythemes)

# cabecera de pagina comun
headerPanel <- function() {
  control<-""
  return(control)
}

# pie de pagina comun
footerPanel <- function() {
  control<-tags$div(
    class="footerPanel",
    tags$hr(),
    tags$div(
      class="footerPanelContent",
      tags$p(
        class="footerPanelContentLeft",
        strings$value("LABEL_FOOTER_CONTENT_LEFT")
      ),
      tags$p(
        class="footerPanelContentRight",
        strings$value("LABEL_FOOTER_CONTENT_RIGHT")
      )
    )
  )
  return(control)
}

# panel de resumen
summaryPanel <- function() {
  info    <- tags$div(
                tags$p("Interactive visualization tool of bipartite ecological networks")
  )
  author  <- "Juan Manuel García Santi & Javier García Algarra"
  version <- "v1.0 - June'2017"
  panel<-tags$div(class="panelContent", fluidRow(
      column(12,
        fluidRow(groupHeader(text=strings$value("LABEL_ABOUT_INFO_HEADER"), image="info.png")),
        fluidRow(tags$h5(class="aboutInfo", info)),
        fluidRow(groupHeader(text=strings$value("LABEL_ABOUT_AUTHOR_HEADER"), image="worker.png")),
        fluidRow(tags$h5(class="aboutAuthor", author)),
        fluidRow(groupHeader(text=strings$value("LABEL_ABOUT_VERSION_HEADER"), image="product.png")),
        fluidRow(tags$h5(class="aboutVersion", version))
      )
    ))
  return(panel)
}
