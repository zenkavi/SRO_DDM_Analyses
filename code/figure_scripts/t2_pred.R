library(tidyverse)
library(RCurl)

if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'

eval(parse(text = getURL(paste0(helper_func_path,'sem.R'), ssl.verifypeer = FALSE)))

input_path = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/input/'

t1_ez_fa_t1_demog = read.csv(paste0(input_path,'/prediction/pred_out_ez_t1_fa_3_scores_demog_fa_scores_t1.csv'))

t1_ez_fa_t1_demog = t1_ez_fa_t1_demog %>%
  mutate(RsquaredSE = RsquaredSD/sqrt(10),
         iv=as.character(iv),
         dv = as.character(dv),
         iv_data = as.character(iv_data),
         dv_data = as.character(dv_data)) %>%
  select(dv, iv, Rsquared, RsquaredSE, iv_data, dv_data)


t1_ez_mes_t1_demog = read.csv(paste0(input_path, 'prediction/pred_out_res_clean_test_data_ez_demog_fa_scores_t1.csv'))

t1_ez_mes_t1_demog = t1_ez_mes_t1_demog %>%
  mutate(par = ifelse(grepl("drift",iv), "drift_rate", ifelse(grepl("thresh", iv), "threshold", ifelse(grepl("non_decision", iv), "non_decision", NA)))) %>% 
  group_by(dv, par) %>%
  summarise(RsquaredSE = sem(Rsquared),
            Rsquared = mean(Rsquared),
            iv_data = as.character(unique(iv_data)),
            dv_data = as.character(unique(dv_data))) %>%
  rename(iv = par) %>%
  ungroup() %>%
  mutate(dv = as.character(dv)) %>%
  select(dv, iv, Rsquared, RsquaredSE, iv_data, dv_data)

t1_raw_t1_demog = read.csv(paste0(input_path,'prediction/pred_out_res_clean_test_data_raw_demog_fa_scores_t1.csv'))

ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'

eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE)))

t1_raw_t1_demog = t1_raw_t1_demog %>%
  mutate(iv=as.character(iv),
         iv=gsub(".ReflogTr", "",iv),
         iv=gsub(".logTr", "",iv)) %>% 
  left_join(measure_labels %>% select(dv, rt_acc) %>% rename(iv=dv), by="iv") %>%
  group_by(dv, rt_acc) %>%
  summarise(RsquaredSE = sem(Rsquared),
            Rsquared = mean(Rsquared),
            iv_data = as.character(unique(iv_data)),
            dv_data = as.character(unique(dv_data))) %>%
  rename(iv = rt_acc) %>%
  ungroup() %>%
  mutate(dv = as.character(dv)) %>%
  select(dv, iv, Rsquared, RsquaredSE, iv_data, dv_data)

p = t1_ez_fa_t1_demog %>%
  bind_rows(t1_ez_mes_t1_demog) %>%
  bind_rows(t1_raw_t1_demog) %>%
  mutate(iv = factor(iv, levels = c("accuracy", "rt", "drift_rate", "threshold", "non_decision"), labels=c("accuracy", "rt", "drift rate", "threshold", "non-decision")),
         dv = factor(dv, levels = c('Drug_Use','Mental_Health','Problem_Drinking','Daily_Smoking','Binge_Drinking','Obesity','Lifetime_Smoking','Unsafe_Drinking','Income_LifeMilestones'), labels = c('Drug Use','Mental Health','Problem Drinking','Daily Smoking','Binge Drinking','Obesity','Lifetime Smoking','Unsafe Drinking','Income/Life Milestones'))) %>%
  ggplot(aes(iv, Rsquared, fill=iv, alpha=iv_data))+
  geom_bar(stat="identity", position = position_dodge())+
  geom_errorbar(aes(ymin=Rsquared-RsquaredSE, ymax=Rsquared+RsquaredSE, color=iv), position=position_dodge(width=0.9), width=0.1)+
  facet_wrap(~dv, scales='free_x')+
  theme(legend.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.text = element_text(size=16),
        strip.text = element_text(size=16),
        axis.title.y = element_text(size=16),
        axis.text.y= element_text(size=14))+
  xlab("")+
  ylab(expression(R^{2}))+
  scale_alpha_manual(values = c(0.5, 1, 1))+
  guides(alpha=FALSE)

ggsave(paste0('t1_pred_9.', out_device), plot=p, device = out_device, path = fig_path, width = 20, height = 9, units = "in")

ggsave(paste0('t1_pred_4.', out_device), plot=p, device = out_device, path = fig_path, width = 20, height = 9, units = "in")
