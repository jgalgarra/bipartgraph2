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
source("jga/ziggurat_graph.R", encoding="UTF-8")
source("jga/polar_graph.R", encoding="UTF-8")
source("global.R", encoding="UTF-8")

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
  if (options$ext=="png") {
    png(filename=file, type=type, width=options$width, height=options$height, units="px", res=options$ppi, pointsize=pointsize)
  } else if (options$ext=="jpeg") {
    jpeg(filename=file, type=type, width=options$width, height=options$height, units="px", res=options$ppi, pointsize=pointsize)
  } else if (options$ext=="tiff") {
    tiff(filename=file, type=type, width=options$width, height=options$height, units="px", res=options$ppi, pointsize=pointsize)
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
shinyServer(function(input, output, session) {
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
  })

  # borra los ficheros que se muestran en la lista de ficheros disponibles
  observeEvent(input$deleteFiles, {
    # invoca a la funcion javascript que devuelve la lista de ficheros que se muestran para ser borrados
    session$sendCustomMessage(type="deleteFilesHandler", "availableFilesTable")
  })

  # realiza la accion de borrado de los ficheros
  observeEvent(input$deleteFilesData, {
    # borra los ficheros
    data      <- input$deleteFilesData
    fileList  <- unlist(data$fileList)
    file.remove(paste0(dataDir, "/", fileList))
    
    # refresca la lista de ficheros
    availableFiles$list<-availableFilesList()
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
      displaylabelszig                              = input$zigguratDisplayLabels,
      print_to_file                                 = FALSE,
      plotsdir                                      = tempdir(),
      flip_results                                  = input$zigguratFlipResults,
      aspect_ratio                                  = input$zigguratAspectRatio,
      alpha_level                                   = input$zigguratAlphaLevel,
      color_guild_a                                 = c(input$zigguratColorGuildA1, input$zigguratColorGuildA2),
      color_guild_b                                 = c(input$zigguratColorGuildB1, input$zigguratColorGuildB2),
      color_link                                    = input$zigguratColorLink,
      alpha_link                                    = input$zigguratAlphaLevelLink,
      size_link                                     = input$zigguratLinkSize,
      displace_y_b                                  = rep(0, input$zigguratYDisplaceGuildB),
      displace_y_a                                  = rep(0, input$zigguratYDisplaceGuildA),
      labels_size                                   = input$zigguratLabelsSize,
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
      horiz_kcoremax_tails_expand                   = 1,
      factor_hop_x                                  = 1,
      displace_legend                               = c(0,0),
      fattailjumphoriz                              = c(1,1),
      fattailjumpvert                               = c(1,1),
      coremax_triangle_height_factor                = 1,
      coremax_triangle_width_factor                 = 1,
      paint_outsiders                               = input$zigguratPaintOutsiders,
      displace_outside_component                    = c(1,1),
      outsiders_separation_expand                   = 1,
      outsiders_legend_expand                       = 1,
      weirdskcore2_horizontal_dist_rootleaf_expand  = 1,
      weirdskcore2_vertical_dist_rootleaf_expand    = 0,
      weirds_boxes_separation_count                 = 1,
      root_weird_expand                             = c(1,1),
      hide_plot_border                              = TRUE,
      rescale_plot_area                             = c(1,1),
      kcore1weirds_leafs_vertical_separation        = 1,
      corebox_border_size                           = input$zigguratCoreBoxSize,
      kcore_species_name_display                    = c(),
      kcore_species_name_break                      = c(),
      shorten_species_name                          = 0,
      label_strguilda                               = trim(input$zigguratLabelGuildA),
      label_strguildb                               = trim(input$zigguratLabelGuildB),
      landscape_plot                                = TRUE,
      backg_color                                   = "white",
      show_title                                    = TRUE,
      use_spline                                    = input$zigguratUseSpline,
      spline_points                                 = input$zigguratSplinePoints,  
      #svg_scale_factor                              = input$zigguratSvgScaleFactor
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
  output$availableFilesTable<-renderDataTable(
    availableFiles$details,
    options=list(pageLength=5, lengthMenu=list(c(5, 10, 25, 50, -1), list('5', '10', '25', '50', 'Todos')), searching=TRUE)
  )

  # muestra el diagrama ziggurat y lanza la funcion que actualiza los 
  # eventos javascript para los elementos del grafico
  output$ziggurat<-renderUI({
    z<-ziggurat()
    svg<-z$svg
    html<-paste0(svg$html(), "<script>updateSVGEvents()</script>")
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

  # actualiza el grafico polar en base a los controles de
  # configuracion
  polar<-reactive({
    validate(
      need(nchar(input$selectedDataFile)>0, strings$value("MESSAGE_SELECT_DATE_FILE_ERROR"))
    )
    
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
      plotsdir            = tempdir(),
      print_to_file       = FALSE, 
      pshowtext           = input$polarDisplayText,
      show_histograms     = TRUE, 
      glabels             = c(input$polarGuildLabelA, input$polarGuildLabelB), 
      gshortened          = c(input$polarGuildLabelAShort, input$polarGuildLabelBShort),
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

  # muestra el diagrama polar
  output$polar<-renderPlot({
    p<-polar()
    print(p["polar_plot"][[1]])
  })

  # muestra los histogramas
  output$histogramDist<-renderPlot({
    p<-polar()
    print(p["histo_dist"][[1]])
  })

  # muestra los histogramas
  output$histogramCore<-renderPlot({
    p<-polar()
    print(p["histo_core"][[1]])
  })

  # muestra los histogramas
  output$histogramDegree<-renderPlot({
    p<-polar()
    if (!is.null(p)) {
      print(p["histo_degree"][[1]])
    }
  })

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
    
  # boton de descarga del diagrama polar
  output$polarDownload<-downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-polar." , diagramOptions()$ext)
      return(file)  
    },
    content=function(file) {
      # valida las dimensiones/resolucion
      options<-diagramOptions()
      validateDiagramOptions(options)
      
      # obtiene el diagrama
      p<-polar()
      plot<-p["polar_plot"][[1]]
      plotDiagram(file, plot, options)
    },
    contentType=paste0("image/", diagramOptions()$ext)
  )

  # boton de descarga de los histogramas
  output$histogramDownload<-downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-histogram." , diagramOptions()$ext)
      return(file)  
    },
    content=function(file) {
      # valida las dimensiones/resolucion
      options<-diagramOptions()
      validateDiagramOptions(options)
      
      # obtiene el diagrama
      p<-polar()
      plot<-arrangeGrob(p["histo_dist"][[1]], p["histo_core"][[1]], p["histo_degree"][[1]], nrow=1, ncol=3)
      plotDiagram(file, plot, diagramOptions())
    },
    contentType=paste0("image/", diagramOptions()$ext)
  )
  
  # boton de descarga en PDF
  output$pdfDownload<-downloadHandler(
    filename=function() {
      file<-paste0(gsub(fileExtension, "", input$selectedDataFile), "-all.pdf")
      return(file)  
    },
    content=function(file) {
      # valida las dimensiones/resolucion
      options<-diagramOptions()
      validateDiagramOptions(options)
      
      # obtiene el diagrama
      z<-ziggurat()
      p<-polar()
      plotPDF(file, z, p, options)
    },
    contentType="application/pdf"
  )  
})