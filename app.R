library(shiny)
library(babette)

# Define user interface
ui <- fluidPage(
  shinyUI(
    sidebarLayout(
      sidebarPanel = navbarPage(
        title = "beautier",
        tabPanel(
          title = "Partitions",
          textInput("filename", h3("Filename"), value = "anthus_aco.fas")
        ),
        tabPanel("Tip Dates"),
        tabPanel("Site Model"),
        tabPanel("Clock Model"),
        tabPanel("Priors"),
        tabPanel("MCMC")
      ),
      mainPanel(
        textOutput("result")
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$result <- renderText({ 
    paste("Filename:", input$filename)
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

