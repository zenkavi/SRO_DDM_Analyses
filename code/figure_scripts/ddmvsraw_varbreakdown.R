if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sem.R', ssl.verifypeer = FALSE)))

if(!exists('rel_df')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ddm_point_rel_data.R', ssl.verifypeer = FALSE)))
  
}

hddm_hack_nd = rel_df %>%
  group_by(rt_acc, overall_difference, raw_fit) %>%
  summarise(mean_var_subs_pct = mean(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  ungroup()%>%
  mutate(rt_acc = as.character(rt_acc),
         raw_fit = factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")),
         rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision", "rt","accuracy"), labels=c("Drift Rate", "Threshold", "Non-decision", "Response Time", "Accuracy")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(raw_fit == "Hierarchical diffusion" & rt_acc == "Non-decision") %>%
  mutate(overall_difference = "Condition")

rel_df %>%
  group_by(rt_acc, overall_difference, raw_fit) %>%
  summarise(mean_var_subs_pct = mean(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  ungroup()%>%
  mutate(raw_fit = factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")),
         rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision", "rt","accuracy"), labels=c("Drift Rate", "Threshold", "Non-decision", "Response Time", "Accuracy")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(overall_difference != "Non-contrast") %>%
  bind_rows(hddm_hack_nd) %>%
  ggplot(aes(raw_fit, mean_var_subs_pct, fill=rt_acc))+
  geom_bar(stat = "identity", position=position_dodge())+
  geom_errorbar(aes(ymin = mean_var_subs_pct - sem_var_subs_pct, ymax = mean_var_subs_pct + sem_var_subs_pct, color=rt_acc), position=position_dodge(width=0.9), width=0)+
  facet_wrap(~overall_difference)+
  ylab("% of between subjects variance")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')+
  ylim(0,75)+
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.text = element_text(size = 16),
        axis.text = element_text(size=16), 
        strip.text = element_text(size=16),
        axis.title.y = element_text(size=16))+
  scale_y_continuous(breaks=seq(0,100,25),
                     limits = c(0,100))+
  guides(fill = guide_legend(nrow=2, byrow=T))

ggsave(paste0('ddmvsraw_varsubs.', out_device), device = out_device, path = fig_path, width = 12, height = 4, units = "in")

rel_df %>%
  group_by(rt_acc, overall_difference, raw_fit) %>%
  summarise(mean_var_subs_pct = mean(var_subs_pct),
            mean_var_ind_pct = mean(var_ind_pct),
            mean_var_resid_pct = mean(var_resid_pct),
            sem_var_subs_pct = sem(var_subs_pct),
            sem_var_ind_pct = sem(var_ind_pct),
            sem_var_resid_pct = sem(var_resid_pct)) %>%
  ungroup()%>%
  mutate(raw_fit = factor(raw_fit, levels = c("raw", "EZ", "hddm"), labels=c("Raw", "EZ-diffusion", "Hierarchical diffusion")),
         rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision", "rt","accuracy"), labels=c("Drift Rate", "Threshold", "Non-decision", "Response Time", "Accuracy")),
         overall_difference = factor(overall_difference, levels = c("non-contrast", "condition", "contrast"), labels=c("Non-contrast", "Condition", "Contrast"))) %>%
  filter(overall_difference != "Non-contrast") %>%
  bind_rows(hddm_hack_nd) %>%
  ggplot(aes(raw_fit, mean_var_resid_pct, fill=rt_acc))+
  geom_bar(stat = "identity", position=position_dodge())+
  geom_errorbar(aes(ymin = mean_var_resid_pct - sem_var_resid_pct, ymax = mean_var_resid_pct + sem_var_resid_pct, color=rt_acc), position=position_dodge(width=0.9), width=0)+
  facet_wrap(~overall_difference)+
  ylab("% of residual variance")+
  xlab("")+
  theme(legend.title = element_blank(),
        legend.position = 'bottom')+
  ylim(0,75)+
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.text = element_text(size = 16),
        axis.text = element_text(size=16), 
        strip.text = element_text(size=16),
        axis.title.y = element_text(size=16))+
  scale_y_continuous(breaks=seq(0,100,25),
                     limits = c(0,55))+
  guides(fill = guide_legend(nrow=2, byrow=T))

ggsave(paste0('ddmvsraw_varresid.', out_device), device = out_device, path = fig_path, width = 12, height = 4, units = "in")
