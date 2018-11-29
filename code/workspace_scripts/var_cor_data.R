require(tidyverse)

if(!exists('rel_df')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_point_rel_data.R'), ssl.verifypeer = FALSE)))
}

if(!exists('t1_data_std') | !exists('retest_data_std') | !exists('all_data_cor')){

  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE)))

  #Standardize dataset
  test_data_std = test_data %>% mutate_if(is.numeric, scale)
  test_data_std = test_data_std %>% select(-sub_id)

  #Get correlation table for test data and melt into long form
  test_data_cor = data.frame(cor(test_data_std, use="pairwise.complete.obs"))
  test_data_cor = test_data_cor %>%
    mutate(dv = row.names(.)) %>%
    gather(key, value, -dv) %>%
    filter(value != 1 & duplicated(value)==FALSE)

  #Add measure type info to long form correlation table
  test_data_cor = test_data_cor %>%
    left_join(rel_df %>% select(dv, task_group, raw_fit, rt_acc, ddm_raw), by = "dv") %>%
    rename(var_1 = dv, dv = key, task_group_1 = task_group, raw_fit_1 = raw_fit, rt_acc_1 = rt_acc, ddm_raw_1 = ddm_raw) %>%
    left_join(rel_df %>% select(dv, task_group, raw_fit, rt_acc, ddm_raw), by = "dv") %>%
    rename(var_2 = dv, task_group_2 = task_group, raw_fit_2 = raw_fit, rt_acc_2 = rt_acc, ddm_raw_2 = ddm_raw)%>%
    mutate(task_task = ifelse(task_group_1 == task_group_2,"same task", "different tasks"),
           ddm_ddm = ifelse((rt_acc_1 == "drift rate" & rt_acc_2 == "drift rate")|(rt_acc_1 == "threshold" & rt_acc_2 == "threshold")|(rt_acc_1 == "non-decision" & rt_acc_2 == "non-decision"), "ddm-ddm", ifelse((rt_acc_1 == "rt" & rt_acc_2 == "rt") | (rt_acc_1 == "accuracy" & rt_acc_2 == "accuracy"), 'raw-raw', NA)),
           time="test")

  #Standardize dataset
  retest_data_std = retest_data %>% mutate_if(is.numeric, scale)
  retest_data_std = retest_data_std %>% select(-sub_id)

  #Get same correlation table for retest data
  retest_data_cor = data.frame(cor(retest_data_std, use="pairwise.complete.obs"))
  retest_data_cor = retest_data_cor %>%
    mutate(dv = row.names(.)) %>%
    gather(key, value, -dv) %>%
    filter(value != 1 & duplicated(value)==FALSE)

  retest_data_cor = retest_data_cor %>%
    left_join(rel_df %>% select(dv, task_group, raw_fit, rt_acc, ddm_raw), by = "dv") %>%
    rename(var_1 = dv, dv = key, task_group_1 = task_group, raw_fit_1 = raw_fit, rt_acc_1 = rt_acc, ddm_raw_1 = ddm_raw) %>%
    left_join(rel_df %>% select(dv, task_group, raw_fit, rt_acc, ddm_raw), by = "dv") %>%
    rename(var_2 = dv, task_group_2 = task_group, raw_fit_2 = raw_fit, rt_acc_2 = rt_acc, ddm_raw_2 = ddm_raw) %>%
    mutate(task_task = ifelse(task_group_1 == task_group_2,"same task", "different tasks"),
           ddm_ddm = ifelse((rt_acc_1 == "drift rate" & rt_acc_2 == "drift rate")|(rt_acc_1 == "threshold" & rt_acc_2 == "threshold")|(rt_acc_1 == "non-decision" & rt_acc_2 == "non-decision"), "ddm-ddm", ifelse((rt_acc_1 == "rt" & rt_acc_2 == "rt") | (rt_acc_1 == "accuracy" & rt_acc_2 == "accuracy"), 'raw-raw', NA)),
           time="retest")

  all_data_cor = rbind(test_data_cor, retest_data_cor)

  rm(test_data_cor, retest_data_cor)

  all_data_cor = all_data_cor %>%
    filter(!(raw_fit_1 == 'hddm' & raw_fit_2 == "EZ") & !(raw_fit_1 == "EZ" & raw_fit_2 == "hddm")) %>%
    mutate(model = ifelse(raw_fit_1 == "hddm" & raw_fit_2 == 'hddm', 'hddm', ifelse(raw_fit_1 == "EZ" & raw_fit_1 == "EZ", "EZ", 'raw')))

  all_data_cor_med = all_data_cor %>%
    group_by(task_task, ddm_ddm, model) %>%
    summarise(median_abs_cor = median(abs(value)),
              mean_abs_cor = mean(abs(value))) %>%
    filter(!is.na(ddm_ddm))

}
