if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('res_clean_test_data_ez_522_condition')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ez_fa_data.R')
}

if(!exists('rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
}

res_clean_test_data_ez_522_condition = res_clean_test_data_ez_522 %>%
  select((measure_labels %>% 
            filter(raw_fit == "EZ" & overall_difference == "condition"))$dv)

ez_t1_522_fa_3_condition = fa(res_clean_test_data_ez_522_condition, 3, rotate='oblimin', fm='minres', scores='Anderson')

res_clean_retest_data_ez_condition = res_clean_retest_data_ez %>%
  select((measure_labels %>% 
            filter(raw_fit == "EZ" & overall_difference == "condition"))$dv)

ez_t2_fa_3_condition_pred = predict(ez_t1_522_fa_3_condition, res_clean_retest_data_ez_condition)

ez_t1_522_fa_3_condition_scores = as.data.frame(ez_t1_522_fa_3_condition$scores) %>%
  mutate(sub_id = test_data_522$sub_id)

ez_t2_fa_3_condition_pred_scores = data.frame(ez_t2_fa_3_condition_pred) %>%
  mutate(sub_id = retest_data$sub_id)

ez_fa_rel_df = make_rel_df(t1_df = ez_t1_522_fa_3_condition_scores, t2_df = ez_t2_fa_3_condition_pred_scores, metrics = "icc")

ez_fa_rel_df = ez_fa_rel_df %>%
  mutate(rt_acc = ifelse(dv == "MR1", "Drift rate", ifelse(dv == "MR2", "Non-decision","Threshold")))

rel_df %>%
  mutate(rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision"), labels = c("Drift rate", "Threshold", "Non-decision")))%>%
  filter(dv %in% names(res_clean_retest_data_ez_condition)) %>%
  ggplot(aes(icc))+
  geom_density(aes(color = rt_acc),size=2, position="identity")+
  geom_vline(data = ez_fa_rel_df,aes(xintercept = icc, col=rt_acc), size=2)+
  xlim(-0.5, 1)+
  theme(legend.title = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_text(size=16),
        axis.title = element_text(size=16))+
  xlab("ICC")+
  ylab()

ggsave(paste0('ez_fa_rel_t2pred.', out_device), device = out_device, path = fig_path, width = 5, height = 5.5, units = "in")
