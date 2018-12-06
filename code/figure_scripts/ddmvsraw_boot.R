if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('boot_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_boot_rel_data.R')
  
  boot_df = fullfit_boot_df %>%
    filter(dv %in% unique(refit_boot_df$dv) == FALSE)
  
  boot_df = rbind(boot_df, refit_boot_df)
  
  rm(fullfit_boot_df, refit_boot_df)
  
}

hddm_hack_nd = boot_df %>%
  group_by(dv) %>%
  summarise(mean_icc = mean(icc),
            rt_acc = unique(rt_acc),
            overall_difference = unique(overall_difference),
            raw_fit = unique(raw_fit)) %>%
  mutate(rt_acc = as.character(rt_acc),
         raw_fit = factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")),
         rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision", "rt","accuracy"), labels=c("Drift Rate", "Threshold", "Non-decision", "Response Time", "Accuracy")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(raw_fit == "Hierarchical diffusion" & rt_acc == "Non-decision") %>%
  group_by(overall_difference, raw_fit, rt_acc) %>%
  summarise(sem_icc = sem(mean_icc),
            mean_icc = mean(mean_icc)) %>%
  ungroup()%>%
  mutate(overall_difference = "Condition")

boot_df %>%
  group_by(dv) %>%
  summarise(mean_icc = mean(icc),
            rt_acc = unique(rt_acc),
            overall_difference = unique(overall_difference),
            raw_fit = unique(raw_fit)) %>%
  mutate(rt_acc = as.character(rt_acc),
         raw_fit = factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")),
         rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision", "rt","accuracy"), labels=c("Drift Rate", "Threshold", "Non-decision", "Response Time", "Accuracy")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(overall_difference != "Non-contrast") %>%
  group_by(overall_difference, raw_fit, rt_acc) %>%
  summarise(sem_icc = sem(mean_icc),
            mean_icc = mean(mean_icc)) %>%
  bind_rows(hddm_hack_nd)%>%
  ggplot(aes(raw_fit, mean_icc, fill=rt_acc))+
  geom_bar(stat="identity",position = position_dodge())+
  geom_errorbar(aes(ymin = mean_icc - sem_icc, ymax = mean_icc+sem_icc, color = rt_acc), position=position_dodge(width=0.9), width=0.1)+
  facet_wrap(~overall_difference)+
  ylab("ICC")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.text = element_text(size = 16),
        axis.text = element_text(size=16), 
        strip.text = element_text(size=16),
        axis.title.y = element_text(size=16))+
  scale_y_continuous(breaks=seq(0,1,0.25),
                     limits = c(0,1))+
  guides(fill = guide_legend(nrow=2, byrow=T))

#ADD FIX_DDM_LEGEND
#fix_ddm_legend(ddm_boot_plot)

#rm(mylegend, ddm_boot_plot)

ggsave(paste0('ddmvsraw_boot.', out_device), device = out_device, path = fig_path, width = 12.5, height = 3.5, units = "in")
