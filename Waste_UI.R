#install.packages("DT")
#install.packages("shinythemes")
#install.packages("intrval")
# install.packages("leaflet")
# install.packages("sf")
# install.packages("wesanderson"
library(shiny)
library(DT)
library(shinythemes)
library(intrval)
library("plyr")
library("rgeos")
library("maptools")

library(wesanderson)
library("shinydashboard")
library(RCurl)
library(plotly)
library(reshape)
library(shinyWidgets)

# install.packages("shinyWidgets")
#install.packages("shinydashboard")

e <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_Movement_Use_and_Treatment.csv")
waste_transported2017 <- read.csv(text = e)

waste_transported2017$Region <- gsub ("\\n","",waste_transported2017$Region)
waste_transported2017$Year <- as.numeric(waste_transported2017$Year)

    
                 
  ui <- dashboardPage(
    dashboardHeader(title = "Waste management in Armenia"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
        menuItem("Data", tabName = "data", icon = icon("table")),
        sliderInput("year_slider", h4("Choose year range"), min = 2008, max = 2017, value = c(2008,2017), step = NULL, round = FALSE),
        pickerInput(
          inputId = "yearExcluder", 
          label = "Select years to include/exclude", 
          choices = c(2008:2017), 
          options = list(
            `actions-box` = TRUE, 
            size = 10,
            `selected-text-format` = "count > 3"
          ), 
          multiple = TRUE
            
        ),
        
        prettyCheckboxGroup("region", "Select Region",  
                           choices= list(
                                         "Aragatsotn" = "Aragatsotn",
                                         "Ararat" = "Ararat",
                                         "Armavir" = "Armavir",
                                         "Gegharkunik" = "Gegharkunik",
                                         "Lori" = "Lori",
                                         "Kotayk" = "Kotayk",
                                         "Shirak" = "Shirak",
                                         "Syunik" = "Syunik",
                                         "Vayots Dzor" = "Vayots Dzor",
                                         "Yerevan city" = "Yerevan city"),selected = "Kotayk", animation = "smooth"
          
        ),
        actionButton("allreg","Select/Deselect All")
        
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "overview",
                fluidPage(
                  
                  fluidRow(
                    
                    
                      box(width = 6,
                      title = "Transportation and treatment", status = "warning",
                      plotlyOutput("WasteTransAndTreatment"),
                      prettyCheckboxGroup("categSelect",label = "Choose categories",choices =  list("Waste received from other organizations" = "Waste received from other organizations",
                                                                                                    "Waste transmitted to other organizations" = "Waste transmitted to other organizations",
                                                                                                    "Treated and destructed by other organizations" = "Treated and destructed by other organizations",
                                                                                                    "Waste used by organizations" = "Waste used by organizations",
                                                                                                    "Transported to landfills by means of organizations" = "Transported to landfills by means of organizations"),selected = c("Waste received from other organizations",
                                                                                                                                                                                                                              "Waste transmitted to other organizations",
                                                                                                                                                                                                                              "Treated and destructed by other organizations",
                                                                                                                                                                                                                              "Waste used by organizations",
                                                                                                                                                                                                                              "Transported to landfills by means of organizations")
                                          )
                      # valueBox(subtitle = tags$p("Tons per capita", style = "font-size: 100%;"),value = 20, width = 4, icon = icon("male"), color = "blue"),
                      # valueBox(subtitle = "Tons per square meter",value = 20, width = 4, icon = icon("weight-hanging"), color = "purple"),
                      # valueBox(subtitle = "Tons sent to landfills",value = 20, width = 4, icon = icon("circle"), color = "yellow")
                     
                              
                    ),
                    box(width = 6, height = 375,
                        title = "Waste Generated Over Time", status = "warning",
                        plotlyOutput("TotalGenWaste"),
                        textOutput("chosenRegions")
                        )
                              
                  ),
                  fluidRow(
                    box(width = 6, height = 375,
                        title = "Classification of waste  (2017, data incorrect)", status = "warning",
                        plotlyOutput("Classfication")
                        )
                  )
                )     
                ),
        tabItem(tabName = "data", 
                fluidPage(
                  fluidRow(
                    tabBox(
                      title = "Environmental Data",
                      # The id lets us use input$tabset1 on the server to find the current tab
                      id = "tabset1", width = 775,
                      tabPanel("Tab1", datatable(waste_transported2017)),
                      tabPanel("Tab2", "Tab content 2")
                    )
                  )
                ) 
                )
      )
      
    )
  )
  
  server <- function(input, output, session) {
    reg <- list(
                "Aragatsotn" = "Aragatsotn",
                "Ararat" = "Ararat",
                "Armavir" = "Armavir",
                "Gegharkunik" = "Gegharkunik",
                "Lori" = "Lori",
                "Kotayk" = "Kotayk",
                "Shirak" = "Shirak",
                "Syunik" = "Syunik",
                "Vayots Dzor" = "Vayots Dzor",
                "Yerevan city" = "Yerevan city")
    
    observe({
      if(input$allreg == 0) 
      {return(NULL)
        print("deselected")
        }
      else if (input$allreg%%2 == 0)
      {
        updatePrettyCheckboxGroup(session,"region","Select Region",reg)
        
      }
      else
      {
        updatePrettyCheckboxGroup(session, inputId = "region","Select Region",choices=reg ,selected=reg )
      }
      
    })
    
    output$WasteTransAndTreatment <- renderPlotly({
      transported2 <- waste_transported2017[-c(111),c(1:8)]
      transported2 <- melt(transported2, id.vars = c("Region","Year"), measure.vars = c("Waste.received.from.other.organizations",
                                                                                        "Waste.generated.during.the.year",
                                                                                        "Waste.transmitted.to.other.organizations",
                                                                                        "Treated.and.destructed.by.other.organizations",
                                                                                        "Waste.used.by.organizations",
                                                                                        "Transported.to.landfills.by.means.of.organizations"))
      transported2$value <- as.character(transported2$value)
      transported2$value <- gsub(" ",replacement = "",x = transported2$value)
      transported2$value <- gsub("-",replacement = "0",x = transported2$value)
      transported2$variable <- as.character(transported2$variable)
      transported2$variable <- gsub("\\.",replacement = " ",x = transported2$variable)
      transported2$value <- as.double(transported2$value)
      
      # transported2 <- ifelse(test = is.element("All Regions", c(input$region)),yes = transported2, no = transported2[transported2$Region %in% c(input$region),])
      
      if(input$allreg > 0) {
        transported2 <- transported2[transported2$Region %in% c(input$region) ,]
      } 
      
      transported2 <- transported2[transported2$Year %in% c(input$year_slider[1]:input$year_slider[2]),]
      transported2 <- transported2[transported2$variable %in% c(input$categSelect),]
      
      agregTable <- aggregate(transported2$value, by = list(transported2$Year, transported2$Region, transported2$variable), FUN = sum)
      colnames(agregTable) <- c("Year", "Region", "Category", "Quantity")
      
      
       print(
         ggplotly(height = 400,
        ggplot(agregTable, aes(x = Year, y = Quantity, fill = Category)) +
          geom_bar(stat = "identity", position = "stack") +
          scale_x_continuous(breaks=agregTable$Year) +
          ylab("Waste amount (in tons)") + 
          theme(legend.position = "none",
                axis.text.x = element_text(family = "Verdana",
                                           face = "plain"),
                axis.text.y = element_text(family = "verdana",
                                           face = "plain")
                
                  ) +
          scale_fill_manual(values=wes_palette(n = 5, name="Rushmore1"))
         )
       )
    })
    
    
    output$TotalGenWaste <- renderPlotly({
      transported2 <- waste_transported2017[-c(111),c(1:8)]
      transported2 <- melt(transported2, id.vars = c("Region","Year"), measure.vars = c("Waste.received.from.other.organizations",
                                                                                        "Waste.generated.during.the.year",
                                                                                        "Waste.transmitted.to.other.organizations",
                                                                                        "Treated.and.destructed.by.other.organizations",
                                                                                        "Waste.used.by.organizations",
                                                                                        "Transported.to.landfills.by.means.of.organizations"))
      transported2$value <- as.character(transported2$value)
      transported2$value <- gsub(" ",replacement = "",x = transported2$value)
      transported2$value <- gsub("-",replacement = "0",x = transported2$value)
      transported2$variable <- as.character(transported2$variable)
      transported2$variable <- gsub("\\.",replacement = " ",x = transported2$variable)
      transported2$value <- as.double(transported2$value)
      
      # transported2 <- ifelse(test = is.element("All Regions", c(input$region)),yes = transported2, no = transported2[transported2$Region %in% c(input$region),])
      
      if(input$allreg > 0) {
        transported2 <- transported2[transported2$Region %in% c(input$region) ,]
      } 
      
      transported2 <- transported2[transported2$Year %in% c(input$year_slider[1]:input$year_slider[2]),]
      agregTable <- aggregate(transported2$value, by = list(transported2$Year, transported2$Region, transported2$variable), FUN = sum)
      colnames(agregTable) <- c("Year", "Region", "Category", "Quantity")

      print(
        ggplotly(height = 300,
          ggplot(agregTable[agregTable$Category %in% c("Waste generated during the year"),], aes(x = Year, y = Quantity)) +
          geom_bar(stat = "identity", position = "stack") +
          scale_x_continuous(breaks=agregTable$Year) +
            ylab("Waste amount (in tons)") + 
            theme(legend.position = "none",
                  axis.text.x = element_text(family = "Verdana",
                                             face = "plain"),
                  axis.text.y = element_text(family = "verdana",
                                             face = "plain"),
                  panel.background = element_rect(fill = "white"),
                  panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                                  colour = "grey"), 
                  panel.grid.minor = element_blank()
                  
                  
            ) +
            scale_fill_manual(values=wes_palette(n = 1, name="Rushmore1"))
        )
      )

    })
    
  }

  shinyApp(ui = ui, server = server)

  # x <- ggplot(agregTable, aes(x = Year, y = Total_waste/1000000, fill = Category)) +
  #   geom_bar(stat = "identity", position = "stack" ) +
  #   scale_x_continuous(breaks=agregTable$Year)
  # x
  # 
  
  #Bullet graphs
  #Distributed Slope Chart
  #sparkline
  #simple box plot
  #Jquery knob