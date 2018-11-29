library(tidyverse)
library(RCurl)

if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

if(!exists('all_data_cor')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/var_cor_data.R', ssl.verifypeer = FALSE)))
  }

all_data_cor %>%
  filter(!is.na(ddm_ddm)) %>%
  ggplot(aes(abs(value), fill=model))+
  geom_histogram(position = "identity", alpha=0.5)+
  geom_vline(data=all_data_cor_med, aes(xintercept=median_abs_cor, color=model), linetype = "dashed", size=1)+
  facet_grid(task_task~ddm_ddm, scales = 'free_y')+
  xlab("Absolute correlation")+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        strip.text = element_text(size=16),
        axis.title.x = element_text(size=16))+
  ylab('')

ggsave(paste0('ddm_raw_vars_cor.', out_device), device = out_device, path = fig_path, width = 14, height = 5, units = "in")
