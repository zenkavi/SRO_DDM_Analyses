library(gridExtra)
library(lme4)
library(MCMCglmm)
library(rmarkdown)
library(DT)
library(RCurl)

theme_set(theme_bw())

render_this <- function(){rmarkdown::render('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/SRO_DDM_Analyses.Rmd', output_dir = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/reports', html_notebook(toc = T, toc_float = T, toc_depth = 2, code_folding = 'hide'))}

options(scipen = 1, digits = 4)

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'

eval(parse(text = getURL(paste0(helper_func_path,'g_legend.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'g_caption.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'sem.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'trim.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'match_t1_t2.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'get_retest_stats.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'get_numeric_cols.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'process_boot_df.R'), ssl.verifypeer = FALSE)))
#eval(parse(text = getURL(paste0(helper_func_path,'fix_ddm_legend.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_outliers.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_correlated_task_variables.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'transform_remove_skew.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'make_rel_df'), ssl.verifypeer = FALSE)))
