###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : svg.R
# Descricpción  : Funciones básicas para la generación de un gráfico en formato
#                 SVG (Scalable Vectors Graphics). Contiene las funciones
#                 necesarias para generar un SVG con rectángulos, rutas y 
#                 segmentos, y proporcionar o almacenar el XML correspondiente
#                 al SVG generado
###############################################################################
library(ggplot2)

LocalizedStrings<-function(locale="es") {
  # crea el objeto
  this<-list(locale=locale, data=read.csv("resources/strings.csv", header=TRUE, row.names=1, , encoding="UTF-8", colClasses="character"))
  
  # obtiene el texto para la clave indicada
  this$value<-function(key) {
    val<-this$data[key, this$locale]
    if (is.null(val) || is.na(val)) {
      val<-""
    }
    return(val)
  }
  
  return(this)
}