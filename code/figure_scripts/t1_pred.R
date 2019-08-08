from_gh=FALSE
if(from_gh){
  library(RCurl)
}

if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

if(from_gh){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))
  
  helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
  
  eval(parse(text = getURL(paste0(helper_func_path,'sem.R'), ssl.verifypeer = FALSE)))
  
  input_path = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/input/'
  
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'), ssl.verifypeer = FALSE)))
  
} else{
  source('~/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')
  
  helper_func_path = '~/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/'
  
  source(paste0(helper_func_path,'sem.R'))
  
  input_path = '~/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/'
  
  ddm_workspace_scripts = '~/Dropbox/PoldrackLab//SRO_DDM_Analyses/code/workspace_scripts/'
  
  source(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'))
 }

t1_ez_fa_t1_demog = read.csv(paste0(input_path,'/ridge_prediction/ridge_fold_cors_ez_t1_522_fa_3_condition_scores_demog_fa_scores_t1.csv'))

t1_ez_mes_t1_demog = read.csv(paste0(input_path, '/ridge_prediction/ridge_fold_cors_res_clean_test_data_ez_522_demog_fa_scores_t1.csv'))

t1_raw_t1_demog = read.csv(paste0(input_path,'/ridge_prediction/ridge_fold_cors_res_clean_test_data_raw_522_demog_fa_scores_t1.csv'))


t1_ez_fa_t1_demog %>%
  rbind(t1_ez_mes_t1_demog) %>%
  rbind(t1_raw_t1_demog) %>%
  group_by(dv, iv) %>%
  summarise(mean_pred_cor = mean(r2),
            sem_pred_cor = sem(r2),
            mean_shuffle = mean(shuffle_mean)) %>%
  ungroup()%>%
  mutate(iv = factor(iv, levels = c("res_clean_test_data_raw_522", "res_clean_test_data_ez_522","ez_t1_522_fa_3_condition_scores"), labels = c("Raw RT and Acc", "EZ DVs", "EZ factor scores")),
         dv = gsub("_", " ", dv)) %>%
  ggplot(aes(x=dv))+
  geom_bar(stat="identity",aes( y=mean_pred_cor, fill=iv), position=position_dodge(width=.9))+
  geom_errorbar(aes(ymin=mean_pred_cor-sem_pred_cor, ymax=mean_pred_cor+sem_pred_cor, color=iv),position = position_dodge(width=0.9))+
   geom_bar(stat = "identity",aes( y=mean_shuffle, group=iv), fill=NA, position=position_dodge(width =.9), color="black", linetype=2)+
  geom_hline(aes(yintercept=0), linetype="dashed")+
  theme(panel.grid = element_blank(),
        legend.title = element_blank())+
  xlab("")+
  # ylab("Actual vs. predicted R across CV folds")+
  ylab(expression(paste("Actual vs. predicted ", R^{2},' across CV folds')))

ggsave(paste0('t1_pred.', out_device), device = out_device, path = fig_path, width = 11, height = 5, units = "in", dpi=img_dpi)

t1_ez_fa_t1_demog %>%
  rbind(t1_ez_mes_t1_demog) %>%
  rbind(t1_raw_t1_demog) %>%
  group_by(dv, iv) %>%
  summarise(mean_pred_cor = mean(pred_cor^2),
            sem_pred_cor = sem(pred_cor^2),
            mean_shuffle = mean(shuffle_95^2)) %>%
  mutate(iv = factor(iv, levels = c("res_clean_test_data_raw_522", "res_clean_test_data_ez_522","ez_t1_522_fa_3_condition_scores"), labels = c("Raw RT and Acc", "EZ DVs", "EZ factor scores"))) %>%
  ggplot(aes(x=dv))+
  geom_point(aes( y=mean_pred_cor, col=iv), position=position_dodge(width=.9))+
  geom_errorbar(aes(ymin=mean_pred_cor-sem_pred_cor, ymax=mean_pred_cor+sem_pred_cor, color=iv),position = position_dodge(width=0.9))+
  geom_point(aes( y=mean_shuffle, group=iv), fill=NA, position=position_dodge(width =.9), color="black", shape=8)+
  theme(panel.grid = element_blank(),
        legend.title = element_blank())+
  xlab("")+
  ylab("Actual vs. predicted R^2 across CV folds")