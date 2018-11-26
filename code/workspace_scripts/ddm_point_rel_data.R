if(!exists('make_rel_df')){
  helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
  eval(parse(text = getURL(paste0(helper_func_path,'make_rel_df.R'), ssl.verifypeer = FALSE)))
}

if(!exists('measure_labels')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE))
}

if(!exists('test_data_hddm_fullfit') | !exists('test_data_hddm_refit') | !exists('retest_data')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE))
}

### Create reliability point estimates

rel_df_fullfit = make_rel_df(t1_df = test_data_hddm_fullfit, t2_df = retest_data, metrics = c('icc', 'pearson', 'var_breakdown'))

rel_df_refit = make_rel_df(t1_df = test_data_hddm_refit, t2_df = retest_data, metrics = c('icc', 'pearson', 'var_breakdown'))

rel_df_fullfit = rel_df_fullfit %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv") %>%
  mutate(var_subs_pct = (var_subs/(var_subs+var_ind+var_resid))*100,
         var_ind_pct  = (var_ind/(var_subs+var_ind+var_resid))*100,
         var_resid_pct = (var_resid/(var_subs+var_ind+var_resid))*100)

rel_df_refit = rel_df_refit %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv") %>%
  mutate(var_subs_pct = (var_subs/(var_subs+var_ind+var_resid))*100,
         var_ind_pct  = (var_ind/(var_subs+var_ind+var_resid))*100,
         var_resid_pct = (var_resid/(var_subs+var_ind+var_resid))*100)

rel_df = rel_df_refit
