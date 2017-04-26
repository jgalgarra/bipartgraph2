###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : global.R
# Descricpción  : Constantes y funciones de uso global
###############################################################################

# directorio de datos y patron para buscar los ficheros
dataDir         <- "data"
fileExtension   <- ".csv"
#dataFilePattern <- paste0("M_.*", fileExtension)
dataFilePattern <- paste0("*.*", fileExtension)

# cabecera de un grupo en un panel
groupHeader<-function(text, image) {
  header<-tags$div(
    class="groupHeader",
    tags$span(
      class="groupHeaderIcon",
      tags$img(src=paste0("images/", image))
    ),
    tags$span(
      class="groupHeaderText",
      tags$h5(text)
    )
  )
  return(header)
}

# etiqueta para los controles
controlLabel <- function(text) {
  label<-tags$span(
    class="controlLabel",
    text
  )
  return(label)
}

# etiqueta con imagen para enlaces
linkLabel <- function(text, img) {
  label<-tags$span(
    class="linkLabel",
    tags$img(src=paste0("images/", img)),
    text
  )
  return(label)
}