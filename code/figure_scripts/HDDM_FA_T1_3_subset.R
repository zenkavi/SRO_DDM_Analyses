if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('hddm_t1_fa_3_subset')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/hddm_fa_data.R')
}


hddm_t1_fa_3_subset_loadings = as.data.frame(hddm_t1_fa_3_subset$loadings[])

hddm_t1_fa_3_subset_loadings[abs(hddm_t1_fa_3_subset_loadings)<0.3]=NA

tmp = hddm_t1_fa_3_subset_loadings %>%
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
        legend.title=element_blank())

ggsave(paste0('HDDM_FA_T1_3_subset.', out_device), plot=p, device = out_device, path = fig_path, width = 10, height = 12, units = "in")