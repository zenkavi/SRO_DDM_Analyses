library(RCurl)
library(tidyverse)
library(gridExtra)

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('retest_data')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ddm_subject_data.R', ssl.verifypeer = FALSE)))
}

if(!exists('flat_difference')){
  
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

p1 = flat_difference %>%
  mutate(time= factor(time, levels = c("test", "retest"),labels = c("Test", "Retest")),
         par = factor(par, levels = c("drift", "thresh", "non_decision"), labels = c("Drift Rate", "Threshold", "Non-decision")))%>%
  filter(par == "Drift Rate") %>%
  ggplot(aes(hierarchical, flat))+
  geom_point(aes(col=time), alpha=0.6)+
  geom_abline(aes(intercept=0, slope=1), color="black", linetype="dashed")+
  facet_wrap(~ par, scales='free')+
  theme(legend.title=element_blank(),
        strip.text = element_text(size=16),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_text(size=16),
        aspect.ratio = 1,
        legend.position="none", panel.grid = element_blank())+
  xlab("")+
  ylab("Flat estimate")+
  scale_x_continuous(breaks = c(-5, -2.5, 0, 2.5, 5),
                     limits = c(-5, 8))+
  scale_y_continuous(breaks = c(-5, -2.5, 0, 2.5, 5),
                     limits = c(-5, 8))

p2 = flat_difference %>%
  mutate(time= factor(time, levels = c("test", "retest"),labels = c("Test", "Retest")),
         par = factor(par, levels = c("drift", "thresh", "non_decision"), labels = c("Drift Rate", "Threshold", "Non-decision")))%>%
  filter(par == "Threshold") %>%
  ggplot(aes(hierarchical, flat))+
  geom_point(aes(col=time), alpha=0.6)+
  geom_abline(aes(intercept=0, slope=1), color="black", linetype="dashed")+
  facet_wrap(~ par)+
  theme(legend.title=element_blank(),
        strip.text = element_text(size=16),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_text(size=16),
        aspect.ratio = 1,
        #legend.text = element_text(size=16)
        legend.position = "none",
        panel.grid = element_blank())+
  xlab("Hierarchical estimate")+
  ylab("")+
  scale_x_continuous(breaks = c(-2.5, 0, 2.5, 5, 7.5),
                     limits = c(-2.5, 7.5))+
  scale_y_continuous(breaks = c(-2.5, 0, 2.5, 5, 7.5),
                     limits = c(-2.5, 7.5))

p3 = flat_difference %>%
  mutate(time= factor(time, levels = c("test", "retest"),labels = c("Test", "Retest")),
         par = factor(par, levels = c("drift", "thresh", "non_decision"), labels = c("Drift Rate", "Threshold", "Non-decision")))%>%
  filter(par == "Non-decision") %>%
  ggplot(aes(hierarchical, flat))+
  geom_point(aes(col=time), alpha=0.6)+
  geom_abline(aes(intercept=0, slope=1), color="black", linetype="dashed")+
  facet_wrap(~ par)+
  theme(legend.title=element_blank(),
        strip.text = element_text(size=16),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_text(size=16),
        aspect.ratio = 1,
        legend.position="none",
        panel.grid = element_blank())+
  xlab("")+
  ylab("")+
  scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75,1),
                     limits = c(0, 1))+
  scale_y_continuous(breaks = c(0, 0.25, 0.5, 0.75,1),
                     limits = c(0, 1))


ggsave(paste0('HDDM_par_flatvshier_dr.', out_device), plot = p1 ,device = out_device, path = fig_path, width = 4, height = 3, units = "in")
ggsave(paste0('HDDM_par_flatvshier_th.', out_device), plot = p2 ,device = out_device, path = fig_path, width = 3, height = 5, units = "in")
ggsave(paste0('HDDM_par_flatvshier_nd.', out_device), plot = p3 ,device = out_device, path = fig_path, width = 3, height = 3, units = "in")

# ggsave(paste0('HDDM_par_flatvshier.', out_device), device = out_device, path = fig_path, width = 14, height = 3, units = "in")
