source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('test_data_hddm_fullfit') | !exists('test_data_hddm_refit')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_subject_data.R')
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

hddm_pars %>%
  ggplot(aes(scaled_diff))+
  geom_density(aes(fill = dv), alpha = 0.2, color = NA)+
  geom_density(fill = "black", alpha = 1, color=NA)+
  theme(legend.position = "none")+
  xlab("Scaled difference of HDDM parameter estimate (full - refit)")

ggsave(paste0('HDDM_par_diff.', out_device), device = out_device, path = fig_path, width = 5, height = 3.5, units = "in")