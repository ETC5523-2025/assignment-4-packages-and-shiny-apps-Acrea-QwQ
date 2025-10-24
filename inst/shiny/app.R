library(shiny)
library(ggplot2)
library(scales)

# Read in data
housepr_income <- get("housepr_income", envir = asNamespace("GoldinGroundOz"))
capital_gain   <- get("capital_gain", envir = asNamespace("GoldinGroundOz"))

# Fix data type
capital_gain$year <- factor(capital_gain$year, levels = sort(unique(capital_gain$year)))

ui <- fluidPage(
  # use css
  includeCSS("www/style.css"),

  titlePanel("The Hidden Culprit: What Drove Australia's House Prices and Incomes Apart?"),

  # First row: sliderInput
  fluidRow(
           # left input
    column(
      width = 6,
      sliderInput(
        "yearRange", "Select Year Range For First Panel:",
        min = min(housepr_income$year),
        max = max(housepr_income$year),
        value = c(min(housepr_income$year), max(housepr_income$year)),
        step = 1, sep = ""
        )
      ),
            # right input
    column(
    width = 6,
    selectInput(
      "phase_mode", "Select phase view For Second Panel:",
      choices = c("Before only", "After only", "Both")
    )
    )
  ),


  # Second row: plots
  fluidRow(
    column(
      width = 12,
      tabsetPanel(
        # Panel 1
        tabPanel("Disposable Income vs House Prices", plotOutput("p1"),
                 br(),
                 div(class = "desc-box",
                 p(strong("Description:"),
                   "The plot compares household disposable income and detached house prices over time.
          The orange line represents disposable income, while the gold line shows house prices.
          Both are indexed to 1989–90 = 100 to make their growth comparable."
                 ),
                 p(strong("How to interpret:"),
                   "The orange line shows household disposable income, while the gold line represents detached house prices.
  Before 2000, the two moved closely together, but after 2000 the gap widened — house prices rose sharply, whereas income growth remained modest."
                 ))
        ),

        #Panel 2
        tabPanel("Average Capital Gain Rate", plotOutput("p2"),
                 br(),
                 div(class = "desc-box",
                 p(strong("Description:"),
                   "The plot shows the average capital gain rate in two phases, illustrating how the 50% capital gains discount policy affected property returns.
The blue bars correspond to the period before the discount was introduced, while the red bars represent the period after it."
                 ),
                 p(strong("How to interpret:"),
                   "The blue bars represent the period before the discount,
          and the pink bars represent the period after it.
          Comparing their heights shows how the policy changed the average gains. Notice that around the year 2000, there is a clear turning point — average capital gains begin to rise sharply after this period,
a shift that appears to correspond with the trend observed in house prices.")
                 ))
      )
    )
  )
)


server <- function(input, output, session) {

# Line plot
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
      theme_minimal(base_size = 14)+
      theme(
        plot.title = element_text(face = "bold"),
        legend.title = element_blank()
      )
  })

# col

  output$p2 <- renderPlot({

    # select select data based on phase_mode
    data_to_plot <- switch(
      input$phase_mode,
      "Before only" = subset(capital_gain, phase == "Before 50% capital gains discount"),
      "After only"  = subset(capital_gain, phase == "After 50% capital gains discount"),
      "Both" = capital_gain
    )

    ggplot(data_to_plot, aes(x = year, y = value, fill = phase)) +
      geom_col(width = 0.7) +
      scale_fill_manual(values = c(
        "Before 50% capital gains discount" = "#50BBCE",
        "After 50% capital gains discount" = "#CB5268"
      )) +
      scale_x_discrete(
        breaks = levels(capital_gain$year)[seq(1, nlevels(capital_gain$year), 3)]
      ) +
      scale_y_continuous(labels = label_dollar()) +
      labs(
        colour = "Indicator",
        title = "Simulated average capital gain rate change",
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
