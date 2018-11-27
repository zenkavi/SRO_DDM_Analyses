if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

if(!exists('ez_pred_out')){
  read.csv('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/input/ez_pred_out.csv')
}

p = ez_pred_out %>%
  mutate(RsquaredSE = RsquaredSD/sqrt(10),
         t = ifelse(grepl("t1", model), "t1", "t2"),
         par = ifelse(iv %in% c("drift_rate", "non_decision", "threshold"), iv, "measure"),
         par = factor(par, levels = c("drift_rate", "non_decision", "threshold", "measure"),labels = c("drift_rate", "non_decision", "threshold", "measure")),
         dv = gsub("_", " ", dv)) %>%
  group_by(model, par, dv, t) %>%
  summarise(Rsquared = mean(Rsquared),
            RsquaredSE = ifelse(length(unique(RsquaredSE))==1, unique(RsquaredSE), sum(Rsquared^2)/sqrt(n()))) %>%
  ungroup() %>%
  filter(t == "t1") %>%
  ggplot(aes(dv, Rsquared, fill=par))+
  geom_bar(stat="identity", position = position_dodge())+
  geom_errorbar(aes(ymin=Rsquared-RsquaredSE, ymax=Rsquared+RsquaredSE, col=par), position = position_dodge(width=0.9), width=.1)+
  xlab("")+
  ylab(expression(R^{2}))+
  theme(legend.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank())+
  facet_grid(.~dv, scales="free_x")

ggsave(paste0('ez_pred_t1.', out_device), plot=p, device = out_device, path = fig_path, width = 16, height = 4, units = "in")

p = ez_pred_out %>%
  mutate(RsquaredSE = RsquaredSD/sqrt(10),
         t = ifelse(grepl("t1", model), "t1", "t2"),
         par = ifelse(iv %in% c("drift_rate", "non_decision", "threshold"), iv, "measure"),
         par = factor(par, levels = c("drift_rate", "non_decision", "threshold", "measure"),labels = c("drift_rate", "non_decision", "threshold", "measure")),
         dv = gsub("_", " ", dv)) %>%
  group_by(model, par, dv, t) %>%
  summarise(Rsquared = mean(Rsquared),
            RsquaredSE = ifelse(length(unique(RsquaredSE))==1, unique(RsquaredSE), sum(Rsquared^2)/sqrt(n()))) %>%
  ungroup() %>%
  filter(model  %in% c("ez_t2_fa_3_pred","ez_t2_measures")) %>%
  ggplot(aes(dv, Rsquared, fill=par))+
  geom_bar(stat="identity", position = position_dodge())+
  geom_errorbar(aes(ymin=Rsquared-RsquaredSE, ymax=Rsquared+RsquaredSE, col=par), position = position_dodge(width=0.9), width=.1)+
  xlab("")+
  ylab(expression(R^{2}))+
  theme(legend.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank())+
  facet_grid(.~dv, scales="free_x")

ggsave(paste0('ez_pred_t2_pred.', out_device), plot=p, device = out_device, path = fig_path, width = 16, height = 4, units = "in")

p = ez_pred_out %>%
  mutate(RsquaredSE = RsquaredSD/sqrt(10),
         t = ifelse(grepl("t1", model), "t1", "t2"),
         par = ifelse(iv %in% c("drift_rate", "non_decision", "threshold"), iv, "measure"),
         par = factor(par, levels = c("drift_rate", "non_decision", "threshold", "measure"),labels = c("drift_rate", "non_decision", "threshold", "measure")),
         dv = gsub("_", " ", dv)) %>%
  group_by(model, par, dv, t) %>%
  summarise(Rsquared = mean(Rsquared),
            RsquaredSE = ifelse(length(unique(RsquaredSE))==1, unique(RsquaredSE), sum(Rsquared^2)/sqrt(n()))) %>%
  ungroup() %>%
  filter(model  %in% c("ez_t2_fa_3","ez_t2_measures")) %>%
  ggplot(aes(dv, Rsquared, fill=par))+
  geom_bar(stat="identity", position = position_dodge())+
  geom_errorbar(aes(ymin=Rsquared-RsquaredSE, ymax=Rsquared+RsquaredSE, col=par), position = position_dodge(width=0.9), width=.1)+
  xlab("")+
  ylab(expression(R^{2}))+
  theme(legend.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank())+
  facet_grid(.~dv, scales="free_x")

ggsave(paste0('ez_pred_t2_fit.', out_device), plot=p, device = out_device, path = fig_path, width = 16, height = 4, units = "in")
