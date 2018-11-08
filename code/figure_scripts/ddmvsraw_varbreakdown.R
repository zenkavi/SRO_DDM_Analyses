source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
  
  rel_df = rel_df_refit
  
  rm(rel_df_fullfit, rel_df_refit)
  
}

rel_df %>%
  group_by(rt_acc, overall_difference, raw_fit) %>%
  summarise(mean_var_subs_pct = mean(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  ggplot(aes(factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")), mean_var_subs_pct, color=factor(rt_acc, levels = c("rt","accuracy", "drift rate", "threshold", "non-decision"), labels=c("Response Time", "Accuracy","Drift Rate", "Threshold", "Non-decision"))))+
  geom_point(position=position_dodge(width=0.75), size = 5)+
  geom_errorbar(aes(ymin = mean_var_subs_pct - sem_var_subs_pct, ymax = mean_var_subs_pct + sem_var_subs_pct), position=position_dodge(width=0.75))+
  facet_wrap(~overall_difference)+
  ylab("% of between subjects variance")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')

ggsave(paste0('ddmvsraw_varsubs.', out_device), device = out_device, path = fig_path, width = 10, height = 3.5, units = "in")

rel_df %>%
  group_by(rt_acc, overall_difference, raw_fit) %>%
  summarise(mean_var_subs_pct = mean(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  ggplot(aes(factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")), mean_var_resid_pct, color=factor(rt_acc, levels = c("rt","accuracy", "drift rate", "threshold", "non-decision"), labels=c("Response Time", "Accuracy","Drift Rate", "Threshold", "Non-decision"))))+
  geom_point(position=position_dodge(width=0.75), size = 5)+
  geom_errorbar(aes(ymin = mean_var_resid_pct - sem_var_resid_pct, ymax = mean_var_resid_pct + sem_var_resid_pct), position=position_dodge(width=0.75))+
  facet_wrap(~overall_difference)+
  ylab("% of residual variance")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')

ggsave(paste0('ddmvsraw_varresid.', out_device), device = out_device, path = fig_path, width = 10, height = 3.5, units = "in")