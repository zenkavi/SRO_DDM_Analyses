library(RCurl)
require(tidyverse)
theme_set(theme_bw())
options(scipen = 1, digits = 4)

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
eval(parse(text = getURL(paste0(helper_func_path,'get_numeric_cols.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_outliers.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_correlated_task_variables.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'transform_remove_skew.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'get_demographics.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'residualize_baseline.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'find_optimal_components.R'), ssl.verifypeer = FALSE)))

ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE)))
rm(test_data_hddm_fullfit, test_data_hddm_refit)

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

test_data_ez_522 = test_data_522 %>%
  select(grep('EZ', names(test_data_522), value=T))

clean_test_data_ez_522 = remove_correlated_task_variables(test_data_ez_522)

clean_test_data_ez_522 = as.data.frame(apply(clean_test_data_ez_522, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_test_data_ez_522) == T]
clean_test_data_ez_522 = transform_remove_skew(clean_test_data_ez_522, numeric_cols)

clean_test_data_ez_std_522 = clean_test_data_ez_522 %>% mutate_if(is.numeric, scale)

clean_test_data_ez_std_522[is.na(clean_test_data_ez_std_522)]=0

clean_test_data_ez_std_522 = clean_test_data_ez_std_522 %>%
  select_if(function(col) sd(col) != 0)

data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/'
release = 'Complete_03-29-2018/'
dataset = 'demographic_health.csv'

demographics = get_demographics(dataset = paste0(data_path, release, dataset))

demographics_522 = demographics

demographics = demographics %>%
  filter(X %in% test_data$sub_id)

clean_test_data_ez_std = cbind(clean_test_data_ez_std, demographics[,c("Age", "Sex")])

res_clean_test_data_ez = residualize_baseline(clean_test_data_ez_std)

clean_test_data_ez_std_522 = cbind(clean_test_data_ez_std_522, demographics_522[,c("Age", "Sex")])

res_clean_test_data_ez_522 = residualize_baseline(clean_test_data_ez_std_522)

res_clean_test_data_ez_nont2subs = res_clean_test_data_ez_522[test_data_522$sub_id %in% retest_data$sub_id == FALSE,]

retest_data_ez = retest_data %>%
  select(grep('EZ', names(retest_data), value=T))

clean_retest_data_ez = remove_correlated_task_variables(retest_data_ez)

clean_retest_data_ez = as.data.frame(apply(clean_retest_data_ez, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_retest_data_ez) == T]
clean_retest_data_ez = transform_remove_skew(clean_retest_data_ez, numeric_cols)

clean_retest_data_ez_std = clean_retest_data_ez %>% mutate_if(is.numeric, scale)

clean_retest_data_ez_std[is.na(clean_retest_data_ez_std)]=0

clean_retest_data_ez_std = clean_retest_data_ez_std %>%
  select_if(function(col) sd(col) != 0)

demographics = demographics %>%
  filter(X %in% retest_data$sub_id)

clean_retest_data_ez_std = cbind(clean_retest_data_ez_std, demographics[,c("Age", "Sex")])

res_clean_retest_data_ez = residualize_baseline(clean_retest_data_ez_std)
