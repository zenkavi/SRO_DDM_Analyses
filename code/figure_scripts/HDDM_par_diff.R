source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('hddm_pars')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_pars_data.R')
}

hddm_pars %>%
  ggplot(aes(scaled_diff))+
  geom_density(aes(fill = dv), alpha = 0.2, color = NA)+
  geom_density(fill = "black", alpha = 1, color=NA)+
  theme(legend.position = "none")+
  xlab("Scaled difference of HDDM parameter estimate (full - refit)")

ggsave(paste0('HDDM_par_diff.', out_device), device = out_device, path = fig_path, width = 5, height = 3.5, units = "in")