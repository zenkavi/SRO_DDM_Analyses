if(!exists('process_boot_df')){
  helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
  eval(parse(text = getURL(paste0(helper_func_path,'process_boot_df.R'), ssl.verifypeer = FALSE)))
}

if(!exists('retest_data_path')){
  retest_data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/Retest_03-29-2018/'
  test_data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/Complete_03-29-2018/'
}

if(!exists('measure_labels')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE)))
}

### Read in bootstrapped rel data

fullfit_boot_df <- read.csv(gzfile(paste0('/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/Retest_03-29-2018/','bootstrap_merged.csv.gz')), header=T)

fullfit_boot_df = process_boot_df(fullfit_boot_df)

fullfit_boot_df = fullfit_boot_df[fullfit_boot_df$dv %in% measure_labels$dv,]

refit_boot_df = read.csv(gzfile(paste0(retest_data_path,'refits_bootstrap_merged.csv.gz')), header=T)

refit_boot_df = process_boot_df(refit_boot_df)

fullfit_boot_df = fullfit_boot_df %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv") %>%
  mutate(var_subs_pct = (var_subs/(var_subs+var_ind+var_resid))*100,
         var_ind_pct  = (var_ind/(var_subs+var_ind+var_resid))*100,
         var_resid_pct = (var_resid/(var_subs+var_ind+var_resid))*100)

refit_boot_df = refit_boot_df %>%
  select(dv, icc, var_subs, var_ind, var_resid) %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc", "ddm_raw")], by = "dv") %>%
  mutate(var_subs_pct = (var_subs/(var_subs+var_ind+var_resid))*100,
         var_ind_pct  = (var_ind/(var_subs+var_ind+var_resid))*100,
         var_resid_pct = (var_resid/(var_subs+var_ind+var_resid))*100)

boot_df = fullfit_boot_df %>%
  filter(dv %in% unique(refit_boot_df$dv) == FALSE)

boot_df = rbind(boot_df, refit_boot_df)
