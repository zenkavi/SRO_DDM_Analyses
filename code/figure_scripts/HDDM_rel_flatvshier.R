library(RCurl)
library(tidyverse)
library(gridExtra)

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ddm_point_rel_data.R', ssl.verifypeer = FALSE)))
}


if(!exists('make_rel_df')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/make_rel_df.R', ssl.verifypeer = FALSE)))
}

if(!exists('rel_df_flat')){
  
  #Don't change until PR is merged
  # retest_data_path = https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/Retest_03-29-2018
  
  retest_data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/Retest_03-29-2018/'
  
  retest_hddm_flat = read.csv(paste0(retest_data_path,'retest_hddm_flat.csv'))
  
  retest_hddm_flat = retest_hddm_flat %>% rename(sub_id = subj_id)
  
  test_hddm_flat = read.csv(paste0(retest_data_path,'/t1_data/t1_hddm_flat.csv'))
  
  test_hddm_flat = test_hddm_flat %>% rename(sub_id = subj_id)
  
  common_cols = names(retest_hddm_flat)[names(retest_hddm_flat) %in% names(retest_data)]
  common_cols=common_cols[common_cols %in% names(test_hddm_flat)]
  
  retest_hddm_hier = retest_data %>% select(common_cols) %>% mutate(hddm="hierarchical")
  test_hddm_hier = test_data %>% select(common_cols)  %>% mutate(hddm="hierarchical")
  retest_hddm_flat = retest_hddm_flat %>% select(common_cols) %>% mutate(hddm="flat")
  test_hddm_flat = test_hddm_flat %>% select(common_cols) %>% mutate(hddm="flat")
 
  rel_df_flat = make_rel_df(t1_df = test_hddm_flat, t2_df = retest_hddm_flat, metrics = c('icc', 'pearson', 'var_breakdown'))
  
  rel_df_flat = rel_df_flat %>%
    left_join(rel_df[,c("dv", "icc", "rt_acc", "overall_difference")], by = "dv") 
}


rel_df_flat %>%
  mutate(rt_acc = factor(rt_acc, levels = c("drift rate", "threshold", "non-decision"), labels = c("Drift Rate", "Threshold", "Non-decision"))) %>%
  ggplot(aes(icc.y, icc.x))+
  geom_point()+
  geom_abline(aes(slope=1, intercept = 0), color="red")+
  facet_wrap(~rt_acc)+
  xlab("Hierarchical reliability")+
  ylab("Flat reliability")+
  theme(strip.text = element_text(size=16),
        axis.title= element_text(size=16),
        panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(), 
        aspect.ratio = 1)


ggsave(paste0('HDDM_rel_flatvshier.', out_device), device = out_device, path = fig_path, width = 9.5, height = 3.5, units = "in")
