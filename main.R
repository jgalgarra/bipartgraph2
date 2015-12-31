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
runApp(
  appDir        = ".",
  port          = 8080,
  host          = "0.0.0.0",
  display.mode  = "normal"
)
