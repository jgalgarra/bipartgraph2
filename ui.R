###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : ui.R
# Descricpción  : Módulo de interfaz de usuario (UI) para la aplicación "shiny"
#
###############################################################################
library(shiny)
library(shinythemes)
source("ui/uiPanelsCommon.R", encoding="UTF-8")
source("ui/uiPanelsData.R", encoding="UTF-8")
source("ui/uiPanelsZiggurat.R", encoding="UTF-8")
source("ui/uiPanelsPolar.R", encoding="UTF-8")
source("ui/uiPanelsHistogram.R", encoding="UTF-8")

#
# interfaz de usuario
#
shinyUI(
  tagList(
    tags$head(
      tags$script(src="scripts/jquery.waituntilexists.js"),
      tags$script(src="scripts/redesbipartitas.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "css/redesbipartitas.css")
    ),
    navbarPage(
      title   = "Redes Bipartitas",
      theme   = shinytheme("united"),
      header  = headerPanel(),
      footer  = footerPanel(),
      # controles de entrada para la gestion de los ficheros de datos
      tabPanel(
        "Datos",
        dataPanel()
      ),
      # panel con el diagrama ziggurat
      tabPanel(
        "Ziggurat",
        zigguratPanel()
      ),
      # panel con el diagrama polar
      tabPanel(
        "Polar",
        polarPanel()
      ),
      # panel con los histogramas
      tabPanel(
        "Histogramas",
        histogramPanel()
      ),
      # acerca de
      tabPanel(
        "Acerca de...",
        summaryPanel()    
      )
    )
  )
)