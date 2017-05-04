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
source("ui/uiCommonPanels.R", encoding="UTF-8")
source("ui/uiDataPanels.R", encoding="UTF-8")
source("ui/uiZigguratPanels.R", encoding="UTF-8")
source("ui/uiPolarPanels.R", encoding="UTF-8")
source("ui/uiDownloadPanels.R", encoding="UTF-8")

#
# interfaz de usuario
#
shinyUI(
  tagList(
    tags$head(
      tags$script(src="scripts/perfect-scrollbar.jquery.js"),
      tags$script(src="scripts/jquery.qtip.js"),
      tags$script(src="scripts/jquery.dragscrollable.js"),
      tags$script(src="scripts/jquery.waituntilexists.js"),
      tags$script(src="scripts/redesbipartitas.js"),
      tags$link(rel="stylesheet", type="text/css", href="css/perfect-scrollbar.css"),
      tags$link(rel="stylesheet", type="text/css", href="css/jquery.qtip.css"),
      tags$link(rel="stylesheet", type="text/css", href="css/redesbipartitas.css"),
      tags$script("$(window).load(function() {windowLoad()})")
    ),
    navbarPage(
      title   = "Redes Bipartitas",
      theme   = shinytheme("united"),
      header  = headerPanel(),
      #footer  = footerPanel(),
      # controles de entrada para la gestion de los ficheros de datos
      tabPanel(
        strings$value("LABEL_MENU_DATA_PANEL"),
        dataPanel()
      ),
      # panel con el diagrama ziggurat
      tabPanel(
        strings$value("LABEL_MENU_ZIGGURAT_PANEL"),
        zigguratPanel()
      ),
      #panel para descargar los diagramas
      tabPanel(
        strings$value("LABEL_MENU_DOWNLOAD_PANEL"),
        downloadPanel()
      ),
      # panel con el diagrama polar
      tabPanel(
        strings$value("LABEL_MENU_POLAR_PANEL"),
        polarPanel()
      ),
      # acerca de
      tabPanel(
        strings$value("LABEL_MENU_ABOUT_PANEL"),
        summaryPanel()
      )
    )
  )
)
