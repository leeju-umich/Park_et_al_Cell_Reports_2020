#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(Seurat)
library(stringr)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("SW480 Dataset 2D Analysis"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("xaxis", "Choose X axis: ",cols.continuous, selected=x.selected),
         textInput("xgene", "Type gene name for X axis : ", ""),
         fluidRow(column(checkboxInput("xlog1p", "log"),width=12)),
         selectInput("yaxis", "Choose Y axis: ",cols.continuous, selected=y.selected),
         textInput("ygene", "Type gene name for Y axis : ", ""),
         fluidRow(column(checkboxInput("ylog1p", "log"),width=12)),
         selectInput("coloraxis", "Choose Colors: ",cols.all, selected=color.selected),
         textInput("colorgene", "Type gene name for Color :", ""),
         fluidRow(column(checkboxInput("colorlog1p", "log"),width=12)),
         sliderInput("alpha", "Transparency:", min = 0, max = 1, value = 0.9),
         sliderInput("size", "Point size:", min = 0.1, max = 10, value = 2.5),
         selectInput("palette", "Continuous color scheme :",c("rainbow","topo","terrain","yellow-purple", "purple-grey"), selected="purple-grey"),
         submitButton()
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot", height=600, width=800)
      )
   )
)

shinyUI(ui)