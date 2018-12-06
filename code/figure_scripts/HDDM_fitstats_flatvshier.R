library(RCurl)
library(tidyverse)
library(gridExtra)

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('t1_hierarchical_fitstats') | !exists('retest_hierarchical_fitstats') | !exists('t1_flat_fitstats') | !exists('retest_flat_fitstats')){
  
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_fitstat_data.R')
  
  t1_hierarchical_fitstats = t1_hierarchical_fitstats %>%
    filter(subj_id %in% retest_hierarchical_fitstats$subj_id)
  
  tmp = rbind(retest_hierarchical_fitstats, retest_flat_fitstats, t1_hierarchical_fitstats, t1_flat_fitstats) %>%
    select(m_kl, subj_id, task_name, sample) %>%
    separate(sample, c("time", "proc"), sep="_", remove=FALSE)
}

tmp %>%
  mutate(time = factor(time, levels = c("t1", "retest"), c("T1", "T2")),
         proc = factor(proc, levels = c("hierarchical", "flat"), labels = c("Hierarchical", "Flat"))) %>%
  # filter(time == "T1") %>%
  ggplot(aes(m_kl, fill=proc))+
  geom_density(alpha=0.5, color=NA)+
  # facet_wrap(~time)+
  theme(legend.title = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 16),
        axis.title.x = element_text(size=16), 
        legend.position = "right")+
  xlab("Mean KL divergence")+
  ylab("")+
  scale_alpha_manual(values = c())

ggsave(paste0('HDDM_fitstats_flatvshier.', out_device), device = out_device, path = fig_path, width = 9.5, height = 2, units = "in")
