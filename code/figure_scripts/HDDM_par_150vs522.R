source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('hddm_pars')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_pars_data.R')
}

hddm_pars %>%
  ggplot(aes(scaled_diff))+
  geom_density(aes(fill = dv), alpha = 0.2, color = NA)+
  geom_density(fill = "black", alpha = 1, color=NA)+
  theme(legend.position = "none")+
  xlab("Scaled difference of HDDM parameter estimate \n (n=522 - n=150)")

ggsave(paste0('HDDM_par_150vs522.', out_device), device = out_device, path = fig_path, width = 4, height = 2.9, units = "in")
