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
source("ziggurat_graph.R", encoding="UTF-8")

# muestra una fila en el detalle con [etiqueta, valor]
detailRow <- function(label, value) {
  label   <- tags$b(label)
  value   <- paste0(value, collapse="")
  if (length(grep(pattern = "^http", x = value, ignore.case = TRUE))>0 || length(grep(pattern = "^javascript", x = value, ignore.case = TRUE))>0) {
    value <- tags$a(value, href = value)  
  } else {
    value <- tags$div(value)
  }
  return(fluidRow(column(2, tags$small(label)), column(6, tags$small(value))))
}

# muestra la informacion de detalle sobre un conjunto de elementos
showElements <- function(elementsDf) {
  # tamanyo de las columnas
  sizes<-c(1, 5, 2, 2)
  
  # crea la cabecera
  columns <- ""
  values  <- c("#", "Nombre", "k-radius", "k-degree")
  for (i in 1:length(values)) {
    if (nchar(columns)>0) {
      columns<-paste0(columns, ", ")
    }
    value   <- paste0("tags$b(\"", values[i], "\")") 
    columns <- paste0(columns, "column(", sizes[i], ", tags$small(", value, "))")
  }
  rows<-eval(parse(text=paste0("fluidRow(", columns, ")")))
  
  # crea las filas
  for (i in 1:nrow(elementsDf)) {
    label   <- elementsDf[i, c("label")]
    name    <- elementsDf[i, c("name_species")]
    label   <- paste0("tags$a(\"", label, "\", href=\"", paste0("javascript:showWiki(", label, ", '", name , "')"), "\")") 
    name    <- paste0("\"", name, "\"")
    kradius <- paste0("\"", round(elementsDf[i, c("kradius")], 2), "\"")
    kdegree <- paste0("\"", round(elementsDf[i, c("kdegree")], 2), "\"")
    columns <- ""
    values  <- c(label, name, kradius, kdegree) 
    for (i in 1:length(values)) {
      if (nchar(columns)>0) {
        columns<-paste0(columns, ", ")
      } 
      columns <- paste0(columns, "column(", sizes[i], ", tags$small(", values[i], "))")
    }
    rows<-paste(rows, eval(parse(text=paste0("fluidRow(", columns, ")"))))
  }
  return(rows)
}

# muestra la informacion de detalle sobre un elemento
showWiki <- function(elementData) {
  content<-""
  if (is.null(elementData)) {
    content<-paste(content,eval(parse(text="fluidRow()")))
  } else {
    tab<-""
    tab<-paste0(tab, "tabsetPanel(")
    tab<-paste0(tab, "tabPanel(\"")
    tab<-paste0(tab, elementData$id)
    tab<-paste0(tab, "\", fluidRow(")
    tab<-paste0(tab, "column(12, ")
    tab<-paste0(tab, "h6(\"(información descargada de Wikipedia para el elemento ")
    tab<-paste0(tab, elementData$name)
    tab<-paste0(tab, "...)\"")
    tab<-paste0(tab, ")))))")
    content<-paste(content, eval(parse(text=tab)))
  }
  return(content)
}

#
# proceso de servidor
#
shinyServer(function(input, output) {
  # seleccion de ficheros cargados
  uploadedFiles<-reactive({
    # obtiene los ficheros cargados
    files<-input$uploadedFiles
    if (is.null(files)) {
      files<-list(c(), c(), c(), c())
    }
    
    # renombra las columnas
    names(files)<-c("Nombre", "Tamaño", "Tipo", "")
    
    # elimina las columnas sin nombre
    files<-files[!(names(files) %in% c(""))]
    return(files)
  })

  # actualiza el grafico ziggurat en base a los controles de
  # configuracion
  ziggurat<-reactive({
    z<-ziggurat_graph(
      datadir                                       = "data/",
      filename                                      = input$selectedDataFile,
      paintlinks                                    = input$paintLinks,
      displaylabelszig                              = input$displayLabels,
      print_to_file                                 = FALSE,
      plotsdir                                      = "plot_results/ziggurat/",
      flip_results                                  = input$flipResults,
      aspect_ratio                                  = input$aspectRatio,
      alpha_level                                   = input$alphaLevel,
      color_guild_a                                 = c(input$colorGuildA1, input$colorGuildA2),
      color_guild_b                                 = c(input$colorGuildB1, input$colorGuildB2),
      color_link                                    = input$colorLink,
      alpha_link                                    = input$alphaLevelLink,
      size_link                                     = input$sizeLink,
      displace_y_b                                  = rep(0, input$yDisplaceGuildB),
      displace_y_a                                  = rep(0, input$yDisplaceGuildA),
      labels_size                                   = input$labelsSize,
      lsize_kcoremax                                = input$labelsSizekCoreMax,
      lsize_zig                                     = input$labelsSizeZiggurat,
      lsize_kcore1                                  = input$labelsSizekCore1,
      lsize_legend                                  = input$labelsSizeLegend,
      lsize_core_box                                = input$labelsSizeCoreBox,
      labels_color                                  = c(input$colorLabelGuildA, input$colorLabelGuildB),
      height_box_y_expand                           = input$heightExpand,
      kcore2tail_vertical_separation                = input$kcore2TailVerticalSeparation,
      kcore1tail_disttocore                         = c(input$kcore1TailDistToCore1, input$kcore1TailDistToCore2),
      innertail_vertical_separation                 = input$innerTailVerticalSeparation,
      horiz_kcoremax_tails_expand                   = 1,
      factor_hop_x                                  = 1,
      displace_legend                               = c(0,0),
      fattailjumphoriz                              = c(1,1),
      fattailjumpvert                               = c(1,1),
      coremax_triangle_height_factor                = 1,
      coremax_triangle_width_factor                 = 1,
      paint_outsiders                               = TRUE,
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
      corebox_border_size                           = 0.2,
      kcore_species_name_display                    = c(),
      kcore_species_name_break                      = c(),
      shorten_species_name                          = 0,
      label_strguilda                               = "",
      label_strguildb                               = "",
      landscape_plot                                = TRUE,
      backg_color                                   = "white",
      show_title                                    = TRUE,
      use_spline                                    = TRUE,
      spline_points                                 = 100,  
      #svg_scale_factor                              = input$svgScaleFactor
      svg_scale_factor                              = 50
    )
    return(z)
  })
  
  # actualiza la informacion sobre el nodo del grafico seleccionado
  nodeData<-reactive({
    data<-input$nodeData
    return(data)
  })

  # actualiza la informacion de detalle de un elemento
  elementData<-reactive({
    data<-input$elementData
    return(data)
  })

  # muestra el contenido de un fichero subido al servidor
  output$uploadedFilesContent<-renderDataTable({
    return(uploadedFiles())
  })

  # muestra el diagrama ziggurat y lanza la funcion que actualiza los 
  # eventos javascript para los elementos del grafico
  output$ziggurat<-renderUI({
    z   <- ziggurat()
    svg <- z$svg
    return(HTML(paste0(svg$html(), "<script>updateEvents()</script>")))
  })
  
  # muestra los destalles de un nodo seleccionado del grafico ziggurat
  output$zigguratDetails<-renderUI({
    z       <- ziggurat()
    data    <- nodeData()
    details <- ""
    if (!is.null(data)) {
      details <- paste(details, detailRow("Tipo", ifelse(data$guild=="a", z$name_guild_a, z$name_guild_b)), collapse="")
      details <- paste(details, detailRow("k-core", data$kcore), collapse="")
      if (data$kcore>1) {
        if (data$guild=="a") {
          kcore_df<-z$list_dfs_a[[data$kcore]]
        } else {
          kcore_df<-z$list_dfs_b[[data$kcore]]
        }
        # selecciona y muestra los elementos del dataframe a partir de la lista que se ha recibido
        elementsDf<-kcore_df[kcore_df$label==unlist(data$elements),c("label", "name_species", "kdegree", "kradius")]
        details <- paste(details, showElements(elementsDf), collapse="")
      }
    }
    #df<-z$list_dfs_a[[2]]
    #df<-z
    #for (name in names(df)) {
    #  details <- paste(details, detailRow(name, df[[name]]), collapse="")
    #}
    
    return(HTML(details))
  })

  # informacion de Wiki
  output$zigguratWikiDetails<-renderUI({
    data    <- elementData()
    details <- ""
    details <- paste(details, showWiki(data), collapse="")
    return(HTML(details))
  })

  # muestra el diagrama polar
  output$polar<-renderUI({
    return(tags$h2("(pendiente)"))
  })

  # muestra los histogramas
  output$histogram<-renderUI({
    return(tags$h2("(pendiente)"))
  })
      
  # informacion de la pagina de resumen
  output$summary<-renderText({
    text<-""
    text<-paste0(text, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non felis sed egestas. ")
    text<-paste0(text, "Nullam nec lorem orci. In volutpat urna sit amet porta vulputate. Quisque pharetra nunc ut fringilla vestibulum. ")
    text<-paste0(text, "Quisque mauris augue, vehicula id porttitor feugiat, ornare sed nibh. Etiam sed lectus mauris. Aliquam placerat quam id nibh lobortis euismod. ")
    text<-paste0(text, "Nam vel feugiat odio. Donec aliquet nibh quis felis aliquam accumsan. Aliquam elementum in neque et condimentum.")
    text<-paste0(text, "Nunc et ullamcorper elit, in pellentesque tellus.")
    return(text)
  })  
})