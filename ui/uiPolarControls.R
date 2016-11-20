###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiPolarControls.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de configuración, relativos al diagrama polar, en el 
#                 interfaz de usuario (UI)
###############################################################################
library(shinyjs)

# control para mostrar o no el texto
polarDisplayTextControl <- function() {
  control<-checkboxInput(
    inputId = "polarDisplayText",
    label   = controlLabel(strings$value("LABEL_POLAR_SHOW_LABELS_CONTROL")),
    value   = TRUE
  )
  return(control)
}

# control para indicar las etiquetas de los "guild"
polarGuildLabelControl <- function(name, description, value) {
  control<-textInput(
    inputId = paste0("polarGuildLabel", name),
    label   = controlLabel(description),
    value   = value
  )
  return(control)
}

# tamanyo de las etiquetas
polarLabelsSizeControl <- function(name, description, default) {
  control<-sliderInput(
    inputId = paste0("polarLabelsSize", name),
    label   = controlLabel(description),
    min     = 8,
    max     = 20,
    value   = default,
    step    = 1
  )
  return(control)
}
