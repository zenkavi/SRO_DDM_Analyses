source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df_sample_size_summary')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_reldf_sample_size.R')
}

rel_df_sample_size_summary %>%
  na.omit() %>%
  ggplot(aes(factor(sample_size), mean_icc))+
  geom_line(aes(group = dv), alpha = 0.1)+
  geom_line(data = tmp,aes(factor(sample_size),mean_icc, group=1), color="purple", size=1)+
  geom_point(data = tmp,aes(factor(sample_size),mean_icc), color="purple", size=2)+
  geom_errorbar(data = tmp,aes(ymin=mean_icc-sem_icc, ymax = mean_icc+sem_icc), color="purple", width = 0.1)+
  ylab("Mean reliability of 100 samples of size n")+
  xlab("Sample size")+
  ylim(-1,1)

ggsave(paste0('rel_by_samplesize.', out_device), device = out_device, path = fig_path, width = 5, height = 3.5, units = "in")