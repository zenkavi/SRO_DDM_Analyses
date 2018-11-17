if(!exists('rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
}

if(!exists('t1_data_std') | !exists('retest_data_std') | !exists('all_data_cor')){
  
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_subject_data.R')
  
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
    rename(var_2 = dv, task_group_2 = task_group, raw_fit_2 = raw_fit, rt_acc_2 = rt_acc, ddm_raw_2 = ddm_raw) %>%
    mutate(task_task = ifelse(task_group_1 == task_group_2,"same task", "different tasks"),
           ddm_ddm = ifelse(ddm_raw_1 == "ddm" & ddm_raw_2 == "ddm", "ddm-ddm",ifelse(ddm_raw_1 == "raw" & ddm_raw_2 == "raw", "raw-raw", ifelse((ddm_raw_1 == "ddm" & ddm_raw_2 == "raw") |(ddm_raw_1 == "raw" & ddm_raw_2 == "ddm"), "ddm-raw", NA))),
           time="test")
  
  #summarise by relationship between correlated variables for plotting
  test_data_cor_med = test_data_cor %>%
    na.exclude() %>%
    group_by(task_task, ddm_ddm) %>%
    summarise(median_abs_cor = median(abs(value)),
              mean_abs_cor = mean(abs(value)),
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
           ddm_ddm = ifelse(ddm_raw_1 == "ddm" & ddm_raw_2 == "ddm", "ddm-ddm",ifelse(ddm_raw_1 == "raw" & ddm_raw_2 == "raw", "raw-raw", ifelse((ddm_raw_1 == "ddm" & ddm_raw_2 == "raw") |(ddm_raw_1 == "raw" & ddm_raw_2 == "ddm"), "ddm-raw", NA))),
           time="retest")
  
  retest_data_cor_med = retest_data_cor %>%
    na.exclude() %>%
    group_by(task_task, ddm_ddm) %>%
    summarise(median_abs_cor = median(abs(value)),
              mean_abs_cor = mean(abs(value)), 
              time = "retest")
  
  all_data_cor = rbind(test_data_cor, retest_data_cor)
  all_data_cor_med = rbind(test_data_cor_med, retest_data_cor_med)
  
  all_data_cor %>%
    na.exclude() %>%
    ggplot(aes(abs(value), fill=time))+
    geom_histogram(position = "identity", alpha=0.5)+
    geom_vline(data=all_data_cor_med, aes(xintercept=median_abs_cor, color=time), linetype = "dashed")+
    facet_grid(task_task~ddm_ddm, scales = 'free_y')+
    xlab("Absolute correlation")+
    theme(legend.position = "bottom",
          legend.title = element_blank())
  
  rm(test_data_cor, retest_data_cor, test_data_cor_med, retest_data_cor_med)
  
}
