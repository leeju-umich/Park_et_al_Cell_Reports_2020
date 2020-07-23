#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


updateSelectText <- function(axis,input,session) {
  input.gene <- paste0(axis,"gene")
  input.axis <- paste0(axis,"axis")
  input.magic <- paste0(axis,"magic")
  text.gene <- input[[input.gene]]
  text.axis <- input[[input.axis]]
  bool.magic <- input[[input.magic]]
  
  if ( text.gene == "" ) {
    orig.gene <- str_remove(text.axis,"\\.magic$")
    new.gene <- orig.gene
  } else {
    orig.gene <- str_remove(text.gene,"\\.magic$")
    new.gene <- orig.gene
  }
  
  #print(c(axis,text.gene,text.axis,new.gene,orig.gene))
  
  if ( new.gene %in% cols.all ) {   ## already added in the selectInput list
    updateSelectInput(session,input.axis,selected=new.gene)
  } else { 
    cols.all <<- append(cols.all, new.gene) 
    cols.continuous <<- append(cols.continuous, new.gene)
    addGene(orig.gene)
  } 
  updateTextInput(session, input.gene, value="") ## make the text empty
  
  if ( axis == "x" ) {
    #print(c("x",new.gene))
    updateSelectInput(session, "xaxis", choices=cols.continuous, selected=new.gene)
    x.selected <<- new.gene
  } else if ( axis == "y") {
    #print(c("y",x.selected,new.gene))
    updateSelectInput(session, "xaxis", choices=cols.continuous, selected=x.selected)      
    updateSelectInput(session, "yaxis", choices=cols.continuous, selected=new.gene)        
    y.selected <<- new.gene
  } else if ( axis == "color" ) {
    #print(c("color",x.selected,y.selected,new.gene))
    updateSelectInput(session, "xaxis", choices=cols.continuous, selected=x.selected)  
    updateSelectInput(session, "yaxis", choices=cols.continuous, selected=y.selected)        
    updateSelectInput(session, "coloraxis", choices=cols.continuous, selected=new.gene)
    color.selected <<- new.gene
  }
  return(new.gene)
}


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$distPlot <- renderPlot({
    color.selected <<- input$coloraxis
    up.color <- updateSelectText("color", input, session)
    up.x <- x.selected
    up.y <- y.selected
    df <- as.data.frame(meta) %>% group_by(group,dose) %>% summarize(avg=mean(get(up.color)),
                                                                     sd=sd(get(up.color)), ct=n(),
                                                                     se=sd(get(up.color))/sqrt(length(get(up.color)))) %>% 
      mutate(up.color=as.character(up.color))
    print(df)
    p2 <- ggplot(df, aes(x=dose, y=avg, color=group, group=group)) + geom_line(size=1) + geom_point(size=3) +
      ylab(as.character(up.color)) +
      geom_errorbar(aes(ymin=avg-se, ymax=avg+se), width=.5, position=position_dodge(0.05), size=1) +
      theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12), axis.text.y = element_text(size = 12),axis.title = element_text(size = 15))
    print(p2)
    return(df)
  })
}

shinyServer(server)
