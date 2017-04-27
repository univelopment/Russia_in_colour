# Libraries
source("libraries.R")

# Data is read only once: when the app is started
source("read_data.R")

# Function for plotting map
source("map_plotter.R")
source("helper.R")

# Download fonts
source("global.R")

# Server code itself
shinyServer(
  function(input, output, session) {
    
    # READ DATA ----
    inFile <- reactive({
      
      #Check contents of the file
      if (is.null(input$fileUpload_y)) {
        return(NULL)
      } else {
        init_file <- openxlsx::read.xlsx(input$fileUpload_y$datapath)
      }
    })
    
    # MERGE IT WITH INITIAL DATAFRAME ----
    fileMerger <- reactive({
      cols <- ncol(inFile())
      
      # Implicit facitity for multiple value columns in data
      if (grepl("[0-9]", inFile()[1, colnames(inFile()) == input$reg_select])) {
        
        # Merge (case with okato codes)
        init_file <- user_data(inFile(), merge_by_var = input$reg_select, merge_by_reg = FALSE)
        
        init_file[, (ncol(init_file) - cols + 2):ncol(init_file)] <- lapply(
          init_file[,(ncol(init_file) - cols + 2):ncol(init_file)],
          function(x)
            numericCutter(as.numeric(x),
                          as.numeric(input$pal_q_y), 
                          tilda = input$tilda, 
                          cont = input$contScale))
        
      } else {
        
        # Merge (case with region names)
        
        # Tranform user's columns to interval scale
        # + 2 (see example: initial dataset has 85 columns, we merge it with one with 4 columns)
        # One column is common, so in total we get 88 columns. The one for used for merge stays in
        # beginning of data. So we have 3 new data columns at 86, 87 and 88. If we just substract
        # 4, than we transform columns not intended for it (e.g. 84, 85). Adding one is not enough too
        # as we speaking about position indices
        init_file <- user_data(inFile(), input$reg_select)
        
        init_file[, (ncol(init_file) - cols + 2):ncol(init_file)] <- lapply(
          init_file[,(ncol(init_file) - cols + 2):ncol(init_file)],
          function(x)
            numericCutter(as.numeric(x), 
                          as.numeric(input$pal_q_y), 
                          tilda = input$tilda,
                          cont = input$contScale))
      }
      
      # Result
      init_file
    })
    
    # UPDATE SELECTORS ----
    observe({
      updateSelectInput(
        session,
        "reg_select",
        choices = colnames(inFile()))
      
    })
    
    observe({
      updateSelectInput(
        session,
        "var_select",
        choices = colnames(inFile()))
      
    })
    
    # CREATE PLOT ----
    plotInput <- function() {
      return(
        mapPlotter(user_data(NULL), 
                        input$data_selector, 
                        input$text_title, 
                        input$text_legend,
                        input$pal)
            )
    }
    
    plotInput_y <- eventReactive(input$plot_map, {
      mapPlotter(fileMerger(), 
                 input$var_select, 
                 input$text_title_y,
                 input$text_legend_y,
                 input$pal_y)
    })
    
    # DISPLAY IT (RENDER) ----
    output$myplot <- renderPlot({
      plotInput()
    })
    
    output$myplot_y <- renderPlot({
      plotInput_y()
    })
    
    # DOWNLOAD PLOT AS PNG ----
    
    # Wrappers for downloaders
    saver <- function(file, plot, device, scaler) {
      if (scaler == TRUE) {
        ggsave(file,
               plot = plot,
               device = device,
               width = 12,
               height = 6,
               units = "cm",
               scale = 2)
      } else {
        ggsave(file,
               plot = plot,
               device = device,
               width = 12,
               height = 6)
      }
    }
    
    downWrapper <- function(filename, file, plot, device, scaler) {
      sv <- downloadHandler(
        filename = filename,
        content = function(file) {
          saver(file, plot, device, scaler)
        }
      )
    }
    
    output$downloadPNG <- downWrapper("map.png", "", plotInput(), "png", TRUE)
    output$downloadPNG_y <- downWrapper("map.png", "", plotInput_y(), "png", TRUE)
    
    output$downloadEPS <- downWrapper("map.eps", "", plotInput(), cairo_ps, FALSE)
    output$downloadEPS_y <- downWrapper("map.eps", "", plotInput_y(), cairo_ps, FALSE)
    
  })
