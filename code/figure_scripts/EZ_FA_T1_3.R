if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('ez_t1_fa_3')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ez_fa_data.R')
  }

ez_t1_fa_3 = fa(res_clean_test_data_ez, 3, rotate='oblimin', fm='minres', scores='tenBerge')

ez_t1_fa_3_loadings = as.data.frame(ez_t1_fa_3$loadings[])

ez_t1_fa_3_loadings[abs(ez_t1_fa_3_loadings)<0.3]=NA

tmp = ez_t1_fa_3_loadings %>%
  mutate(dv = row.names(.)) %>%
  select(dv, MR1, MR2, MR3) %>%
  mutate(num_loading = 3-(is.na(MR1)+is.na(MR2)+is.na(MR3) ) ) %>%
  filter(num_loading!=0) %>%
  select(-num_loading) %>%
  arrange(-MR1, -MR2, -MR3) %>%
  mutate(order_num = 1:n(),
         dv = reorder(dv, -order_num)) %>%
  select(-order_num) %>%
  gather(Factor, Loading, -dv) %>%
  na.exclude() %>%
  mutate(neg_load = factor(ifelse(Loading>0,"NA","#000000")),
         var_type = ifelse(grepl("drift", dv), "drif rate",
                           ifelse(grepl("thresh", dv), "threshold",
                                  ifelse(grepl("non_dec", dv), "non-decision", NA))))


p = tmp%>%         
  ggplot(aes(dv, abs(Loading), fill=var_type, col = neg_load))+
  geom_bar(stat = "identity", alpha=0.5)+
  facet_wrap(~Factor, nrow=1)+
  coord_flip()+
  xlab("")+
  ylab("Absolute Loading")+
  scale_fill_manual(values=cbbPalette)+
  scale_color_identity()+
  theme(legend.position = "bottom",
        legend.title=element_blank(),
        axis.text.y = element_blank())

ggsave(paste0('EZ_FA_T1_3.', out_device), plot=p, device = out_device, path = fig_path, width = 10, height = 12, units = "in")