#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#install.packages("rlang")

library(shiny)
library(ggplot2)
library(Seurat)
library(stringr)

#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#obj <- readRDS("../rds/2020.02.12.rko.merged.b.800.rds")
obj <- readRDS("../../rds/rko.mt.cut.with_cluster_4s_04142020.rds")
#magic <- t(readRDS("../rds/rko.magic.2020.03.05.rds"))

gene.names <- rownames(obj@assays$RNA@data)

meta <- obj@meta.data

meta$TSNE1 <- obj@reductions$tsne@cell.embeddings[,1]
meta$TSNE2 <- obj@reductions$tsne@cell.embeddings[,2]
meta$UMAP1 <- obj@reductions$umap@cell.embeddings[,1]
meta$UMAP2 <- obj@reductions$umap@cell.embeddings[,2]
meta$PC1 <- obj@reductions$pca@cell.embeddings[,1]
meta$PC2 <- obj@reductions$pca@cell.embeddings[,2]
meta$PC3 <- obj@reductions$pca@cell.embeddings[,3]
meta$PC4 <- obj@reductions$pca@cell.embeddings[,4]
meta$PC5 <- obj@reductions$pca@cell.embeddings[,5]

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
