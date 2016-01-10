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
source("global.R", encoding="UTF-8")

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
  info    <- ""
  info    <- paste0(info, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non felis sed egestas. ")
  info    <- paste0(info, "Nullam nec lorem orci. In volutpat urna sit amet porta vulputate. Quisque pharetra nunc ut fringilla vestibulum. ")
  info    <- paste0(info, "Quisque mauris augue, vehicula id porttitor feugiat, ornare sed nibh. Etiam sed lectus mauris. Aliquam placerat quam id nibh lobortis euismod. ")
  info    <- paste0(info, "Nam vel feugiat odio. Donec aliquet nibh quis felis aliquam accumsan. Aliquam elementum in neque et condimentum.")
  info    <- paste0(info, "Nunc et ullamcorper elit, in pellentesque tellus.")
  author  <- "Juan Manuel García Santi"
  version <- "v1.0 - Diciembre'15"
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