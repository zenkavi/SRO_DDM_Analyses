library(gridExtra)
library(lme4)
library(MCMCglmm)
library(rmarkdown)
library(DT)

theme_set(theme_bw())

render_this <- function(){rmarkdown::render('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/SRO_DDM_Analyses.Rmd', output_dir = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/reports', html_notebook(toc = T, toc_float = T, toc_depth = 2, code_folding = 'hide'))}

options(scipen = 1, digits = 4)

helper_func_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/'

source(paste0(helper_func_path, 'g_legend.R'))
source(paste0(helper_func_path, 'g_caption.R'))
source(paste0(helper_func_path, 'sem.R'))
source(paste0(helper_func_path, 'trim.R'))
source(paste0(helper_func_path, 'match_t1_t2.R'))
source(paste0(helper_func_path, 'get_retest_stats.R'))
source(paste0(helper_func_path, 'get_numeric_cols.R'))
source(paste0(helper_func_path, 'process_boot_df.R'))
# source(paste0(helper_func_path, 'fix_ddm_legend.R'))
source(paste0(helper_func_path, 'remove_outliers.R'))
source(paste0(helper_func_path, 'remove_correlated_task_variables.R'))
source(paste0(helper_func_path, 'transform_remove_skew.R'))
source(paste0(helper_func_path, 'make_rel_df.R'))
