###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : uiDownloadControls.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de descarga de ficheros en el interfaz de usuario (UI)
###############################################################################
library(shinyjs)

# descarga del diagrama ziggurat
# zigguratDownloadControl <- function() {
#   control<-downloadLink(
#            outputId  = "zigguratDownload",
#           label     = linkLabel(text=strings$value("LABEL_ZIGGURAT_DOWNLOAD_CONTROL"), img="network.png")
#   )
#
#   return(control)
# }


zigguratDownloadControl <- function() {
    control<-downloadButton("zigguratDownload",label     = "Ziggurat Download")
    return(control)
}

polarDownloadControl <- function() {
  control<-downloadButton("polarDownload",label     = "Polar Download")
  return(control)
}


# # descarga del diagrama polar
# polarDownloadControl <- function() {
#   control<-downloadLink(
#     outputId  = "polarDownload",
#     label     = linkLabel(text=strings$value("LABEL_POLAR_DOWNLOAD_CONTROL"), img="air_force.png")
#   )
#   return(control)
# }
#
# # descarga de los histogramas
# histogramDownloadControl <- function() {
#   control<-downloadLink(
#     outputId  = "histogramDownload",
#     label     = linkLabel(text=strings$value("LABEL_HISTOGRAM_DOWNLOAD_CONTROL"), img="bar.png")
#   )
#   return(control)
# }
#
# # descarga de todos los diagramas en PDF
# pdfDownloadControl <- function() {
#   control<-downloadLink(
#     outputId  = "pdfDownload",
#     label     = linkLabel(text=strings$value("LABEL_PDF_DOWNLOAD_CONTROL"), img="pdf.png")
#   )
#   return(control)
# }
#
# # tamanyo del diagrama a descargar
# paperSizeControl <- function() {
#   values<-1:6
#   names(values)<-paste0("A", values)
#   control<-selectInput(
#     inputId   = "paperSize",
#     label     = controlLabel(strings$value("LABEL_PAPER_SIZE_CONTROL")),
#     choices   = values,
#     selected  = 4,
#     multiple  = FALSE
#   )
#   return(control)
# }
#
# # resolucion del diagrama a descargar
# ppiControl <- function() {
#   values<-c(72, 96, 150, 300, 600)
#   names(values)<-values
#   control<-selectInput(
#     inputId   = "ppi",
#     label     = controlLabel(strings$value("LABEL_RESOLUTION_SIZE_CONTROL")),
#     choices   = values,
#     selected  = 300,
#     multiple  = FALSE
#   )
#   return(control)
# }
#
# #Include histograms
# paperLandscape <- function() {
#   control<-checkboxInput(
#     inputId = "paperLandscape",
#     label   = controlLabel(strings$value("LABEL_PAPER_ORIENTATION")),
#     value   = TRUE
#   )
#   return(control)
# }
