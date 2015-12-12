# TODO: Add comment
# 
# Author: JMGARC4
###############################################################################
library(shinyjs)

# control para la seleccion del fichero
filesInputControl <- function(path, pattern) {
  filesList<-as.list(list.files(path=path, pattern=pattern))
  names(filesList)<-filesList
  control<-selectInput(
      inputId = "dataFile", 
      label   = controlLabel("Fichero de datos"),
      choices = filesList
  )
  return(control)
}

# control para mostrar o no los enlaces
paintLinksControl <- function() {
  control<-checkboxInput(
      inputId = "paintLinks",
      label   = controlLabel("Mostrar enlaces"),
      value   = TRUE
  )
  return(control)
}

# control para mostrar o no las etiquetas
displayLabelsControl <- function() {
  control<-checkboxInput(
      inputId = "displayLabels",
      label   = controlLabel("Mostrar etiquetas"),
      value   = TRUE
  )
  return(control)
}

# control para invertir los resultados
flipResultsControl <- function() {
  control<-checkboxInput(
      inputId = "flipResults",
      label   = controlLabel("Invertir resultado"),
      value   = FALSE
  )
  return(control)
}

# control para el factor de escala del grafico SVG
aspectRatioControl <- function() {
  control<-sliderInput(
      inputId = "aspectRatio",
      label   = controlLabel("Relación de aspecto"),
      min     = 0.1,
      max     = 1.0,
      value   = 1.0,
      step    = 0.1
  )
  return(control)
}

# control para el factor de transparencia
alphaLevelControl <- function() {
  control<-sliderInput(
      inputId = "alphaLevel",
      label   = controlLabel("Transparencia"),
      min     = 0.0,
      max     = 1.0,
      value   = 0.2,
      step    = 0.1
  )
  return(control)
}

# control generico para seleccion de color
colorControl <- function(name, description, default) {
  control <- colourInput(
    paste0("color" , name),
    controlLabel(description), 
    value = default
  )
  return(control)
}

# control para el factor de transparencia de los enlaces
alphaLevelLinkControl <- function() {
  control<-sliderInput(
      inputId = "alphaLevelLink",
      label   = controlLabel("Transparencia en enlaces"),
      min     = 0.0,
      max     = 1.0,
      value   = 0.5,
      step    = 0.1
  )
  return(control)
}

# tamanyo de los enlaces
sizeLinkControl <- function() {
  control<-sliderInput(
      inputId = "sizeLink",
      label   = controlLabel("Tamaño de los enlaces"),
      min     = 0.0,
      max     = 5.0,
      value   = 0.5,
      step    = 0.5
  )
  return(control)
}

# desplazamiento vertical
yDisplaceControl <- function(name, description) {
  control<-sliderInput(
      inputId = paste0("yDisplace", name),
      label   = controlLabel(description),
      min     = 0.0,
      max     = 15.0,
      value   = 11.0,
      step    = 1.0
  )
  return(control)
}

# ampliacion de la altura de la caja
heightExpandControl <- function(){
  control<-sliderInput(
    inputId = "heightExpand",
    label   = controlLabel("Expansión de altura"),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.5
  )
  return(control)
}

# tamanyo de las etiquetas
labelsSizeControl <- function(name, description, default) {
  control<-sliderInput(
      inputId = paste0("labelsSize", name),
      label   = controlLabel(description),
      min     = 1.0,
      max     = 5.0,
      value   = default,
      step    = 0.5
  )
  return(control)
}

# control para el factor de escala del grafico SVG
svgScaleFactorControl <- function() {
  control<-sliderInput(
      inputId = "svgScaleFactor",
      label   = controlLabel("Escala SVG"),
      min     = 10,
      max     = 100,
      value   = 50,
      step    = 10
  )
  return(control)
}

# etiqueta para los controles
controlLabel <- function(text) {
  return(h6(text, style="display:inline-block;vertical-align:middle"))
}