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
        tabPanel("Site Model",
          numericInput("subst_rate", "Substitution rate", value = 1.0, min = 0.0, max = 1.0),
          numericInput("gamma_cat_count", "Gamma category count", value = 0, min = 0, step = 1),
          numericInput("prop_invariant", "Proportion invariant", value = 0.0, min = 0.0, max = 1.0),
          selectInput("subst_model", "Site model", choices = c("JC69", "HKY", "TN93", "GTR"))
        ),
        tabPanel("Clock Model"),
        tabPanel("Priors"),
        tabPanel("MCMC")
      ),
      mainPanel(
        h1("beautier command"),
        "Use this in your R scripts:",
        verbatimTextOutput("result"),
        h1("Produced XML"),
        verbatimTextOutput("xml"),
        width = 12
      )
    )
  )
)

create_site_model_text <- function(subst_model) {
  if (subst_model == "JC69") {
    return ("create_jc69_site_model()")
  }
  if (subst_model == "HKY") {
    return ("create_hky_site_model()")
  }
  if (subst_model == "TN93") {
    return ("create_tn93_site_model()")
  }
  if (subst_model == "GTR") {
    return ("create_gtr_site_model()")
  }
}

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$result <- renderText({ 
    paste(
      "library(beautier)",
      "create_beast2_input(",
      paste0("  input_filenames = \"", input$filename, "\","),
      paste0("  site_models = ", create_site_model_text(input$subst_model)),
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

