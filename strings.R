###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : svg.R
# Descricpción  : Funcion para definir todas las cadenas de texto en base al
#                 idioma que se quiere utilizar en el interfaz de usuario
###############################################################################
library(ggplot2)

LocalizedStrings<-function(locale="es") {
  # crea el objeto
  this<-list(locale=locale, data=read.csv("resources/strings.csv", header=TRUE, row.names=1, , encoding="UTF-8", colClasses="character"))
  
  # obtiene el texto para la clave indicada
  this$value<-function(keys) {
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    val<-this$data[keys, this$locale]
    val[is.na(val)]<-"(error: undefined key)"
    val[is.null(val)]<-"(error: undefined language)"
    return(trim(val))
  }
  
  return(this)
}