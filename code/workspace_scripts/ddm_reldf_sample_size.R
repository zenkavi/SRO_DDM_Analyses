if(!exists('input_path')){
  if(from_gh){
    input_path = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/input/'
  }else{
    input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/'
  }
}

if(!exists('measure_labels')){
  if(from_gh){
    ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
    eval(parse(text = getURL(paste0(ddm_workspace_scripts,'hddm_fitstat_data.R'), ssl.verifypeer = FALSE)))
  }else{
    source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_measure_labels.R')
  }
}

if(!exists('sem')){
  if(from_gh){
    retest_helper_func = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
    eval(parse(text = getURL(paste0(retest_helper_func,'hddm_fitstat_data.R'), ssl.verifypeer = FALSE)))
  }else{
    source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/sem.R')
  }
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
