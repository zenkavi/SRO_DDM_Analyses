if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
  
  rel_df = rel_df_refit
  
  rm(rel_df_fullfit, rel_df_refit)
  
}

rel_df %>%
  mutate(rt_acc = as.character(rt_acc)) %>%
  ggplot(aes(factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")), icc, fill=factor(rt_acc, levels = c("rt","accuracy", "drift rate", "threshold", "non-decision"), labels=c("Response Time", "Accuracy","Drift Rate", "Threshold", "Non-decision"))))+
  geom_boxplot()+
  facet_wrap(~overall_difference)+
  ylab("ICC")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')+
  scale_y_continuous(breaks=seq(-1,1,0.25),
                     limits=c(-1,1))#+
# guides(fill = guide_legend(ncol = 2, byrow=F))

#ADD FIX_DDM_LEGEND
#fix_ddm_legend(ddm_point_plot)

#rm(mylegend, ddm_point_plot)

ggsave(paste0('ddmvsraw_point.', out_device), device = out_device, path = fig_path, width = 12, height = 3.5, units = "in")