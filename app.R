library(shiny)
library(babette)

# Define user interface
ui <- fluidPage(
   shinyUI(
    navbarPage("beautier",
      tabPanel("Partitions",
        textInput("text", h3("Filename"), value = "anthus_aco.fas")
      ),
      tabPanel("Tip Dates"),
      tabPanel("Site Model"),
      tabPanel("Clock Model"),
      tabPanel("Priors"),
      tabPanel("MCMC")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

