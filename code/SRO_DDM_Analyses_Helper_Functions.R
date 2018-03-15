library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)
library(lme4)
library(GGally)
library(rmarkdown)
library(psych)
library(stringr)
library(plotly)
library(DT)
library(sjPlot)

render_this <- function(){rmarkdown::render('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM/code/SRO_DDM_Analyses.Rmd', output_dir = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM/output/reports', html_notebook(toc = T, toc_float = T, toc_depth = 2, code_folding = 'hide'))}

options(scipen = 1, digits = 4)

sem <- function(x) {sd(x, na.rm=T) / sqrt(length(x))}