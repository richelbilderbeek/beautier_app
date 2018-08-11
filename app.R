library(shiny)
library(beautier)

# Define user interface
ui <- fluidPage(
  shinyUI(
    sidebarLayout(
      sidebarPanel = navbarPage(
        title = "beautier",
        tabPanel(
          title = "Partitions",
          textInput("filename", "Filename", value = beautier::get_beautier_path("anthus_aco_sub.fas"), width = "100%")
        ),
        tabPanel("Tip Dates"),
        tabPanel("Site Model",
          numericInput("subst_rate", "Substitution rate", value = 1.0, min = 0.0, max = 1.0),
          numericInput("gamma_cat_count", "Gamma category count", value = 0, min = 0, step = 1),
          numericInput("prop_invariant", "Proportion invariant", value = 0.0, min = 0.0, max = 1.0),
          selectInput("subst_model", "Site model", choices = c("JC69", "HKY", "TN93", "GTR"))
        ),
        tabPanel("Clock Model",
          selectInput("clock_model", "Clock model", choices = c("Strict Clock", "Relaxed Clock Log Normal"))
        ),
        tabPanel("Priors"),
        tabPanel("MCMC")
      ),
      mainPanel(
        hr(),
        h1("beautier command"),
        "Use this in your R scripts:",
        verbatimTextOutput("result"),
        h1("Produced XML"),
        "Just for your interest :-)",
        verbatimTextOutput("xml"),
        width = 12
      )
    )
  )
)

create_site_model_text <- function(subst_model) {
  if (subst_model == "JC69") {
    return("create_jc69_site_model()")
  }
  if (subst_model == "HKY") {
    return("create_hky_site_model()")
  }
  if (subst_model == "TN93") {
    return("create_tn93_site_model()")
  }
  if (subst_model == "GTR") {
    return("create_gtr_site_model()")
  }
}

create_clock_model_text <- function(clock_model) {
  if (clock_model == "Strict Clock") {
    return ("create_strict_clock_model()")
  }
  if (clock_model == "Relaxed Clock Log Normal") {
    return ("create_rln_clock_model()")
  }
}

create_beautier_cmd <- function(input) {
  paste(
    "create_beast2_input(",
    paste0("  input_filenames = \"", input$filename, "\","),
    paste0("  site_models = ", create_site_model_text(input$subst_model), ","),
    paste0("  clock_models = ", create_clock_model_text(input$clock_model)),
    ")",
    sep = "\n", collapse = "\n"
  )  
}
create_xml <- function(beautier_cmd) {
  paste(
    eval(parse(text = paste(beautier_cmd, collapse = ""))),
    collapse = "\n"
  )
}

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$result <- renderText({ 
    create_beautier_cmd(input)  
  })

  output$xml <- renderText({
    create_xml(create_beautier_cmd(input))
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

