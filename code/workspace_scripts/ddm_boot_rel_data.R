if(!exists('process_boot_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/process_boot_df')
}

### Read in bootstrapped rel data

fullfit_boot_df <- read.csv(gzfile(paste0(retest_data_path,'bootstrap_merged.csv.gz')), header=T)

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
