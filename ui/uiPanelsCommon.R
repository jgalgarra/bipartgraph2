###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPanelsCommon.R
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
  panel<-tags$div(style="font-size:small; padding:10px", fluidRow(
      column(12, 
        fluidRow(groupHeader(text="Información", image="info.png")),
        fluidRow(tags$h5(style="padding:8px", info)),
        fluidRow(groupHeader(text="Autor", image="worker.png")),
        fluidRow(tags$h5(style="padding:8px", author)),
        fluidRow(groupHeader(text="Versión", image="product.png")),
        fluidRow(tags$h5(style="padding:8px", version))
      )
    ))
  return(panel)
}