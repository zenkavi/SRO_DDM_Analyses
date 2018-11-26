if(!exists('input_path') | input_path != 'https://raw.githubusercontent.com/zenkavi/Self_DDM_Analyses/master/input/'){
  input_path = 'https://raw.githubusercontent.com/zenkavi/Self_DDM_Analyses/master/input/'
}

rel_df_sample_size = read.csv(gzfile(paste0(input_path, 'rel_df_sample_size.csv.gz')))

#Check if all vars are there
# numeric_cols[which(numeric_cols %in% unique(rel_df_sample_size$dv) == FALSE)]

rel_df_sample_size = rel_df_sample_size %>%
  left_join(measure_labels[,c("dv", "task_group","overall_difference","raw_fit","rt_acc","ddm_raw")], by = "dv") %>%
  mutate(var_subs_pct = (var_subs/(var_subs+var_ind+var_resid))*100,
         var_ind_pct  = (var_ind/(var_subs+var_ind+var_resid))*100,
         var_resid_pct = (var_resid/(var_subs+var_ind+var_resid))*100)

rel_df_sample_size_summary = rel_df_sample_size %>%
  group_by(dv, sample_size, ddm_raw, overall_difference) %>%
  summarise(mean_icc = mean(icc),
            sem_icc = sem(icc),
            mean_var_subs_pct = mean(var_subs_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_resid_pct = sem(var_resid_pct))

tmp = rel_df_sample_size %>%
  group_by(sample_size, overall_difference) %>%
  summarise(mean_icc = mean(icc,na.rm=T),
            sem_icc = sem(icc),
            mean_var_subs_pct = mean(var_subs_pct,na.rm=T),
            sem_var_subs_pct = sem(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct, na.rm=T),
            sem_var_ind_pct = sem(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct,na.rm=T),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  na.omit()
