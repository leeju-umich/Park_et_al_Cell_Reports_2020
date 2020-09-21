# Park_et_al_Cell_Reports_2020

## Overview 

This repository contains source codes for the manuscript by Park et
al., entitled *"Single cell transcriptome analysis of colon cancer cell
response to 5-fluorouracil-induced DNA damage"*.

## Prerequisites

To use this repository, `R` software and the following packages are required.

* `Seurat` v3 package - Install with `install.packages('Seurat)'`
* `ggplot2` package - Install with `install.packages('ggplot2')`
* `shiny` package - Install with `install.packages('shiny')`
* `stringr` package - Install with `install.packages('stringr')`

## Directory structure

This repository contains three directories relevant to the manuscript.

* `rds/` contains the Seurat (v3) R objects used for most analyses
  presented in the manuscript. This can be reproduced by downloading the
  digital expression matrix from GEO dataset (GSE149224).
* `shiny/` contains RShiny apps to reproduce many display items
  presented in the manuscript. Users can also interactively produce
  additional visualizations of genes of their interest. An online
  version of the shiny app (with limited bandwidth) is also available at
  https://lee.lab.medicine.umich.edu/dna_damage
* `R/` contains additional R codes that is not covered by the shiny
  apps.
  
This repository may continuosuly update after publication, if there
are additional requests for data sharing not covered by the current 
repository.

## Reproducing large data

Due to the size limit, the data files shared in `rds/` directory only
includes relatively smaller files after barcode filtering. To obtain
large-sized datasets (such as MAGIC imputation or 3-way merged
dataset), users need to download the raw data from GEO, and follow the
processes described in the corresponding codes in `R/` directory.

## Reference

To cite our study, please refer to the following information. This
information will be updated if the current manuscript is formally
accepted for publication.

* Park SR, Namkoong S, Friesen L, Cho CS, Zhang ZZ, Chen YC, Yoon E,
 Kim CH, Kwak H, Kang HM, Lee JH. Single-Cell Transcriptome Analysis
 of Colon Cancer Cell Response to 5-Fluorouracil-Induced DNA Damage.
 Cell Rep. 2020 Aug 25;32(8):108077. doi: 10.1016/j.celrep.2020.108077.
 PMID: 3284613
