###########Fig2#############
############################

### RKO dataset : obj.rko.mt
p1<- DimPlot(obj.rko.mt, group.by = 'group',reduction = 'tsne')
p2<- DimPlot(obj.rko.mt, group.by = 'group',reduction = 'umap')
plot_grid(p1,p2,ncol = 2)

p1<- DimPlot(obj.rko.mt, group.by = 'dose',reduction = 'tsne')
p2<- DimPlot(obj.rko.mt, group.by = 'dose',reduction = 'umap')
plot_grid(p1,p2,ncol = 2)

p1<- DimPlot(obj.rko.mt, group.by = c('group','dose'),reduction = 'pca')
p2<- DimPlot(obj.rko.mt, group.by = c('group','dose'),reduction = 'pca', dims = c(1,3))
p3<- DimPlot(obj.rko.mt, group.by = c('group','dose'),reduction = 'pca', dims = c(2,3))
plot_grid(p1,p2,p3,ncol = 1)

###########Fig3#############
############################
### RKO dataset : obj.rko.mt
genes <- group_A_genes
DotPlot(obj.rko.mt, features =  genes, group.by = 'group') 
genes <- group_C_genes
DotPlot(obj.rko.mt, features =  genes, group.by = 'group') 
genes <- group_S_genes
DotPlot(obj.rko.mt, features =  genes, group.by = 'group') 

FeaturePlot(obj.rko.mt, features = c('PMAIP1','FAS','IKBIP','ISG15'), ncol = 4)
FeaturePlot(obj.rko.mt, features = c('CDKN1A','MDM2'), ncol = 2)
FeaturePlot(obj.rko.mt, features = c('ATF3','CNOT4'), ncol = 2)


###########Fig4#############
############################
### RKO magic dataset : obj.rko.magic

## A and B

ggplot(obj.rko.magic, aes(gene1, gene2, color=group)) + geom_point(size=0.2) + theme_gray() 
ggplot(obj.rko.magic, aes(gene1, gene2, color=dose)) + geom_point(size=0.2) + theme_gray() 

## C D E
### RKO dataset : obj.rko.mt
plot_group <- function(gene, obj=obj.rko.mt){
  meta <- obj.rko.mt@meta.data[,c('group','dose')]
  if(gene %in% rownames(obj@assays$RNA@data)) {
    meta[,gene] <- obj@assays$RNA@data[gene,]
  }
  df <- as.data.frame(meta) %>% group_by(group,dose) %>% 
    summarize(avg=mean(get(gene)),sd=sd(get(gene)), ct=n(),se=sd(get(gene))/sqrt(length(get(gene)))) %>% 
    mutate(gene=as.character(gene))
  # -- For analysis on U/A/C
  df <- df[-c(2,3,6,7,11,12,13,14),]
  # -- For analysis on U/A/C and pooled_S
  #df2 <- as.data.frame(meta) %>% group_by(group) %>% summarize(dose=as.factor('200'), avg=mean(get(gene)),sd=sd(get(gene)),se=sd(get(gene))/sqrt(length(get(gene)))) %>% mutate(gene=as.character(gene))
  #df2 <- df2[-c(1,2,3),]
  #df <- rbind.data.frame(df, df2)
  p <- ggplot(df, aes(x=dose, y=avg, color=group, group=group)) + geom_line(size=1) + geom_point(size=3) +
    ylab(as.character(gene)) +geom_errorbar(aes(ymin=avg-se, ymax=avg+se), width=.5, position=position_dodge(0.05), size=1) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12), axis.text.y = element_text(size = 12),axis.title = element_text(size = 15))
  print(p)
  return(df)
}
gene <- 'CCNE2'
plot_group(gene)

###########Fig5#############
############################
### RKO magic dataset : obj.rko.magic

ggplot(obj.rko.magic, aes(gene1, gene2, color=group)) + geom_point(size=0.2) + theme_gray() 
ggplot(obj.rko.magic, aes(gene1, gene2, color=dose)) + geom_point(size=0.2) + theme_gray() 
ggplot(obj.rko.magic, aes(gene1, gene2, color=Phase)) + geom_point(size=0.2) + theme_gray() 


###########Fig7#############
############################
### HCT116 dataset : obj.hct.mt
### SW480 dataset : obj.sw.mt
DimPlot(object = obj.hct.mt, group.by = c('dose','dose_batch'), reduction = 'umap')
DimPlot(object = obj.sw.mt, group.by = c('dose','dose_batch'), reduction = 'umap')
FeaturePlot(object = obj.hct.mt, features = c('CCNE2', 'CDKN1A'), reduction = 'umap')
DimPlot(object = obj.hct.mt, group.by = 'group', reduction = 'umap')
FeaturePlot(object = obj.hct.mt, features = 'ATF3', reduction = 'umap')
gene <- 'CCNE2'
plot_group(gene, obj = obj.hct.mt)
gene <- 'CDKN1A'
plot_group(gene, obj = obj.hct.mt)
gene <- 'PCNA'
plot_group(gene, obj = obj.hct.mt)
gene <- 'CDK1'
plot_group(gene, obj = obj.hct.mt)
FeaturePlot(object = obj.sw.mt, features = c('CCNE2', 'CDKN1A','ATF3'), reduction = 'umap')

plot.group <- function(gene, obj= obj.rko.mt){
  meta <- obj@meta.data[,c('group','dose')]
  if(gene %in% rownames(obj@assays$RNA@data)) {
    meta[,gene] <- obj@assays$RNA@data[gene,]
  }
  df <- as.data.frame(meta) %>% group_by(dose,group) %>% 
    summarize(avg=mean(get(gene)),sd=sd(get(gene)), ct=n(),se=sd(get(gene))/sqrt(length(get(gene)))) %>% 
    mutate(gene=as.character(gene))
  p <- ggplot(df, aes(x=dose, y=avg, group = group, color=group)) + geom_line(size=1) + geom_point(size=3) +
    ylab(as.character(gene)) +geom_errorbar(aes(ymin=avg-se, ymax=avg+se), width=.5, position=position_dodge(0.05), size=1) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12), axis.text.y = element_text(size = 12),axis.title = element_text(size = 15), legend.position = 'none')
  print(p)
}
gene <- 'MAP1LC3B'
plot.group(gene)

plot_group.sw <- function(gene, obj=obj.sw.mt){
  meta <- obj.rko.mt@meta.data[,c('group','dose')]
  if(gene %in% rownames(obj@assays$RNA@data)) {
    meta[,gene] <- obj@assays$RNA@data[gene,]
  }
  df <- as.data.frame(meta) %>% group_by(dose) %>% 
    summarize(avg=mean(get(gene)),sd=sd(get(gene)), ct=n(),se=sd(get(gene))/sqrt(length(get(gene)))) %>% 
    mutate(gene=as.character(gene))
  # -- For analysis on U/A/C
  df <- df[-c(2,3,6,7,11,12,13,14),]
  p <- ggplot(df, aes(x=dose, y=avg, group = 1, color='red')) + geom_line(size=1) + geom_point(size=3) +
    ylab(as.character(gene)) +geom_errorbar(aes(ymin=avg-se, ymax=avg+se), width=.5, position=position_dodge(0.05), size=1) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12), axis.text.y = element_text(size = 12),axis.title = element_text(size = 15), legend.position = 'none')
  print(p)
  return(df)
}
gene <- 'MAP1LC3B'
plot_group.sw(gene)



