if(!exists('make_rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/make_rel_df.R')
}

if(!exists('measure_labels')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_measure_labels.R')
}

if(!exists('test_data_hddm_fullfit') | !exists('test_data_hddm_refit') | !exists('retest_data')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_subject_data.R')
}

### Create reliability point estimates

rel_df_fullfit = make_rel_df(t1_df = test_data_hddm_fullfit, t2_df = retest_data, metrics = c('icc', 'pearson', 'var_breakdown'))

rel_df_refit = make_rel_df(t1_df = test_data_hddm_refit, t2_df = retest_data, metrics = c('icc', 'pearson', 'var_breakdown'))

rel_df_fullfit = rel_df_fullfit %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv")

rel_df_refit = rel_df_refit %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv")

