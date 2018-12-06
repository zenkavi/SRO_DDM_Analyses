library(tidyverse)
library(RCurl)

if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/figure_scripts/figure_res_wrapper.R', ssl.verifypeer = FALSE)))

plot_data = data.frame(x=c("old", "young", "old", "young"),
                       par = c("Threshold", "Threshold", "Non-decision", "Non-decision"),
                       y = c(0.184, 0.126, 0.548, 0.447))

plot_data %>%
  ggplot(aes(x, y, fill=par))+
  geom_bar(stat="identity", position = position_dodge())+
  ylab("")+
  xlab("")+
  theme(legend.title=element_blank(),
        axis.text = element_text(size=16),
        legend.text = element_text(size = 16))

ggsave('RatcliffEtAl2004.jpeg', path = fig_path, width = 5, height = 5, units = "in")
