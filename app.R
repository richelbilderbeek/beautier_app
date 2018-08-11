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
          textInput("filename", h3("Filename"), value = beautier::get_beautier_path("anthus_aco_sub.fas"))
        ),
        tabPanel("Tip Dates"),
        tabPanel("Site Model"),
        tabPanel("Clock Model"),
        tabPanel("Priors"),
        tabPanel("MCMC")
      ),
      mainPanel(
        verbatimTextOutput("result"),
        verbatimTextOutput("xml")
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$result <- renderText({ 
    paste(
      "library(beautier)",
      "create_beast2_input(",
      paste0("  input_filenames = \"", input$filename, "\""),
      ")",
      sep = "\n", collapse = "\n"
    )
  })

  output$xml <- renderText({
    paste(create_beast2_input(input$filename), collapse = "\n")
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

