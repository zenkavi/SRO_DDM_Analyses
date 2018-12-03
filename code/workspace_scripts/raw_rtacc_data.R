library(tidyverse)

ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'

eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE)))

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
eval(parse(text = getURL(paste0(helper_func_path,'get_demographics.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'residualize_baseline.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_correlated_task_variables.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'remove_outliers.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'transform_remove_skew.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'get_numeric_cols.R'), ssl.verifypeer = FALSE)))

test_data_raw = test_data %>%
  select(-contains("EZ"), -contains("hddm"))

clean_test_data_raw = remove_correlated_task_variables(test_data_raw)

# clean_test_data_raw = as.data.frame(apply(clean_test_data_raw, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_test_data_raw) == T]
clean_test_data_raw = transform_remove_skew(clean_test_data_raw, numeric_cols)

clean_test_data_raw_std = clean_test_data_raw %>% mutate_if(is.numeric, scale)

clean_test_data_raw_std[is.na(clean_test_data_raw_std)]=0

# clean_test_data_raw_std = clean_test_data_raw_std %>%
#   select_if(function(col) sd(col) != 0)

test_data_raw_522 = test_data_522 %>%
  select(-contains("EZ"), -contains("hddm"))

clean_test_data_raw_522 = remove_correlated_task_variables(test_data_raw_522)

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_test_data_raw_522) == T]
clean_test_data_raw_522 = transform_remove_skew(clean_test_data_raw_522, numeric_cols)

clean_test_data_raw_std_522 = clean_test_data_raw_522 %>% mutate_if(is.numeric, scale)

clean_test_data_raw_std_522[is.na(clean_test_data_raw_std_522)]=0

data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/'
release = 'Complete_03-29-2018/'
dataset = 'demographic_health.csv'

demographics = get_demographics(dataset = paste0(data_path, release, dataset))

demographics_522 = demographics

demographics = demographics %>%
  filter(X %in% test_data$sub_id)

clean_test_data_raw_std = cbind(clean_test_data_raw_std, demographics[,c("Age", "Sex")])

res_clean_test_data_raw = residualize_baseline(clean_test_data_raw_std)

clean_test_data_raw_std_522 = cbind(clean_test_data_raw_std_522, demographics_522[,c("Age", "Sex")])

res_clean_test_data_raw_522 = residualize_baseline(clean_test_data_raw_std_522)

retest_data_raw = retest_data %>%
  select(-contains("EZ"), -contains("hddm"))

clean_retest_data_raw = remove_correlated_task_variables(retest_data_raw)

res_clean_test_data_raw_nont2subs = res_clean_test_data_raw_522[test_data_522$sub_id %in% retest_data$sub_id == FALSE,]

# clean_retest_data_raw = as.data.frame(apply(clean_retest_data_raw, 2, remove_outliers))

numeric_cols = get_numeric_cols()
numeric_cols = numeric_cols[numeric_cols %in% names(clean_retest_data_raw) == T]
clean_retest_data_raw = transform_remove_skew(clean_retest_data_raw, numeric_cols)

clean_retest_data_raw_std = clean_retest_data_raw %>% mutate_if(is.numeric, scale)

clean_retest_data_raw_std[is.na(clean_retest_data_raw_std)]=0

# clean_retest_data_raw_std = clean_retest_data_raw_std %>%
#   select_if(function(col) sd(col) != 0)

release = 'Retest_03-29-2018/'

demographics = get_demographics(dataset = paste0(data_path, release, dataset))

demographics = demographics %>%
  filter(X %in% retest_data$sub_id)

clean_retest_data_raw_std = cbind(clean_retest_data_raw_std, demographics[,c("Age", "Sex")])

res_clean_retest_data_raw = residualize_baseline(clean_retest_data_raw_std)

