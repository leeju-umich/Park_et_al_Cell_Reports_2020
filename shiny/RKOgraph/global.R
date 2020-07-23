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
library(dplyr)
library (gtools)
library(tidyr)

addGene <- function(gene) {
  if ( gene %in% rownames(obj@assays$RNA@data) ) {
    meta[,gene] <<- obj@assays$RNA@data[gene,]
    return(TRUE)
  }
  else {
    showNotification(paste0("Gene ",gene," cannot be found in normalized expressions"))
    return(FALSE)
  }
}

#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#obj <- readRDS("../rds/2020.02.12.rko.merged.b.800.rds") 
obj <- readRDS("../../rds/rko.mt.cut.with_cluster_4s_04142020.rds")
#meta <- obj@meta.data[,c('nCount_RNA','nFeature_RNA','percent.mt','group','dose')]
meta <- obj@meta.data[,c('group','dose')]

addGene('CCNE2')
addGene('CDKN1A')

cols.all <- colnames(meta)
cols.default <- cols.all
cols.continuous <- c()
cols.discrete <- c()

x.selected <- 'UMAP1'
y.selected <- 'UMAP2'
color.selected <- 'Group_ID'

for(cn in colnames(meta)) {
  if ( is.numeric(meta[,cn]) ) {
    cols.continuous <- append(cols.continuous,cn)
  }
  else {
    cols.discrete <- append(cols.discrete,cn)
  }
}
