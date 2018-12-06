if(!exists('fig_path')){
  fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'
}

source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/figure_scripts/figure_res_wrapper.R')

if(!exists('res_clean_test_data_ez_522_condition')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))
  }

res_clean_test_data_ez_522_condition = res_clean_test_data_ez_522 %>%
  select((measure_labels %>% 
            filter(raw_fit == "EZ" & overall_difference == "condition"))$dv)

ez_t1_522_fa_3_condition = fa(res_clean_test_data_ez_522_condition, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t1_522_fa_3_condition_loadings = as.data.frame(ez_t1_522_fa_3_condition$loadings[])

ez_t1_522_fa_3_condition_loadings[abs(ez_t1_522_fa_3_condition_loadings)<0.3]=NA

tmp = ez_t1_522_fa_3_condition_loadings %>%
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
         var_type = ifelse(grepl("drift", dv), "drift rate",
                           ifelse(grepl("thresh", dv), "threshold",
                                  ifelse(grepl("non_dec", dv), "non-decision", NA))))


tmp%>%         
  mutate(var_type  = factor(var_type, levels = c("drift rate", "threshold", "non-decision"), labels = c("Drift rate", "Threshold", "Non-decision")),
         Factor = factor(Factor, levels = c("MR1", "MR2", "MR3"), labels = c("Factor 1", "Factor 2", "Factor 3"))) %>%
  ggplot(aes(dv, abs(Loading), fill=var_type, col = neg_load))+
  geom_bar(stat = "identity", alpha=0.5)+
  facet_wrap(~Factor, nrow=1)+
  coord_flip()+
  xlab("")+
  ylab("Absolute Loading")+
  scale_fill_manual(values=cbbPalette)+
  scale_color_identity()+
  theme(legend.title=element_blank(),
        axis.text.y = element_blank(), 
        panel.grid = element_blank(),
        axis.ticks.y = element_blank(),
        legend.text = element_text(size=16),
        strip.text = element_text(size=16),
        axis.text = element_text(size=16), 
        axis.title = element_text(size=16))

ggsave(paste0('EZ_FA_Cond_T1_3.', out_device), device = out_device, path = fig_path, width = 10, height = 12, units = "in")
