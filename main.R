###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : main.R
# Descricpción  : Ejecución de la aplicación
###############################################################################
library(shiny)
source("strings.R", encoding="UTF-8")

# variable global para la gestion de los mensajes y cadenas
# de texto en los diferentes idiomas
#strings<-LocalizedStrings("es")
strings<-LocalizedStrings("en")

# ejecuta la aplicacion
runApp(
  appDir        = ".",
  port          = 8080,
  host          = "0.0.0.0",
  display.mode  = "normal"
)
