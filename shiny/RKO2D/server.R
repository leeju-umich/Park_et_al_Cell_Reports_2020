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

addGene <- function(gene, use.magic) {
  if ( use.magic ) {
    if ( gene %in% rownames(magic) ) {
      meta[,paste0(gene,".magic")] <<- magic[gene,]
      return(TRUE)
    }
    else {
      showNotification(paste0("Gene ",gene," cannot be found in MAGIC expressions"))
      return(FALSE)
    }
  }
  else {
    if ( gene %in% rownames(obj@assays$RNA@data) ) {
      meta[,gene] <<- obj@assays$RNA@data[gene,]
      return(TRUE)
    }
    else {
      showNotification(paste0("Gene ",gene," cannot be found in normalized expressions"))
      return(FALSE)
    }
  }
}

updateSelectText <- function(axis,input,session) {
  input.gene <- paste0(axis,"gene")
  input.axis <- paste0(axis,"axis")
  input.magic <- paste0(axis,"magic")
  text.gene <- input[[input.gene]]
  text.axis <- input[[input.axis]]
  bool.magic <- input[[input.magic]]

  if ( text.gene == "" ) {
    orig.gene <- str_remove(text.axis,"\\.magic$")
    if ( bool.magic ) {
      if ( orig.gene %in% cols.default ) { new.gene <- orig.gene }
      else { new.gene <- paste0(orig.gene,".magic") }
    } else {
      new.gene <- orig.gene
    }
  } else {
    orig.gene <- str_remove(text.gene,"\\.magic$")
    if ( bool.magic ) {
      if ( orig.gene %in% cols.default ) { new.gene <- orig.gene }
      else { new.gene <- paste0(orig.gene,".magic") }
    } else {
      new.gene <- orig.gene
    }
  }

  #print(c(axis,text.gene,text.axis,new.gene,orig.gene))

  if ( new.gene %in% cols.all ) {   ## already added in the selectInput list
    updateSelectInput(session,input.axis,selected=new.gene)
  } else {
    cols.all <<- append(cols.all, new.gene)
    cols.continuous <<- append(cols.continuous, new.gene)
    addGene(orig.gene,bool.magic)
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
    updateSelectInput(session, "coloraxis", choices=cols.all, selected=new.gene)
    color.selected <<- new.gene
  }
  return(new.gene)
}


# Define server logic required to draw a histogram
server <- function(input, output, session) {
   output$distPlot <- renderPlot({
     x.selected <<- input$xaxis
     y.selected <<- input$yaxis
     color.selected <<- input$coloraxis

     up.x <- updateSelectText("x", input, session)
     up.y <- updateSelectText("y", input, session)
     up.color <- updateSelectText("color", input, session)
     p <- ggplot(meta) + aes(x=get(up.x)) + aes(y=get(up.y)) + aes(color=get(up.color))
     if ( input$xlog1p ) { p <- p + scale_x_continuous(trans='log1p') }
     if ( input$ylog1p ) { p <- p + scale_y_continuous(trans='log1p') }
     p <- p + theme_grey(base_size = 40) + labs(x=up.x, y=up.y, color=up.color) + geom_point(size=input$size,alpha=input$alpha)
     if ( up.color %in% cols.continuous) {
       trans.color <- ifelse(input$colorlog1p,'log1p','identity')
       if ( input$palette == "rainbow" ) { p <- p + scale_color_gradientn(colors=rainbow(5),trans=trans.color) }
       else if ( input$palette == "topo" ) { p <- p + scale_color_gradientn(colors=topo.colors(9),trans=trans.color) }
       else if ( input$palette == "terrain" ) { p <- p + scale_color_gradientn(colors=terrain.colors(10),trans=trans.color) }
       else if ( input$palette == "yellow-purple" ) { p <- p + scale_color_gradient(low="purple",high="yellow",trans=trans.color) + theme_dark(base_size = 30) + ggtitle(up.color) + labs(x=up.x, y=up.y, color="Level")}
       else if ( input$palette == "purple-grey" ) { p <- p + scale_color_gradient(low="grey",high="purple",trans=trans.color) + theme_classic(base_size = 30) + ggtitle(up.color) + labs(x=up.x, y=up.y, color="Level")}
     }
     print(p)
   })
}

shinyServer(server)
