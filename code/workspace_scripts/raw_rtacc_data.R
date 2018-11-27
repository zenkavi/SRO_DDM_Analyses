library(tidyverse)

ddm_workspace_scripts = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/'

eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE)))

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
eval(parse(text = getURL(paste0(helper_func_path,'get_demographics.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'residualize_baseline.R'), ssl.verifypeer = FALSE)))

raw_t1_measures
raw_t2_measures

test_data_ez = test_data %>%
  select(grep('EZ', names(test_data), value=T))

clean_test_data_ez = remove_correlated_task_variables(test_data_ez)

clean_test_data_ez = as.data.frame(apply(clean_test_data_ez, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_test_data_ez) == T]
clean_test_data_ez = transform_remove_skew(clean_test_data_ez, numeric_cols)

clean_test_data_ez_std = clean_test_data_ez %>% mutate_if(is.numeric, scale)

clean_test_data_ez_std[is.na(clean_test_data_ez_std)]=0

clean_test_data_ez_std = clean_test_data_ez_std %>%
  select_if(function(col) sd(col) != 0)

clean_test_data_ez_std = cbind(clean_test_data_ez_std, demographics[,c("Age", "Sex")])

res_clean_test_data_ez = residualize_baseline(clean_test_data_ez_std)
