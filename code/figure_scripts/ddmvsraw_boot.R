source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('boot_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_boot_rel_data.R')
  
  boot_df = fullfit_boot_df %>%
    filter(dv %in% unique(refit_boot_df$dv) == FALSE)
  
  boot_df = rbind(boot_df, refit_boot_df)
  
  rm(fullfit_boot_df, refit_boot_df)
  
}

boot_df %>%
  group_by(dv) %>%
  summarise(mean_icc = mean(icc),
            rt_acc = unique(rt_acc),
            overall_difference = unique(overall_difference),
            raw_fit = unique(raw_fit)) %>%
  mutate(rt_acc = as.character(rt_acc)) %>%
  ggplot(aes(factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")), mean_icc, fill=factor(rt_acc, levels = c("rt","accuracy", "drift rate", "threshold", "non-decision"), labels=c("Response Time", "Accuracy","Drift Rate", "Threshold", "Non-decision"))))+
  geom_boxplot()+
  facet_wrap(~overall_difference)+
  ylab("ICC")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')#+
# guides(fill = guide_legend(ncol = 2, byrow=F))

#ADD FIX_DDM_LEGEND
#fix_ddm_legend(ddm_boot_plot)

#rm(mylegend, ddm_boot_plot)

ggsave(paste0('ddmvsraw_boot.', out_device), device = out_device, path = fig_path, width = 5, height = 3.5, units = "in")