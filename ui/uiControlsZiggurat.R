###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : uiControlsZiggurat.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de configuración, relativos al diagrama ziggurat, en el 
#                 interfaz de usuario (UI)
###############################################################################
library(shinyjs)
source("global.R", encoding="UTF-8")

# control para mostrar o no los enlaces
zigguratPaintLinksControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratPaintLinks",
    label   = controlLabel("Mostrar enlaces"),
    value   = TRUE
  )
  return(control)
}

# control para mostrar o no las etiquetas
zigguratDisplayLabelsControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratDisplayLabels",
    label   = controlLabel("Mostrar etiquetas"),
    value   = TRUE
  )
  return(control)
}

# control para invertir los resultados
zigguratFlipResultsControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratFlipResults",
    label   = controlLabel("Invertir resultado"),
    value   = FALSE
  )
  return(control)
}

# control para el factor de escala del grafico SVG
zigguratAspectRatioControl <- function() {
  control<-sliderInput(
    inputId = "zigguratAspectRatio",
    label   = controlLabel("Relación de aspecto"),
    min     = 0.1,
    max     = 5.0,
    value   = 1.0,
    step    = 0.1
  )
  return(control)
}

# control para el factor de transparencia
zigguratAlphaLevelControl <- function() {
  control<-sliderInput(
    inputId = "zigguratAlphaLevel",
    label   = controlLabel("Transparencia"),
    min     = 0.0,
    max     = 1.0,
    value   = 0.2,
    step    = 0.1
  )
  return(control)
}

# control generico para seleccion de color
zigguratColorControl <- function(name, description, default) {
  control <- colourInput(
    paste0("zigguratColor" , name),
    controlLabel(description), 
    value = default
  )
  return(control)
}

# control para el factor de transparencia de los enlaces
zigguratAlphaLevelLinkControl <- function() {
  control<-sliderInput(
    inputId = "zigguratAlphaLevelLink",
    label   = controlLabel("Transparencia"),
    min     = 0.0,
    max     = 1.0,
    value   = 0.5,
    step    = 0.1
  )
  return(control)
}

# tamanyo de los enlaces
zigguratSizeLinkControl <- function() {
  control<-sliderInput(
    inputId = "zigguratSizeLink",
    label   = controlLabel("Grosor de los enlaces"),
    min     = 0.0,
    max     = 5.0,
    value   = 0.5,
    step    = 0.5
  )
  return(control)
}

# tamanyo de los core box
zigguratSizeCoreBoxControl <- function() {
  control<-sliderInput(
    inputId = "zigguratSizeCoreBox",
    label   = controlLabel("Grosor del borde de los core box"),
    min     = 0.0,
    max     = 2.0,
    value   = 0.2,
    step    = 0.1
  )
  return(control)
}

# desplazamiento vertical
zigguratYDisplaceControl <- function(name, description) {
  control<-sliderInput(
    inputId = paste0("zigguratYDisplace", name),
    label   = controlLabel(description),
    min     = 0.0,
    max     = 15.0,
    value   = 11.0,
    step    = 1.0
  )
  return(control)
}

# ampliacion de la altura de la caja
zigguratHeightExpandControl <- function() {
  control<-sliderInput(
    inputId = "zigguratHeightExpand",
    label   = controlLabel("Expansión de altura"),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.5
  )
  return(control)
}

# separacion de la cola al kcore-2
zigguratKcore2TailVerticalSeparationControl <- function() {
  control<-sliderInput(
    inputId = "zigguratKcore2TailVerticalSeparation",
    label   = controlLabel("Distancia cola-kcore2"),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.5
  )
  return(control)
}

# distancia de la cola kcore-1 al core central
zigguratKcore1TailDistToCoreControl <- function(name, description) {
  control<-sliderInput(
    inputId = paste0("zigguratKcore1TailDistToCore", name),
    label   = controlLabel(description),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.1
  )
  return(control)
}

# separacion vertical interna en la cola
zigguratInnerTailVerticalSeparationControl <- function() {
  control<-sliderInput(
    inputId = "zigguratInnerTailVerticalSeparation",
    label   = controlLabel("Separacion vertical interna en la cola"),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.1
  )
  return(control)
}

# tamanyo de las etiquetas
zigguratLabelsSizeControl <- function(name, description, default) {
  control<-sliderInput(
    inputId = paste0("zigguratLabelsSize", name),
    label   = controlLabel(description),
    min     = 1.0,
    max     = 5.0,
    value   = default,
    step    = 0.5
  )
  return(control)
}

# control para el factor de escala del grafico SVG
zigguratSvgScaleFactorControl <- function() {
  control<-sliderInput(
    inputId = "zigguratSvgScaleFactor",
    label   = controlLabel("Escala SVG"),
    min     = 10,
    max     = 100,
    value   = 50,
    step    = 10
  )
  return(control)
}
