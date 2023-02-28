library(shiny)
library(tidyverse)

homerange <- readr::read_csv("data/Tamburelloetal_HomeRangeDatabase.csv")


ui <- fluidPage(
    radioButtons("fill_var", "Select Fill Variable",
        choices = c("trophic.guild", "thermoregulation"),
        selected = "trophic.guild"
    ),
    plotOutput("plot", width = "75vw", height = "60vh")
)

server <- function(input, output) {
    output$plot <- renderPlot({
        ggplot(
            data = homerange,
            aes_string(x = "locomotion", fill = input$fill_var)
        ) +
            geom_bar(position = "dodge", alpha = 0.6, color = "#464646") +
            theme_light(base_size = 18) +
            theme(legend.position = "bottom") +
            labs(
                x = "Locomotion",
                y = "Count",
                fill = case_when(
                    input$fill_var == "trophic.guild" ~ "Trophic Guild",
                    input$fill_var == "thermoregulation" ~ "Thermoregulation"
                )
            )
    })
}

shinyApp(ui, server)
