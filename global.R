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
  label<-tags$h6(
    class="controlLabel",
    text
  )
  return(label)
}