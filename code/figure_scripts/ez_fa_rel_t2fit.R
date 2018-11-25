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

ez_t2_fa_3 = fa(res_clean_retest_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t1_fa_3_scores = as.data.frame(ez_t1_fa_3$scores) %>%
  mutate(sub_id = test_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR2, non_dec = MR3)

ez_t2_fa_3_scores = as.data.frame(ez_t2_fa_3$scores) %>%
  mutate(sub_id = retest_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR3, non_dec = MR2)

ez_fa_rel_df = make_rel_df(ez_t1_fa_3_scores, ez_t2_fa_3_scores, metrics = c("icc"))

rel_df %>%
  filter(dv %in% names(res_clean_test_data_ez)) %>%
  ggplot(aes(icc))+
  geom_density(aes(fill = rt_acc),alpha = 0.5, position="identity", color=NA)+
  geom_vline(data = ez_fa_rel_df,aes(xintercept = icc, col=dv))+
  xlim(-0.5, 1)+
  theme(legend.title = element_blank())+
  xlab("ICC")+
  guides(color=FALSE)

ggsave(paste0('ez_fa_rel_t2fit.', out_device), device = out_device, path = fig_path, width = 5, height = 5, units = "in")

ez_t1_loadings = data.frame(ez_t1_fa_3$loadings[]) %>%
  mutate(dv = row.names(.)) %>%
  rename(drift_rate = MR1, threshold = MR2, non_dec = MR3)

ez_t2_loadings = data.frame(ez_t2_fa_3$loadings[]) %>%
  mutate(dv = row.names(.)) %>%
  rename(drift_rate = MR1, threshold = MR3, non_dec = MR2)

load_cors = diag(cor(ez_t1_loadings%>%select(-dv), ez_t2_loadings%>%select(-dv)))
load_cors = data.frame(par = row.names(data.frame(load_cors)), 
                       r = data.frame(load_cors)$load_cors)
load_cors$r = paste("r =",as.character(round(load_cors$r, 2)))

ez_t1_loadings %>%
  left_join(ez_t2_loadings, by = "dv") %>%
  gather(key, value, -dv) %>%
  separate(key, c("par", "model"), sep = "\\.") %>%
  mutate(model = ifelse(model == "x", "T1_fit", "T2_fit"))%>%
  spread(model, value) %>%
  ggplot(aes(T1_fit, T2_fit))+
  geom_point(aes(col=par))+
  geom_abline(aes(slope=1, intercept=0))+
  geom_text(data=load_cors, x = 0.5, y = -0.4, label = load_cors$r)+
  facet_wrap(~par)+
  theme(legend.title = element_blank(),
        strip.text = element_blank())+
  scale_color_manual(labels=c("drift rate", "non-decision", "threshold"),
                     breaks = c("drift_rate", "non_dec", "threshold"),
                     values = c("#E69F00" ,"#56B4E9", "#009E73"))+
  xlab("Factor loading for T1 model")+
  ylab("Factor loading for T2 model")

ggsave(paste0('ez_fa_t1vst2_loadings.', out_device), device = out_device, path = fig_path, width = 9, height = 5, units = "in")
