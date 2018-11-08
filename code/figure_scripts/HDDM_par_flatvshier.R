source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('flat_difference')){
  
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
  
  retest_flat_difference = rbind(retest_hddm_hier, retest_hddm_flat)
  retest_flat_difference = retest_flat_difference %>%
    gather(dv, value, -sub_id, -hddm) %>%
    spread(hddm, value) %>%
    mutate(diff_pct = (hierarchical - flat)/hierarchical*100,
           diff_pct = ifelse(diff_pct<(-100), -100, ifelse(diff_pct>100, 100, diff_pct)),
           time = "retest",
           par = ifelse(grepl("drift", dv), "drift", ifelse(grepl("thresh", dv), "thresh", ifelse(grepl("non_decision", dv), "non_decision", NA))))
  
  test_flat_difference = rbind(test_hddm_hier, test_hddm_flat)
  test_flat_difference = test_flat_difference %>%
    gather(dv, value, -sub_id, -hddm) %>%
    spread(hddm, value) %>%
    mutate(diff_pct = (hierarchical - flat)/hierarchical*100,
           diff_pct = ifelse(diff_pct<(-100), -100, ifelse(diff_pct>100, 100, diff_pct)),
           time = "test",
           par = ifelse(grepl("drift", dv), "drift", ifelse(grepl("thresh", dv), "thresh", ifelse(grepl("non_decision", dv), "non_decision", NA))))
  
  flat_difference = rbind(test_flat_difference, retest_flat_difference)

}

flat_difference %>%
  ggplot(aes(hierarchical, flat))+
  geom_point(aes(col=factor(time, levels = c("test", "retest"),labels = c("test", "retest"))), alpha=0.6)+
  geom_abline(aes(intercept=0, slope=1), color="black", linetype="dashed")+
  facet_wrap(~ par, scales='free')+
  theme(legend.title=element_blank(),
        legend.position = "none")+
  xlab("Hierarchical estimate")+
  ylab("Hierarchical reliability")

ggsave(paste0('HDDM_par_flatvshier.', out_device), device = out_device, path = fig_path, width = 14, height = 2.5, units = "in")
