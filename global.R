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
dataFilePattern <- "M_.*.csv"

# cabecera de un grupo en un panel
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

# etiqueta para los controles
controlLabel <- function(text) {
  label<-tags$h6(text, style="display:inline-block;vertical-align:middle")
  return(label)
}