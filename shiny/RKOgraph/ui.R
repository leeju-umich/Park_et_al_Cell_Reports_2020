# Define UI for application that draws a histogram
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("RKO data partitioned by subgroups"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("coloraxis", "Choose Features: ",cols.continuous, selected=color.selected),
         textInput("colorgene", "Type gene name for Color :", ""),
         fluidRow(column(checkboxInput("stress", "Include Stress group"),width=12)),
         sliderInput("size", "Line width:", min = 0.1, max = 5, value = 1),
         submitButton()
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot", height=300, width=400)
      )
   )
)

shinyUI(ui)