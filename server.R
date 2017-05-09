###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core
#
# Autor         : Juan Manuel García Santi
# Módulo        : server.R
# Descricpción  : Módulo servidor para la aplicación "shiny". Contiene la
#                 función principal "shinyServer" así como las funciones
#                 restantes que permiten tanto reaccionar a los cambios en la
#                 configuración como mostrar los diagramas y actuar ante los
#                 distintos eventos a los que responde la aplicación
###############################################################################
library(shiny)
library(gridExtra)
library(grDevices)
library(gtable)
library(grid)
#library(cowplot)
library(DT)
library(kcorebip)

# muestra la informacion de detalle sobre un nodo del ziggurat
showNodeDetails <- function(type, kcore, nodeDf) {
  # tamanyo de las columnas
  rows    <- eval(parse(text="fluidRow()"))
  columns <- ""
  sizes   <- c(1, 2, 4, 1, 1, 1)

  # crea las filas
  name    <- nodeDf[1, c("name_species")]
  label   <- nodeDf[1, c("label")]
  label   <- paste0("tags$a(\"", label, "\", href=\"", paste0("javascript:showWiki('", type, "',", label, ", '", name , "')"), "\")")
  kcore   <- paste0("\"", kcore, "\"")
  type    <- paste0("\"", type, "\"")
  name    <- paste0("\"", name, "\"")
  kradius <- paste0("\"", round(nodeDf[1, c("kradius")], 2), "\"")
  kdegree <- paste0("\"", round(nodeDf[1, c("kdegree")], 2), "\"")
  columns <- ""
  values  <- c(label, type, name, kcore, kradius, kdegree)
  for (i in 1:length(values)) {
    if (nchar(columns)>0) {
      columns<-paste0(columns, ", ")
    }
    columns <- paste0(columns, "column(", sizes[i], ", tags$small(", values[i], "))")
  }
  rows<-paste(rows, eval(parse(text=paste0("fluidRow(", columns, ")"))))

  return(rows)
}

# muestra la informacion de la wikioedia sobre un nodo
showWiki <- function(types, nodesData) {
  content<-""
  if (is.null(nodesData)) {
    content<-paste(content,eval(parse(text="fluidRow()")))
  } else {
    tab<-""
    tab<-paste0(tab, "tabsetPanel(")
    for (i in 1:nrow(nodesData)) {
      if (i>1) {
        tab<-paste0(tab, ", ")
      }
      type<-types[i]
      nodeData<-nodesData[i,]
      tab<-paste0(tab, "tabPanel(")
      tab<-paste0(tab, "\"", type, " [#", nodeData$nodeId, "]\"")
      tab<-paste0(tab, ", fluidRow(")
      tab<-paste0(tab, "column(12, ")
      tab<-paste0(tab, "tags$div(id=\"wikiDetail-", type, "-", nodeData$nodeId)
      tab<-paste0(tab, "\"")
      tab<-paste0(tab, ", class=\"wikiDetail\"")
      tab<-paste0(tab, ", \"", strings$value("MESSAGE_WIKI_LOADING"), "\"")
      #tab<-paste0(tab, "tags$h6(\"(información descargada de Wikipedia para el elemento ")
      #tab<-paste0(tab, nodeData$name)
      #tab<-paste0(tab, "...)\"")
      tab<-paste0(tab, "))))")
    }
    tab<-paste0(tab, ", id=\"wikiTabsetPanel\", type=\"pills\")")
    content<-paste(content, eval(parse(text=tab)))
  }
  return(content)
}

# obtiene la lista de ficheros disponibles
availableFilesList<-function() {
  # obtiene la lista de ficheros
  filesList<-list.files(path=dataDir, pattern=dataFilePattern)
  names(filesList)<-filesList

  # anyade la primera entrada
  empty<-c("")
  names(empty)<-c(strings$value("MESSAGE_SELECT_DATA_FILE_INPUT"))
  return(c(empty, filesList))
}

# obtiene la lista con los detalles de los ficheros disponibles
availableFilesDetails<-function(filesList) {
  # columnas de los detalles
  filesDetailsColumns<-c(strings$value("LABEL_AVAILABLE_FILES_DETAILS_NAME"), strings$value("LABEL_AVAILABLE_FILES_DETAILS_SIZE"), "", "", strings$value("LABEL_AVAILABLE_FILES_DETAILS_MODIFICATION_DATE"), "", strings$value("LABEL_AVAILABLE_FILES_DETAILS_ACCESS_DATE"))

  # elimina las entradas vacias
  filesList<-filesList[filesList!=""]

  # obtiene los detalles
  if (length(filesList)>0) {
    # obtiene los detalles de los ficheros disponibles
    # y añade la columna con el nombre del fichero
    filesDetails  <- file.info(paste0(dataDir, "/", filesList), extra_cols=FALSE)
    filesDetails  <- cbind(gsub(paste0(dataDir, "/"), "", rownames(filesDetails)), filesDetails)
  } else {
    # crea un dataframe vacio
    filesDetails<-data.frame(name=character(), size=integer(), isdir=logical(), mode=integer(), mtime=character(), ctime=character(), atime=character())
  }

  # renombra las columnas
  colnames(filesDetails)<-filesDetailsColumns

  # elimina las columnas sin nombre
  filesDetails<-filesDetails[!(colnames(filesDetails) %in% c(""))]

  return(filesDetails)
}

# obtiene las opciones para generar un diagrama
#   paperSize: 0-DINA0, 1-DINA1, ...
#   ppi: pixels per inch
calculateDiagramOptions<-function(paperSize, ppi) {
  options<-list(paperSize=1, width=480, height=480, ppi=300, cairo=FALSE, ext="")

  # dimensiones DIN-A, primero en mm y luego convertido a pulgadas
  widths    <- c(t(sapply(c(841, 841), function(x) {x*(1/2)^(0:3)})))
  heights   <- c(t(sapply(c(1189, 1189), function(x) {x*(1/2)^(0:3)})))
  pdfSizes  <- data.frame(width=widths[2:7], height=heights[3:8])
  inchesmm  <- (1/25.4)
  inches    <- inchesmm*pdfSizes[paperSize,]

  # tipo
  type      <- capabilities(c("cairo"))
  ext       <- capabilities(c("jpeg", "png", "tiff"))

  # actualiza los valores
  options$paperSize <- paperSize
  options$ppi       <- ppi
  options$width     <- inches$width*ppi
  options$height    <- inches$height*ppi
  options$cairo     <- type[c("cairo")]
  options$ext       <- ifelse(ext[c("png")], "png", ifelse(ext[c("jpeg")], "jpeg", ifelse(ext[c("tiff")], "tiff", "")))

  return(options)
}

# valida si la resolucion y tamaño de papel son correctos
validateDiagramOptions<-function(options) {
  return(validate(
    need(
      options$ppi==600 && options$paperSize>3 || options$ppi==300 && options$paperSize>1 || options$ppi<300,
      paste0(strings$value("MESSAGE_PAPERSIZE_ERROR_1"), options$ppi, strings$value("MESSAGE_PAPERSIZE_ERROR_2"), options$paperSize, collapse="")
    )
  ))
}

# imprime un diagrama en fichero
plotDiagram<-function(file, plot, options) {
  type<-ifelse(options$cairo, "cairo", "windows")
  pointsize<-12
  if(is.null(zgg$landscape_plot))
    zgg$landscape_plot <- TRUE
  if (zgg$landscape_plot){
    w <- options$height
    h <- options$width
  } else {
    h <- options$height
    w <- options$width
  }
  if (options$ext=="png") {
    png(filename=file, type=type, width=w, height=h, units="px", res=options$ppi, pointsize=pointsize)
  } else if (options$ext=="jpeg") {
    jpeg(filename=file, type=type, width=w, height=h, units="px", res=options$ppi, pointsize=pointsize)
  } else if (options$ext=="tiff") {
    tiff(filename=file, type=type, width=w, height=h, units="px", res=options$ppi, pointsize=pointsize)
  }
  plot(plot)
  dev.off()
}

# imprime el PDF con todos los diagramas un diagrama en fichero
plotPDF<-function(file, ziggurat, polar, options) {
  type<-ifelse(options$cairo, "cairo", "windows")
  pointsize<-12

  # imprime el PDF
  pdf(file=file, width=options$width/options$ppi, height=options$height/options$ppi, pointsize=pointsize, onefile=TRUE)
  plot(ziggurat$plot)
  plot(polar["polar_plot"][[1]])
  plot(arrangeGrob(polar["histo_dist"][[1]], polar["histo_core"][[1]], polar["histo_degree"][[1]], nrow=1, ncol=3))
  dev.off()
}

#
# proceso de servidor
#
#' Title
#'
#' @param input
#' @param output
#' @param session
#'
#' @return
#' @export
#'
#' @examples
shinyServer(function(input, output, session) {

  shinyjs::hide("polarDownload")
  shinyjs::hide("polarcodeDownload")
  shinyjs::hide("networkAnalysis")
  # shinyjs::hide("zigguratDownload")
  # shinyjs::hide("zigguratcodeDownload")

  # recibe cuendo el cliente esta listo
  observeEvent(input$windowLoad, {
    # crea los mensajes que se usan desde javascript
    messagesNames<-c("LABEL_ZIGGURAT_INFO_DETAILS_TYPE", "LABEL_ZIGGURAT_INFO_DETAILS_KCORE", "LABEL_ZIGGURAT_INFO_DETAILS_ID", "LABEL_ZIGGURAT_INFO_DETAILS_NAME", "LABEL_ZIGGURAT_INFO_DETAILS_KRADIUS", "LABEL_ZIGGURAT_INFO_DETAILS_KDEGREE", "MESSAGE_CONFIRM_DELETE_FILES", "MESSAGE_WIKIPEDIA_NO_INFO_ERROR", "MESSAGE_WIKIPEDIA_DOWNLOAD_ERROR")
    messages<-strings$value(messagesNames)
    names(messages)<-messagesNames

    # inicializa la lista de mensajes en javascript
    session$sendCustomMessage(type="messagesHandler", as.list(messages))
  })

  # contenido del fichero seleccionado
  selectedDataFileContent<-reactive({
    file<-input$selectedDataFile
    if (!is.null(file) && nchar(file)>0) {
      content<-read.csv(file=paste0(dataDir, "/", file), header=TRUE)
    } else {
      content<-data.frame()
    }
    if (!is.null(file) && nchar(file)>0){
      shinyjs::show("networkAnalysis")
      output$NodesGuildA <- renderText({ 
        paste(nrow(content),strings$value("LABEL_SPECIES"))
      })
      output$NodesGuildB <- renderText({ 
        paste(ncol(content)-1,strings$value("LABEL_SPECIES"))
      })
    }
    return(content)
  })

  # seleccion de ficheros cargados
  uploadedFilesList<-reactive({
    # obtiene los ficheros cargados
    files<-input$uploadedFiles

    if (is.null(files)) {
      files<-list(c(), c(), c(), c())
    } else {
      # realiza la copia de los ficheros
      for (i in 1:length(files$datapath)) {
        from  <- files$datapath[i]
        to    <- paste0(dataDir, "/", files$name[i])
        file.copy(from, to)
      }

      # refresca la lista de ficheros
      availableFiles$list<-availableFilesList()
    }

    # renombra las columnas
    names(files)<-c(strings$value("LABEL_UPLOADED_FILES_DETAILS_NAME"), strings$value("LABEL_UPLOADED_FILES_DETAILS_SIZE"), strings$value("LABEL_UPLOADED_FILES_DETAILS_TYPE"), "")

    # elimina las columnas sin nombre
    files<-files[!(names(files) %in% c(""))]

    # Condition met when the application starts
    if(is.null(files$Filename))
      files <- data.frame(Filename = " ", Size = " ", Type = " ")

    # devuelve los ficheros cargados
    return(files)
  })

  # lista de ficheros disponibles
  availableFiles<-reactiveValues(list=list(), details=list())

  # lista de nodos marcados en el ziggurat
  markedNodes<-reactiveValues(data=data.frame())

  # actua ante los cambios en la lista de ficheros disponibles
  observeEvent(availableFiles$list, {
      availableFiles$details<-availableFilesDetails(availableFiles$list)
      updateSelectInput(session, "selectedDataFile", choices=availableFiles$list)
  })

  # actua ante los cambios de seleccion en el panel de datos
  observeEvent(input$dataPanel, {
    # refresca la lista de ficheros
    availableFiles$list<-availableFilesList()
  })

  # boton de refresco de la lista de ficheros
  observeEvent(input$refreshFiles, {
    # refresca la lista de ficheros
    availableFiles$list<-availableFilesList()
    output$availableFilesTable = DT::renderDataTable(availableFiles$details,
                                                     options = list(pageLength = 5),
                                                     server = TRUE)
  })

  output$availableFilesTable <-DT::renderDataTable(
    availableFiles$details,
    options = list(pageLength = 5)
  )

  observeEvent(input$deleteFiles, {
    s = input$availableFilesTable_rows_selected
    output$availableFilesTable = DT::renderDataTable(availableFiles$details,
                                                     options = list(pageLength = 5),
                                                     server = TRUE)
    q <- availableFiles$details[s,]
    rn <- rownames(q)
    for (j in rn)
      file.remove(j)
    availableFiles$list<-availableFilesList()
    output$availableFilesTable = DT::renderDataTable(availableFiles$details,
                                                     options = list(pageLength = 5),
                                                     server = TRUE)
    # invoca a la funcion javascript que devuelve la lista de ficheros que se muestran para ser borrados
    #session$sendCustomMessage(type="deleteFilesHandler","availableFilesTable")
      })


  # realiza la accion de borrado de los ficheros
  # observeEvent(input$deleteFilesData, {
  #   # borra los ficheros
  #   data      <- input$deleteFilesData
  #   print(data)
  #   fileList  <- unlist(data$fileList)
  #   #file.remove(paste0(dataDir, "/", fileList))
  #
  #   # refresca la lista de ficheros
  #   availableFiles$list<-availableFilesList()
  # })

  observeEvent(input$ResetAll, {
    session = getDefaultReactiveDomain()
    session$reload()
  })

  # actualiza el grafico ziggurat en base a los controles de
  # configuracion
  ziggurat<-reactive({

    validate(
      need(nchar(input$selectedDataFile)>0, strings$value("MESSAGE_SELECT_DATE_FILE_ERROR"))
    )
    # funcion para eliminar espacios
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)

    # vacia los nodos seleccionados
    markedNodes$data<-data.frame()

    # indicador de progreso
    progress<-shiny::Progress$new()
    progress$set(message="", value = 0)

    # cierra el indicador al salir
    on.exit(progress$close())

    # deshabilita el contenedor del ziggurat
    session$sendCustomMessage(type="disableDivHandler", list(id="ziggurat", disable=TRUE))

    # genera el diagrama ziggurat
    z<-ziggurat_graph(
      datadir                                       = paste0(dataDir, "/"),
      filename                                      = input$selectedDataFile,
      paintlinks                                    = input$zigguratPaintLinks,
      print_to_file                                 = FALSE,
      plotsdir                                      = tempdir(),
      alpha_level                                   = input$zigguratAlphaLevel,
      color_guild_a                                 = c(input$zigguratColorGuildA1, input$zigguratColorGuildA2),
      color_guild_b                                 = c(input$zigguratColorGuildB1, input$zigguratColorGuildB2),
      color_link                                    = input$zigguratColorLink,
      alpha_link                                    = input$zigguratAlphaLevelLink,
      size_link                                     = input$zigguratLinkSize,
      #displace_y_b                                  = rep(0, input$zigguratYDisplaceGuildB),
      displace_y_a                                  = c(0, input$zigguratYDisplaceSA2, input$zigguratYDisplaceSA3,
                                                        input$zigguratYDisplaceSA4,input$zigguratYDisplaceSA5,
                                                        input$zigguratYDisplaceSA6,input$zigguratYDisplaceSA7,
                                                        input$zigguratYDisplaceSA8,input$zigguratYDisplaceSA8,
                                                        input$zigguratYDisplaceSA10,input$zigguratYDisplaceSA11,
                                                        input$zigguratYDisplaceSA12),
      displace_y_b                                  = c(0, input$zigguratYDisplaceSB2, input$zigguratYDisplaceSB3,
                                                        input$zigguratYDisplaceSB4,input$zigguratYDisplaceSB5,
                                                        input$zigguratYDisplaceSB6,input$zigguratYDisplaceSB7,
                                                        input$zigguratYDisplaceSB8,input$zigguratYDisplaceSB8,
                                                        input$zigguratYDisplaceSB10,input$zigguratYDisplaceSB11,
                                                        input$zigguratYDisplaceSB12),
      lsize_kcoremax                                = input$zigguratLabelsSizekCoreMax,
      lsize_zig                                     = input$zigguratLabelsSizeZiggurat,
      lsize_kcore1                                  = input$zigguratLabelsSizekCore1,
      lsize_legend                                  = input$zigguratLabelsSizeLegend,
      lsize_core_box                                = input$zigguratLabelsSizeCoreBox,
      labels_color                                  = c(input$zigguratColorLabelGuildA, input$zigguratColorLabelGuildB),
      height_box_y_expand                           = input$zigguratHeightExpand,
      kcore2tail_vertical_separation                = input$zigguratKcore2TailVerticalSeparation,
      kcore1tail_disttocore                         = c(input$zigguratKcore1TailDistToCore1, input$zigguratKcore1TailDistToCore2),
      innertail_vertical_separation                 = input$zigguratInnerTailVerticalSeparation,
      #horiz_kcoremax_tails_expand                   = input$ziggurathoriz_kcoremax_tails_expand,
      factor_hop_x                                  = input$zigguratHopx,
      displace_legend                               = c(input$zigguratdisplace_legend_horiz,input$zigguratdisplace_legend_vert),
      fattailjumphoriz                              = c(input$zigguratfattailjumphorizA,input$zigguratfattailjumphorizB),
      fattailjumpvert                               = c(input$zigguratfattailjumpvertA,input$zigguratfattailjumpvertB),
      coremax_triangle_height_factor                = input$zigguratCoreMaxHExp,
      coremax_triangle_width_factor                 = input$zigguratCoreMaxWExp,
      paint_outsiders                               = input$zigguratPaintOutsiders,
      displace_outside_component                    = c(input$zigguratoutsiders_expand_horiz,input$zigguratoutsiders_expand_vert),
      outsiders_separation_expand                   = input$zigguratoutsiders_separation_expand,
      outsiders_legend_expand                       = input$zigguratoutsiders_legend_expand,
      weirdskcore2_horizontal_dist_rootleaf_expand  = input$zigguratroot_weirdskcore2_vert,
      weirdskcore2_vertical_dist_rootleaf_expand    = input$zigguratroot_weirdskcore2_horiz,
      weirds_boxes_separation_count                 = input$zigguratroot_weird_boxesseparation,
      root_weird_expand                             = c(input$zigguratroot_weird_expand_horiz,input$zigguratroot_weird_expand_vert),
      hide_plot_border                              = TRUE,
      rescale_plot_area                             = c(1,1),
      kcore1weirds_leafs_vertical_separation        = input$zigguratkcore1weirds_leafs_vertical_separation,
      corebox_border_size                           = input$zigguratCoreBoxSize,
      kcore_species_name_display                    = c(),
      kcore_species_name_break                      = c(),
      shorten_species_name                          = 0,
      label_strguilda                               = trim(input$DataLabelGuildAControl),
      label_strguildb                               = trim(input$DataLabelGuildBControl),
      landscape_plot                                = input$LandscapeControl,
      backg_color                                   = input$zigguratBckgdColorControl,
      show_title                                    = TRUE,
      use_spline                                    = input$zigguratUseSpline,
      spline_points                                 = input$zigguratSplinePoints,
      square_nodes_size_scale                       = input$ziggurat1shellExpandControl,
      weighted_links                                = input$zigguratweighted_links,
      svg_scale_factor                              = 25*input$zigguratSvgScaleFactor,
      move_all_SVG_up                               = 0.01*input$zigguratSVGup,
      aspect_ratio                                  = input$zigguratAspectRatio,     #input$zigguratAspectRatio only works for non interactive ziggurats
      progress                                      = progress
    )

    # igraph del ziggurat
    g<-z$result_analysis$graph

    # posiciones de los nodos de cada guild
    guildAVertex<-which(V(g)$guild_id=="a")
    guildBVertex<-which(V(g)$guild_id=="b")

    # vecinos para cada nodo
    guildANeighbors<-sapply(guildAVertex, function(x) {neighbors(g, x)$id})
    guildBNeighbors<-sapply(guildBVertex, function(x) {neighbors(g, x)$id})

    # informa de los datos del ziggurat
    session$sendCustomMessage(type="zigguratDataHandler", list(ids=c("a", "b"), names=c(z$name_guild_a, z$name_guild_b), data=list(a=z$list_dfs_a, b=z$list_dfs_b), neighbors=list(a=guildANeighbors, b=guildBNeighbors)))

    # habilita el contenedor del ziggurat
    session$sendCustomMessage(type="disableDivHandler", list(id="ziggurat", disable=FALSE))

    return(z)
  })

  # actualiza la informacion sobre los nodos del ziggurat seleccionados
  observeEvent(input$markedNodesData, {
    result    <- data.frame(guild=character(0), kcore=integer(0), nodeId=integer(0), stringsAsFactors=FALSE)
    nodesData <- input$markedNodesData
    guilds    <- nodesData[grep("\\.guild", names(nodesData))]
    kcores    <- as.integer(nodesData[grep("\\.kcore", names(nodesData))])
    if (!is.null(guilds) && length(guilds)>0) {
      for (i in 1:length(guilds)) {
        nodeIds <- as.integer(nodesData[grep(paste0("^", i, "\\.nodeIds"), names(nodesData))])
        row     <- data.frame(guild=guilds[i], kcore=kcores[i], nodeId=nodeIds, row.names=NULL, stringsAsFactors=FALSE)
        result  <- rbind(result, row)
      }
    }
    row.names(result)<-NULL
    markedNodes$data<-result
  })

  # muestra el contenido de un fichero subido al servidor
  output$selectedDataFileContent<-renderDataTable(
    selectedDataFileContent(),
    options = list(pageLength=10, lengthMenu=list(c(10, 25, 50, -1), list('10', '25', '50', 'Todos')), searching=TRUE)
  )

  # muestra la lista de los ultimos ficheros subidos al servidor
  output$uploadedFilesTable<-renderDataTable(
    uploadedFilesList(),
    options=list(pageLength=5, lengthMenu=list(c(5, 10, 25, 50, -1), list('5', '10', '25', '50', 'Todos')), searching=FALSE)
  )

  # muestra la lista de los ficheros disponibles en el servidor
  # output$availableFilesTable<-renderDataTable(
  #   availableFiles$details,
  #   options=list(pageLength=5,
  #                selection = "multiple",
  #                lengthMenu=list(c(5, 10, 25, 50, -1),
  #                                list('5', '10', '25', '50', 'Todos')),
  #                searchDelay = 500,
  #                searching=TRUE)
  # )




  # muestra el diagrama ziggurat y lanza la funcion que actualiza los
  # eventos javascript para los elementos del grafico
  output$ziggurat<-renderUI({
    z<-ziggurat()
    svg<-z$svg
    html<-paste0(svg$html(), "<script>updateSVGEvents()</script>")
    # shinyjs::show("zigguratDownload")
    # shinyjs::show("zigguratcodeDownload")
    return(HTML(html))
  })

  # muestra los destalles de un nodo seleccionado del grafico ziggurat
  output$zigguratNodesDetail<-renderUI({
    z         <- ziggurat()
    nodesData <- markedNodes$data
    details   <- ""
    if (nrow(nodesData)>0) {
      # ordena los nodos seleccionados
      nodesData <- nodesData[order(ifelse(nodesData$guild=="a", 0, 1), -nodesData$kcore, nodesData$nodeId),]
      # muestra los datos de cada nodo seleccionado
      for (i in 1:nrow(nodesData)) {
        guild   <- nodesData[i, "guild"]
        type    <- ifelse(guild=="a", z$name_guild_a, z$name_guild_b)
        kcore   <- as.integer(nodesData[i, "kcore"])
        nodeId  <- as.integer(nodesData[i, "nodeId"])

        if (guild=="a") {
          # selecciona los datos del k-core
          kcore_df<-z$list_dfs_a[[kcore]]
        } else {
          # selecciona los datos del k-core
          kcore_df<-z$list_dfs_b[[kcore]]
        }
        # selecciona y muestra los elementos del dataframe a partir de la lista que se ha recibido
        nodeDf  <- kcore_df[kcore_df$label==nodeId, c("label", "name_species", "kdegree", "kradius")]
        details <- paste(details, showNodeDetails(type, kcore, nodeDf), collapse="")
      }
    }

    # truqui para el scroll
    details<-paste(details, "<script>updateZigguratNodesDetailScroll()</script>")
    return(HTML(details))
  })

  # informacion de Wiki
  output$zigguratWikiDetail<-renderUI({
      z         <- ziggurat()
      nodesData <- markedNodes$data
      details   <- ""
      if (nrow(nodesData)>0) {
        # ordena los nodos seleccionados
        nodesData <- nodesData[order(ifelse(nodesData$guild=="a", 0, 1), -nodesData$kcore, nodesData$nodeId),]
        # muestra la pestaña de cada nodo seleccionado
        types   <- ifelse(nodesData$guild=="a", z$name_guild_a, z$name_guild_b)
        details <- paste(details, showWiki(types, nodesData), collapse="")
      }

      return(HTML(details))
  })

  # selelecciona la pestaña de detalle de la wikipedia
  observeEvent(input$wikiPanelName, {
    updateTabsetPanel(session, "wikiTabsetPanel", selected=input$wikiPanelName)
  })

  netanalysis <- reactive({
    # indicador de progreso
    progress<-shiny::Progress$new()
    progress$set(message=strings$value("MESSAGE_ANALYSIS_POGRESS"), value = 0)

    # cierra el indicador al salir
    on.exit(progress$close())

    red <- input$selectedDataFile
    red_name <- strsplit(red,".csv")[[1]][1]
    result_analysis <- analyze_network(red, directory = paste0(dataDir, "/"),
                                       guild_a = input$DataLabelGuildAControl, guild_b = input$DataLabelGuildBControl, plot_graphs = FALSE)
    numlinks <- result_analysis$links
    results_indiv <- data.frame(Name = c(), Species = c(), kradius = c(), kdegree = c(), kshell = c(), krisk = c())
    clase <- grepl(input$DataLabelGuildAControl,V(result_analysis$graph)$name)
    
    for (i in V(result_analysis$graph)){
      if (clase[i])
        nom_spe <- names(result_analysis$matrix[1,])[as.integer(strsplit(V(result_analysis$graph)$name[i],input$DataLabelGuildAControl)[[1]][2])]
      else
        nom_spe <- names(result_analysis$matrix[,1])[as.integer(strsplit(V(result_analysis$graph)$name[i],input$DataLabelGuildBControl)[[1]][2])]
      results_indiv <- rbind(results_indiv,data.frame(Name = gsub("\\."," ",nom_spe),
                                                      Species =V(result_analysis$graph)$name[i], 
                                                      kradius = V(result_analysis$graph)$kradius[i],
                                                      kdegree = V(result_analysis$graph)[i]$kdegree, kshell = V(result_analysis$graph)[i]$kcorenum,
                                                      krisk = V(result_analysis$graph)[i]$krisk))
    }
    results_indiv$degree <- igraph::degree(result_analysis$graph)
    dir.create("analysis_indiv/", showWarnings = FALSE)
    fsal <- paste0("analysis_indiv/",red_name,"_analysis.csv")
    write.table(results_indiv,file=fsal,row.names=FALSE,sep = ";")
    return(fsal)
  })


  # actualiza el grafico polar en base a los controles de
  # configuracion
  polar<-reactive({
    validate(
      need(nchar(input$selectedDataFile)>0, strings$value("MESSAGE_SELECT_DATE_FILE_ERROR"))
    )

    swidth = input$screenwidthControl
    sheight = input$screenwidthControl

    # indicador de progreso
    progress<-shiny::Progress$new()
    progress$set(message="", value = 0)

    # cierra el indicador al salir
    on.exit(progress$close())

    # deshabilita el contenedor del polar e histogramas
    session$sendCustomMessage(type="disableDivHandler", list(id="polar", disable=TRUE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramDist", disable=TRUE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramCore", disable=TRUE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramDegree", disable=TRUE))

    # genera el diagrama polar y los histogramas
    p<-polar_graph(
      red                 = input$selectedDataFile,
      directorystr        = paste0(dataDir, "/"),
      fill_nodes          = input$polarFillNodesControl,
      alpha_nodes         = input$polarAlphaLevel,
      plotsdir            = normalizePath("tmppolar/"),
      print_to_file       = TRUE,
      printable_labels    = input$polarDisplayText,
      show_histograms     = input$polarDisplayHistograms,
      glabels             = c(input$DataLabelGuildAControl, input$DataLabelGuildBControl),
      gshortened          = c("pl","pol"),
      lsize_title         = input$polarLabelsSizeTitle,
      lsize_axis          = input$polarLabelsSizeAxis,
      lsize_legend        = input$polarLabelsSizeLegend,
      lsize_axis_title    = input$polarLabelsSizeAxisTitle,
      lsize_legend_title  = input$polarLabelsSizeLegendTitle,
      progress            = progress
    )

    # habilita el contenedor del polar e histogramas
    session$sendCustomMessage(type="disableDivHandler", list(id="polar", disable=FALSE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramDist", disable=FALSE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramCore", disable=FALSE))
    session$sendCustomMessage(type="disableDivHandler", list(id="histogramDegree", disable=FALSE))

    return(p)
  })

  output$polar <- renderImage({
    p <- polar()
    shinyjs::show("polarDownload")
    shinyjs::show("polarcodeDownload")
    # Return a list containing the filename
    list(src = normalizePath(p["polar_file"][[1]]),
         contentType = 'image/png',
         width = input$screenwidthControl,
         height = input$screenwidthControl,
         alt = "Polar graph")
    }, deleteFile = FALSE)


  # Opciones para generar el diagrama, indicando ancho,alto en pixels, calidad en ppi (points-per-inch)
  # y otras opciones para generar el diagrama (png/jpg/..., tipo "cairo" u otros)
  diagramOptions<-reactive({
    return(calculateDiagramOptions(as.numeric(input$paperSize), as.numeric(input$ppi)))
  })

  # boton de descarga del diagrama ziggurat
  output$zigguratDownload<-downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-ziggurat." , diagramOptions()$ext)
      return(file)
    },
    content=function(file) {
      # valida las dimensiones/resolucion
      options<-diagramOptions()
      validateDiagramOptions(options)

      # obtiene el diagrama
      z<-ziggurat()
      plot<-z$plot
      plotDiagram(file, plot, options)
    },
    contentType=paste0("image/", diagramOptions()$ext)
  )

  output$polarDownload <- downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-polar." , diagramOptions()$ext)
      return(file)
    },
    content <- function(file) {
      options<-diagramOptions()
      validateDiagramOptions(options)
      dir.create("tmppolar/", showWarnings = FALSE)
      p <- polar()
      file.copy(normalizePath(p["polar_file"][[1]]), file)
    },
    contentType=paste0("image/", diagramOptions()$ext)
  )

  session$onSessionEnded(function() { unlink("analysis_indiv", recursive = TRUE) 
                                      unlink("tmpcode", recursive = TRUE)
                                      unlink("tmppolar", recursive = TRUE)})
  
  output$networkAnalysis <- downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-analyisis.csv")
      return(file)
    },
    content <- function(file) {
      fresults <- netanalysis()
      file.copy(fresults, file)    },
    contentType="text/csv"
  ) 

  #Aux function to add a parameter and reproduce the function call
  addCallParam <- function(com,lpar,param,quoteparam = FALSE)
  {
    if (quoteparam)
      com <- paste0(com," ,",param," = \"",lpar[param],"\"")
    else
      com <- paste0(com," ,",param," = ",lpar[param])
    return(com)
  }

  output$polarcodeDownload <- downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-polar-code.txt")
      return(file)
    },
    content <- function(file) {
      p <- polar()
      dir.create("tmpcode/", showWarnings = FALSE)
      sink("tmpcode/codepolar.txt")
      llamada <- p["polar_argg"]
      comando <- paste0("polg <- polar_graph(\"",llamada$polar_argg$red,"\",")
      comando <- paste0(comando, "directorystr = \"",llamada$polar_argg$directorystr,"\"")
      comando <- paste0(comando,",plotsdir = \"plot_results/polar/\",print_to_file = TRUE,")
      comando <- paste0(comando,"glabels = c(\"",llamada$polar_argg$glabels[1],"\",\"",llamada$polar_argg$glabels[2],"\"),")
      comando <- paste0(comando,"gshortened = c(\"",llamada$polar_argg$gshortened[1],"\",\"",llamada$polar_argg$gshortened[2],"\")")
      comando <- addCallParam(comando,llamada$polar_argg,"show_histograms")
      comando <- addCallParam(comando,llamada$polar_argg,"lsize_title")
      comando <- addCallParam(comando,llamada$polar_argg,"lsize_axis")
      comando <- addCallParam(comando,llamada$polar_argg,"lsize_legend")
      comando <- addCallParam(comando,llamada$polar_argg,"lsize_axis_title")
      comando <- addCallParam(comando,llamada$polar_argg,"file_name_append",quote = TRUE)
      comando <- addCallParam(comando,llamada$polar_argg,"print_title")
      comando <- paste0(comando,",progress = NULL")
      comando <- addCallParam(comando,llamada$polar_argg,"fill_nodes")
      comando <- addCallParam(comando,llamada$polar_argg,"alpha_nodes")
      comando <- addCallParam(comando,llamada$polar_argg,"printable_labels")
      comando <- paste0(comando,")")
      cat(comando)
      sink()
      file.copy("tmpcode/codepolar.txt", file)
    },
    contentType="text/plain"
  )

  output$zigguratcodeDownload <- downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-ziggurat-code.txt")
      return(file)
    },
    content <- function(file) {
      p <- ziggurat()
      dir.create("tmpcode/", showWarnings = FALSE)
      sink("tmpcode/codeziggurat.txt")
      llamada <- zgg$ziggurat_argg
      comando <- paste0("ziggurat_graph(\"data/\"",",\"",llamada$filename,"\"")
      comando <- addCallParam(comando,llamada,"paintlinks")
      comando <- paste0(comando,",print_to_file = TRUE")
      comando <- paste0(comando,",plotsdir = \"plot_results/ziggurat\"")
      comando <- addCallParam(comando,llamada,"alpha_level")
      comando <- paste0(comando,",color_guild_a = c(\"",llamada$color_guild_a[1],"\",\"",llamada$color_guild_a[1],"\")")
      comando <- paste0(comando,",color_guild_b = c(\"",llamada$color_guild_b[1],"\",\"",llamada$color_guild_b[1],"\")")
      comando <- paste(comando,"\n")
      comando <- addCallParam(comando,llamada,"alpha_link")
      comando <- addCallParam(comando,llamada,"size_link")
      comando <- addCallParam(comando,llamada,"color_link", quote = TRUE)
      comando <- paste0(comando,",displace_y_b = ",paste("c(",paste(llamada$displace_y_b,collapse=",")),")")
      comando <- paste0(comando,",displace_y_a = ",paste("c(",paste(llamada$displace_y_a,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"lsize_kcoremax")
      comando <- addCallParam(comando,llamada,"lsize_zig")
      comando <- addCallParam(comando,llamada,"lsize_kcore1")
      comando <- addCallParam(comando,llamada,"lsize_legend")
      comando <- addCallParam(comando,llamada,"lsize_core_box")
      comando <- addCallParam(comando,llamada,"labels_color")
      comando <- addCallParam(comando,llamada,"height_box_y_expand")
      comando <- addCallParam(comando,llamada,"kcore2tail_vertical_separation")
      #comando <- paste(comando,"\n")
      comando <- paste0(comando,",kcore1tail_disttocore = ",paste("c(",paste(llamada$kcore1tail_disttocore,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"innertail_vertical_separation")
      comando <- addCallParam(comando,llamada,"factor_hop_x")
      comando <- paste0(comando,",displace_legend = ",paste("c(",paste(llamada$displace_legend,collapse=",")),")")
      comando <- paste0(comando,",fattailjumphoriz = ",paste("c(",paste(llamada$fattailjumphoriz,collapse=",")),")")
      comando <- paste0(comando,",fattailjumpvert = ",paste("c(",paste(llamada$fattailjumpvert,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"coremax_triangle_height_factor")
      comando <- addCallParam(comando,llamada,"paint_outsiders")
      comando <- paste0(comando,",displace_outside_component = ",paste("c(",paste(llamada$displace_outside_component,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"coremax_triangle_width_factor")
      comando <- addCallParam(comando,llamada,"outsiders_separation_expand")
      comando <- addCallParam(comando,llamada,"outsiders_legend_expand")
      comando <- addCallParam(comando,llamada,"weirdskcore2_horizontal_dist_rootleaf_expand")
      comando <- addCallParam(comando,llamada,"weirdskcore2_vertical_dist_rootleaf_expand")
      comando <- addCallParam(comando,llamada,"weirds_boxes_separation_count")
      #comando <- paste(comando,"\n")
      comando <- paste0(comando,",root_weird_expand = ",paste("c(",paste(llamada$root_weird_expand,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"hide_plot_border")
      comando <- paste0(comando,",rescale_plot_area = ",paste("c(",paste(llamada$rescale_plot_area,collapse=",")),")")
      comando <- addCallParam(comando,llamada,"kcore1weirds_leafs_vertical_separation")
      comando <- addCallParam(comando,llamada,"corebox_border_size")
      comando <- addCallParam(comando,llamada,"label_strguilda", quote = TRUE)
      comando <- addCallParam(comando,llamada,"label_strguildb", quote = TRUE)
      #comando <- paste(comando,"\n")
      if (is.null(llamada$landscape_plot))
        llamada$landscape_plot <- TRUE
      comando <- addCallParam(comando,llamada,"landscape_plot")
      comando <- addCallParam(comando,llamada,"backg_color", quote = TRUE)
      comando <- addCallParam(comando,llamada,"show_title")
      comando <- addCallParam(comando,llamada,"use_spline")
      comando <- addCallParam(comando,llamada,"spline_points")
      comando <- addCallParam(comando,llamada,"file_name_append", quote =TRUE)
      comando <- addCallParam(comando,llamada,"svg_scale_factor")
      comando <- addCallParam(comando,llamada,"weighted_links", quote =TRUE)
      comando <- addCallParam(comando,llamada,"square_nodes_size_scale")
      comando <- addCallParam(comando,llamada,"move_all_SVG_up")
      comando <- paste0(comando,",progress = NULL")
      comando <- paste0(comando,")")
      cat(comando)
      sink()
      file.copy("tmpcode/codeziggurat.txt", file)
    },
    contentType="text/plain"
  )



})

