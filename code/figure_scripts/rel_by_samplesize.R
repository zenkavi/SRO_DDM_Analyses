source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df_sample_size_summary')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_reldf_sample_size.R')
}

tmp = tmp %>%
  ungroup()%>%
  mutate(overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(overall_difference != "Non-contrast")

rel_df_sample_size_summary %>%
  na.omit() %>%
  ungroup()%>%
  mutate(ddm_raw = factor(ddm_raw, levels = c("raw", "ddm"), labels=c("Raw", "DDM")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(overall_difference != "Non-contrast") %>%
  ggplot(aes(factor(sample_size), mean_icc, color=ddm_raw))+
  geom_line(aes(group = dv), alpha = 0.1)+
  geom_line(data = tmp,aes(factor(sample_size),mean_icc, group=1), color="purple", size=1)+
  geom_point(data = tmp,aes(factor(sample_size),mean_icc), color="purple", size=2)+
  geom_errorbar(data = tmp,aes(ymin=mean_icc-sem_icc, ymax = mean_icc+sem_icc), color="purple", width = 0.1)+
  facet_wrap(~overall_difference)+
  ylab("Mean reliability of 100 samples of size n")+
  xlab("Sample size")+
  ylim(-1,1)+
  theme(legend.position = "none",
        panel.grid=element_blank())

ggsave(paste0('rel_by_samplesize.', out_device), device = out_device, path = fig_path, width = 10, height = 3.5, units = "in")
