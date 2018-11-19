require(tidyverse)
theme_set(theme_bw())
options(scipen = 1, digits = 4)

helper_func_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/'
source(paste0(helper_func_path, 'get_numeric_cols.R'))
source(paste0(helper_func_path, 'remove_outliers.R'))
source(paste0(helper_func_path, 'remove_correlated_task_variables.R'))
source(paste0(helper_func_path, 'transform_remove_skew.R'))
source(paste0(helper_func_path, 'get_demographics.R'))
source(paste0(helper_func_path, 'residualize_baseline.R'))
source(paste0(helper_func_path, 'find_optimal_components.R'))

ddm_workspace_scripts = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/'
source(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'))
source(paste0(ddm_workspace_scripts,'ddm_subject_data.R'))
rm(test_data_hddm_fullfit, test_data_hddm_refit)

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

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

data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/'
release = 'Complete_03-29-2018/'
dataset = 'demographic_health.csv'

demographics = get_demographics(dataset = paste0(data_path, release, dataset))

demographics = demographics %>%
filter(X %in% test_data$sub_id)

clean_test_data_ez_std = cbind(clean_test_data_ez_std, demographics[,c("Age", "Sex")])

res_clean_test_data_ez = residualize_baseline(clean_test_data_ez_std)

ez_t1_fa_3 = fa(res_clean_test_data_ez, 3, rotate='oblimin', fm='minres', scores='tenBerge')

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


clean_retest_data_ez_std = cbind(clean_retest_data_ez_std, demographics[,c("Age", "Sex")])

res_clean_retest_data_ez = residualize_baseline(clean_retest_data_ez_std)

ez_t2_fa_3 = predict(ez_t1_fa_3, res_clean_retest_data_ez)