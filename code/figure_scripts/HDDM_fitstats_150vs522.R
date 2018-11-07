source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('refit_fitstats') | !(exists('t1_hierarchical_fitstats'))){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_fitstat_data.R')
}

tmp = rbind(refit_fitstats, t1_hierarchical_fitstats) 

tmp %>%
  filter(task_name != 'motor_selective_stop_signal') %>%
  ggplot(aes(m_kl, fill=sample))+
  geom_density(alpha=0.5)+
  facet_wrap(~task_name)+
  theme(legend.position = "bottom")+
  xlab("Mean KL divergence for all participants")

ggsave(paste0('HDDM_fitstats_150vs522_t.', out_device), device = out_device, path = fig_path, width = 15, height = 10, units = "in")

tmp %>%
  filter(task_name != 'motor_selective_stop_signal') %>%
  ggplot(aes(m_kl, fill=sample))+
  geom_density(alpha=0.5)+
  theme(legend.position = "bottom",
        legend.title=element_blank())+
  xlab("Mean KL divergence for all participants")+
  xlim(0,5)

ggsave(paste0('HDDM_fitstats_150vs522.', out_device), device = out_device, path = fig_path, width = 4, height = 3.5, units = "in")
