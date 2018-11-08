source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('rel_df_flat')){
  
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
  ggplot(aes(icc.y, icc.x))+
  geom_point()+
  geom_abline(aes(slope=1, intercept = 0), color="red")+
  facet_wrap(~rt_acc)+
  xlab("Hierarchical reliability")+
  ylab("Flat reliability")


ggsave(paste0('HDDM_rel_flatvshier.', out_device), device = out_device, path = fig_path, width = 14.5, height = 2.5, units = "in")
