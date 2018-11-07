source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('hddm_rels') | (exists('hddm_rels') & 'fullfit' %in% names(hddm_rels) == FALSE)){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_rel_data.R')
}

hddm_rels %>%
  ggplot(aes(fullfit, refit, col=rt_acc))+
  geom_point()+
  geom_abline(slope=1, intercept = 0)+
  xlab("Reliability of HDDM params using n=522")+
  ylab("Reliability of HDDM params using n=150")+
  theme(legend.title = element_blank(),
        legend.position = "bottom")

ggsave(paste0('HDDM_rel_150vs522.', out_device), device = out_device, path = fig_path, width = 4, height = 3.5, units = "in")
