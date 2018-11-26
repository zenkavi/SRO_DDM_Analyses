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

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

test_data_hddm = test_data %>%
  select(grep('hddm', names(test_data), value=T))

clean_test_data_hddm = remove_correlated_task_variables(test_data_hddm)

clean_test_data_hddm = as.data.frame(apply(clean_test_data_hddm, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_test_data_hddm) == T]
clean_test_data_hddm = transform_remove_skew(clean_test_data_hddm, numeric_cols)

clean_test_data_hddm_std = clean_test_data_hddm %>% mutate_if(is.numeric, scale)

clean_test_data_hddm_std[is.na(clean_test_data_hddm_std)]=0

clean_test_data_hddm_std = clean_test_data_hddm_std %>%
  select_if(function(col) sd(col) != 0)

clean_test_data_hddm_std = cbind(clean_test_data_hddm_std, demographics[,c("Age", "Sex")])

res_clean_test_data_hddm = residualize_baseline(clean_test_data_hddm_std)

hddm_var_subset = c("adaptive_n_back.hddm_drift" , "attention_network_task.hddm_drift", "choice_reaction_time.hddm_drift", "directed_forgetting.hddm_drift", "dot_pattern_expectancy.hddm_drift" , "local_global_letter.hddm_drift", "motor_selective_stop_signal.hddm_drift",  "recent_probes.hddm_drift", "shape_matching.hddm_drift" , "simon.hddm_drift", "stim_selective_stop_signal.hddm_drift", "stop_signal.hddm_drift", "stroop.hddm_drift" , "threebytwo.hddm_drift", "adaptive_n_back.hddm_thresh", "attention_network_task.hddm_thresh", "choice_reaction_time.hddm_thresh", "directed_forgetting.hddm_thresh", "dot_pattern_expectancy.hddm_thresh.logTr", "local_global_letter.hddm_thresh", "motor_selective_stop_signal.hddm_thresh", "recent_probes.hddm_thresh", "shape_matching.hddm_thresh", "simon.hddm_thresh", "stim_selective_stop_signal.hddm_thresh.logTr", "stop_signal.hddm_thresh", "stop_signal.hddm_thresh_high", "stop_signal.hddm_thresh_low", "stop_signal.proactive_slowing_hddm_thresh", "stroop.hddm_thresh", "threebytwo.hddm_thresh", grep("non_dec", names(test_data_hddm), value = T))

res_clean_test_data_hddm_subset = res_clean_test_data_hddm %>% select(hddm_var_subset)

hddm_t1_fa_3_subset = fa(res_clean_test_data_hddm_subset, 3, rotate='oblimin', fm='minres', scores='tenBerge')
