library(shiny)
source("ziggurat_graph.R", encoding="UTF-8")

shinyServer(function(input, output) {  
  ziggurat<-reactive({
    z<-ziggurat_graph(
      datadir                                       = "data/",
      filename                                      = input$dataFile,
      paintlinks                                    = input$paintLinks,
      displaylabelszig                              = input$displayLabels,
      print_to_file                                 = FALSE,
      plotsdir                                      = "plot_results/ziggurat/",
      flip_results                                  = input$flipResults,
      aspect_ratio                                  = input$aspectRatio,
      alpha_level                                   = input$alphaLevel,
      color_guild_a                                 = c(input$colorGuildA1,input$colorGuildA2),
      color_guild_b                                 = c(input$colorGuildB1,input$colorGuildB2),
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
      labels_color                                  = c(input$colorLabelGuildA,input$colorLabelGuildB),
      height_box_y_expand                           = input$heightExpand,
      kcore2tail_vertical_separation                = 1,
      kcore1tail_disttocore                         = c(1,1),
      innertail_vertical_separation                 = 1,
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
      svg_scale_factor                              = input$svgScaleFactor
    )
    return(z)
  })
  
  output$summary<-renderText({
    return("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer scelerisque non felis sed egestas. Nullam nec lorem orci. In volutpat urna sit amet porta vulputate. Quisque pharetra nunc ut fringilla vestibulum. Quisque mauris augue, vehicula id porttitor feugiat, ornare sed nibh. Etiam sed lectus mauris. Aliquam placerat quam id nibh lobortis euismod. Nam vel feugiat odio. Donec aliquet nibh quis felis aliquam accumsan. Aliquam elementum in neque et condimentum. Nunc et ullamcorper elit, in pellentesque tellus.")
  })
  
  output$zigguratDetails<-renderUI({
    z<-ziggurat()
    details<-""
    df<-z$list_dfs_a[[2]]
    for (name in names(df)) {
        label   <- tags$b(name)
        value   <- paste0(df[[name]])
        if (length(grep(pattern = "^http", x = value, ignore.case = TRUE))>0) {
            value <- tags$a(value, href = value)  
        } else {
            value <- tags$div(value)
        }
        details <- paste(
                details, 
                fluidRow(column(4, tags$small(label)), column(6, tags$small(value))), 
                collapse = ""
        )
    }
    
    return(HTML(details))
    #return(HTML(tags$b("")))
  })
    
  output$ziggurat<-renderUI({
    z<-ziggurat()
    #svgFile<-file(paste0("", z$network_name, "_ziggurat.svg"))
    #svg<-readLines(svgFile)
    svg<-z$svg
              
    #json    <- network2Json(nw1())
    #script1 <- paste("<script>alert(JSON.parse('", json , "').nodes[0].name)</script>")
    #script1 <- paste("<script>alert('", json , "')</script>")
    #script2 <- paste("<script>paint(", "dataMiserables", ", 'ziggurat')</script>")
    #script2 <- paste("<script>paint(JSON.parse('", json, "'), 'ziggurat')</script>")
    #script3 <- paste("<script>alert('fin')</script>")
    script3 <- "<script>updateEvents()</script>"

    #HTML(paste(c(script1, script2, script3)))
    #return(HTML(paste(c(script3))))
    #return(HTML(paste0("", svg[2:length(svg)])))
    return(HTML(paste0(svg$html(),script3)))
  })
})