###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : uiZigguratControls.R
# Descricpción  : Funciones para la representación de los disintos controles
#                 de configuración, relativos al diagrama ziggurat, en el
#                 interfaz de usuario (UI)
###############################################################################
library(shinyjs)

# control para mostrar o no los enlaces
zigguratPaintLinksControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratPaintLinks",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_PAINT_LINKS_CONTROL")),
    value   = TRUE
  )
  return(control)
}

# control para mostrar o no las etiquetas
zigguratDisplayLabelsControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratDisplayLabels",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_DISPLAY_LABELS_CONTROL")),
    value   = TRUE
  )
  return(control)
}

# control para invertir los resultados
zigguratFlipResultsControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratFlipResults",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_FLIP_RESULT_CONTROL")),
    value   = FALSE
  )
  return(control)
}

# control para dibujar los outsiders
zigguratPaintOutsidersControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratPaintOutsiders",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_PAINT_OUTSIDERS_CONTROL")),
    value   = TRUE
  )
  return(control)
}

# control para usar splines
zigguratUseSplineControl <- function() {
  control<-checkboxInput(
    inputId = "zigguratUseSpline",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_USE_SPLINE_CONTROL")),
    value   = TRUE
  )
  return(control)
}

# control para indicar os puntos de los splines
zigguratSplinePointsControl <- function() {
  control<-sliderInput(
    inputId = "zigguratSplinePoints",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_SPLINE_POINTS_CONTROL")),
    min     = 50,
    max     = 150,
    value   = 100,
    step    = 10
  )
  return(control)
}

# control para el factor de escala del grafico SVG
zigguratAspectRatioControl <- function() {
  control<-sliderInput(
    inputId = "zigguratAspectRatio",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_ASPECT_RATIO_CONTROL")),
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
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_ALPHA_LEVEL_CONTROL")),
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
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_ALPHA_LEVEL_LINK_CONTROL")),
    min     = 0.0,
    max     = 1.0,
    value   = 0.5,
    step    = 0.1
  )
  return(control)
}

# tamanyo de los enlaces
zigguratLinkSizeControl <- function() {
  control<-sliderInput(
    inputId = "zigguratLinkSize",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_LINK_SIZE_CONTROL")),
    min     = 0.0,
    max     = 5.0,
    value   = 0.5,
    step    = 0.5
  )
  return(control)
}

# tamanyo de los core box
zigguratCoreBoxSizeControl <- function() {
  control<-sliderInput(
    inputId = "zigguratCoreBoxSize",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_COREBOX_SIZE_CONTROL")),
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
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_HEIGHT_EXPAND_CONTROL")),
    min     = 0.5,
    max     = 5.0,
    value   = 1.0,
    step    = 0.5
  )
  return(control)
}

# separacion de la cola al kcore-2
zigguratKcore2TailVerticalSeparationControl <- function() {
  control<-sliderInput(
    inputId = "zigguratKcore2TailVerticalSeparation",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_KCORE2_TAIL_VERTICAL_SEPARATION_CONTROL")),
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
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_INNER_TAIL_VERTICAL_SEPARATION_CONTROL")),
    min     = 0.5,
    max     = 2.0,
    value   = 1.0,
    step    = 0.1
  )
  return(control)
}

# etiqueta clan A
zigguratLabelGuildAControl<-function() {
  control<-textInput(
    inputId = "zigguratLabelGuildA",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_LABEL_GUILDA")),
    value   = strings$value("LABEL_ZIGGURAT_LABEL_GUILDA_DEFAULT")
  )
}

# etiqueta clan B
zigguratLabelGuildBControl<-function() {
  control<-textInput(
    inputId = "zigguratLabelGuildB",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_LABEL_GUILDB")),
    value   = strings$value("LABEL_ZIGGURAT_LABEL_GUILDB_DEFAULT")
  )
}

# tamanyo de las etiquetas
zigguratLabelsSizeControl <- function(name, description, default) {
  control<-sliderInput(
    inputId = paste0("zigguratLabelsSize", name),
    label   = controlLabel(description),
    min     = 4.0,
    max     = 18.0,
    value   = default,
    step    = 1
  )
  return(control)
}

# control para el factor de escala de los textos del grafico SVG
zigguratSvgScaleFactorControl <- function() {
  control<-sliderInput(
    inputId = "zigguratSvgScaleFactor",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_SVG_SCALE")),
    min     = 0.2,
    max     = 5,
    value   = 1,
    step    = 0.2
  )
  return(control)
}

# control para recortar la parte superior del SVG
zigguratSVGup <- function() {
  control<-sliderInput(
    inputId = "zigguratSVGup",
    label   = controlLabel(strings$value("LABEL_ZIGGURAT_SVG_UP")),
    min     = 0,
    max     = 50,
    value   = 0,
    step    = 5
  )
  return(control)
}
