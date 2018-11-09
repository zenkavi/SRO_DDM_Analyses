source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('all_data_cor')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/var_cor_data.R')
}

all_data_cor %>%
  na.exclude() %>%
  ggplot(aes(abs(value), fill=time))+
  geom_histogram(position = "identity", alpha=0.5)+
  geom_vline(data=all_data_cor_med, aes(xintercept=median_abs_cor, color=time), linetype = "dashed")+
  facet_grid(task_task~ddm_ddm, scales = 'free_y')+
  xlab("Absolute correlation")+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        strip.text = element_text(size=16),
        axis.title.x = element_text(size=16))+
  ylab('')

ggsave(paste0('ddm_raw_vars_cor.', out_device), device = out_device, path = fig_path, width = 14, height = 5, units = "in")
