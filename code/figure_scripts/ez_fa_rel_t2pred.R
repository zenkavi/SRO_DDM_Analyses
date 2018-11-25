if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('ez_t1_fa_3')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ez_fa_data.R')
}

if(!exists('rel_df')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
}

ez_t1_fa_3 = fa(res_clean_test_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t2_fa_3_pred = predict(ez_t1_fa_3, res_clean_retest_data_ez)

ez_t1_fa_3_scores = as.data.frame(ez_t1_fa_3$scores) %>%
  mutate(sub_id = test_data$sub_id)

ez_t2_fa_3_pred_scores = data.frame(ez_t2_fa_3_pred) %>%
  mutate(sub_id = retest_data$sub_id)

ez_fa_rel_df = make_rel_df(t1_df = ez_t1_fa_3_scores, t2_df = ez_t2_fa_3_pred_scores, metrics = "icc")

ez_fa_rel_df = ez_fa_rel_df %>%
  mutate(rt_acc = ifelse(dv == "MR1", "drift rate", ifelse(dv == "MR2", "threshold","non-decision")))

rel_df %>%
  filter(dv %in% names(res_clean_test_data_ez)) %>%
  ggplot(aes(icc))+
  geom_density(aes(fill = rt_acc),alpha = 0.5, position="identity", color=NA)+
  geom_vline(data = ez_fa_rel_df,aes(xintercept = icc, col=rt_acc))+
  xlim(-0.5, 1)+
  theme(legend.title = element_blank())+
  xlab("ICC")+
  guides(color=FALSE)

ggsave(paste0('ez_fa_rel_t2pred.', out_device), device = out_device, path = fig_path, width = 5, height = 5, units = "in")
