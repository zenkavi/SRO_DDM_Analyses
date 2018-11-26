if(!exists('test_data_hddm_fullfit') | !exists('test_data_hddm_refit')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_subject_data.R'), ssl.verifypeer = FALSE))
}

hddm_pars_fullfit = test_data_hddm_fullfit %>%
  select(sub_id, unique(refit_boot_df$dv)) %>%
  mutate(hddm_sample = "fullfit")

hddm_pars_refit = test_data_hddm_refit %>%
  select(sub_id, unique(refit_boot_df$dv)) %>%
  mutate(hddm_sample = "refit")

hddm_pars = rbind(hddm_pars_fullfit, hddm_pars_refit)
rm(hddm_pars_fullfit, hddm_pars_refit)

hddm_pars = hddm_pars %>%
  gather(dv, value, -sub_id, -hddm_sample) %>%
  spread(hddm_sample, value) %>%
  mutate(diff = fullfit - refit) %>%
  group_by(dv) %>%
  mutate(scaled_diff = scale(diff)) %>%
  select(sub_id, dv, scaled_diff) %>%
  left_join(measure_labels[,c("dv", "rt_acc")], by = "dv") %>%
  filter(rt_acc %in% c("rt", "accuracy") == FALSE) %>%
  na.omit()
