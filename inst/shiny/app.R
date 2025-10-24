library(shiny)
library(ggplot2)
library(scales)

# Read in data
housepr_income <- get("housepr_income", envir = asNamespace("GoldinGroundOz"))
capital_gain   <- get("capital_gain", envir = asNamespace("GoldinGroundOz"))

# Fix data type
capital_gain$year <- factor(capital_gain$year, levels = sort(unique(capital_gain$year)))

ui <- fluidPage(
  titlePanel("Australia: Housing Price and Income Explorer"),

  # First row: sliderInput
  fluidRow(
    column(
            # left input
      width = 6, # make more space
      sliderInput(
        "yearRange", "Select Year Range For Line plot:",
        min = min(housepr_income$year),
        max = max(housepr_income$year),
        value = c(min(housepr_income$year), max(housepr_income$year)),
        step = 1, sep = ""
        )
      ),
            # right input
    selectInput(
      "bar_style",
      "Bar width:",
      choices = c("Narrow" = 0.4, "Medium" = 0.7, "Wide" = 0.9),
      selected = 0.7
    )
    ),


  # Second row: plots
  fluidRow(
    column(
      width = 12,
      tabsetPanel(
        tabPanel("Disposable Income vs House Prices", plotOutput("p1")),
        tabPanel("Average Capital Gain Rate", plotOutput("p2"))
      )
    )
  )
)


server <- function(input, output, session) {

  output$p1 <- renderPlot({
    df <- subset(housepr_income,
                 year >= input$yearRange[1] & year <= input$yearRange[2])

    ggplot(df, aes(x = year)) +
      geom_line(aes(y = income, colour = "Disposable income"), size = 1.2) +
      geom_line(aes(y = house_price, colour = "House prices"), size = 1.2) +
      scale_colour_manual(values = c("Disposable income" = "#EE622F", "House prices" = "gold")) +
      labs(
        y = "Index (1989–90 = 100)",
        x = "Year",
        colour = "Indicator",
        title = "Simulated Detached House Prices vs Household Disposable Income"
      ) +
      theme_minimal(base_size = 14)
  })

  output$p2 <- renderPlot({
    ggplot(capital_gain, aes(x = year, y = value, fill = phase)) +
      geom_col(width = as.numeric(input$bar_style)) +
      scale_fill_manual(values = c(
        "Before 50% capital gains discount" = "#50BBCE",
        "After 50% capital gains discount" = "#CB5268"
      )) +
      scale_x_discrete(
        breaks = levels(capital_gain$year)[seq(1, nlevels(capital_gain$year), 3)]
      ) +
      scale_y_continuous(labels = label_dollar()) +
      labs(
        title = "Average capital gain rate change",
        subtitle = "Blue = before 50% capital gains discount",
        x = NULL, y = NULL
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold"),
        legend.title = element_blank()
      )
  })
}

shinyApp(ui, server)
