library(tidyverse)
library(RCurl)

if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'

eval(parse(text = getURL(paste0(helper_func_path,'sem.R'), ssl.verifypeer = FALSE)))

input_path = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/input/'

ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'

eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE)))

t1_ez_fa_t1_demog = read.csv(paste0(input_path,'/prediction/pred_out_ez_t1_522_fa_3_condition_scores_demog_fa_scores_t1.csv'))

t1_ez_fa_t1_demog = t1_ez_fa_t1_demog %>%
  select(dv, iv, all_folds_r2, shuffle_95p_r2, iv_data, dv_data) %>%
  rename(mean_all_folds_r2 = all_folds_r2, mean_shuffle_r2 = shuffle_95p_r2) %>%
  mutate(dv = as.character(dv),
         sem_all_folds_r2 = NA,
         sem_shuffle_r2 = NA,
         iv_data = as.character(iv_data),
         dv_data = as.character(dv_data)) %>%
  select(dv, iv, mean_all_folds_r2, sem_all_folds_r2, mean_shuffle_r2, sem_shuffle_r2, iv_data, dv_data)

t1_ez_mes_t1_demog = read.csv(paste0(input_path, '/prediction/pred_out_res_clean_test_data_ez_522_demog_fa_scores_t1.csv'))

t1_ez_mes_t1_demog = t1_ez_mes_t1_demog %>%
  mutate(par = ifelse(grepl("drift",iv), "drift_rate", ifelse(grepl("thresh", iv), "threshold", ifelse(grepl("non_decision", iv), "non_decision", NA)))) %>% 
  group_by(dv, par) %>%
  summarise(mean_all_folds_r2 = mean(all_folds_r2),
            sem_all_folds_r2 = sem(all_folds_r2), 
            mean_shuffle_r2 = mean(shuffle_95p_r2),
            sem_shuffle_r2 = sem(shuffle_95p_r2),
            iv_data = unique(iv_data),
            dv_data = unique(dv_data)) %>%
  rename(iv = par) %>%
  ungroup() %>%
  mutate(dv = as.character(dv),
         iv_data = as.character(iv_data),
         dv_data = as.character(dv_data))

t1_raw_t1_demog = read.csv(paste0(input_path,'prediction/pred_out_res_clean_test_data_raw_522_demog_fa_scores_t1.csv'))

t1_raw_t1_demog = t1_raw_t1_demog %>%
  mutate(iv=as.character(iv),
         iv=gsub(".ReflogTr", "",iv),
         iv=gsub(".logTr", "",iv)) %>% 
  left_join(measure_labels %>% select(dv, rt_acc) %>% rename(iv=dv), by="iv") %>%
  group_by(dv, rt_acc) %>%
  summarise(mean_all_folds_r2 = mean(all_folds_r2),
            sem_all_folds_r2 = sem(all_folds_r2), 
            mean_shuffle_r2 = mean(shuffle_95p_r2),
            sem_shuffle_r2 = sem(shuffle_95p_r2),
            iv_data = unique(iv_data),
            dv_data = unique(dv_data)) %>%
  rename(iv = rt_acc) %>%
  ungroup() %>%
  mutate(dv = as.character(dv),
         iv_data = as.character(iv_data),
         dv_data = as.character(dv_data))

t1_ez_fa_t1_demog %>%
  bind_rows(t1_ez_mes_t1_demog) %>%
  bind_rows(t1_raw_t1_demog) %>%
  mutate(iv = factor(iv, levels = c("drift_rate", "threshold", "non_decision", "accuracy", "rt"), labels=c("Drift rate", "Threshold", "Non-decision", "Accuracy", "RT")),
         dv = factor(dv, levels = c('Drug_Use','Mental_Health','Problem_Drinking','Daily_Smoking','Binge_Drinking','Obesity','Lifetime_Smoking','Unsafe_Drinking','Income_LifeMilestones'), labels = c('Drug Use','Mental Health','Problem Drinking','Daily Smoking','Binge Drinking','Obesity','Lifetime Smoking','Unsafe Drinking','Income/Life Milestones')),
         iv_data = factor(iv_data, levels = c("ez_t1_522_fa_3_condition_scores", 'res_clean_test_data_ez_522','res_clean_test_data_raw_522'), labels = c('DDM latent variables', 'DDM measures', 'Raw measures'))) %>%
  ggplot(aes(iv, mean_all_folds_r2, fill=iv, alpha=iv_data))+
  
  geom_bar(stat="identity", position = position_dodge())+
  geom_errorbar(aes(ymin=mean_all_folds_r2-sem_all_folds_r2, ymax=mean_all_folds_r2+sem_all_folds_r2, color=iv), position=position_dodge(width=0.9), width=0.1)+
  
  geom_bar(stat="identity", position = position_dodge(),aes(iv, mean_shuffle_r2,fill=iv, alpha=iv_data), fill=NA,color="black", linetype="dashed")+
  
  facet_wrap(~dv, scales='free_x')+
  theme(legend.title = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.text = element_text(size=22),
        strip.text = element_text(size=22),
        axis.title.y = element_text(size=22),
        axis.text.y= element_text(size=22),
        panel.grid = element_blank())+
  xlab("")+
  ylab(expression(R^{2}))+
  scale_alpha_manual(values = c(0.5, 1, 1))+
  guides(alpha=FALSE,
         fill=guide_legend(nrow=2, byrow=T))

ggsave(paste0('t1_pred.', out_device), device = out_device, path = fig_path, width = 24, height = 13, units = "in", dpi=250)
