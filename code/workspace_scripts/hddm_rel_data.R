if(!exists('rel_df_fullfit') | !exists('rel_df_refit')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_point_rel_data.R')
}

hddm_rels_fullfit = rel_df_fullfit %>%
  filter(dv %in% unique(refit_boot_df$dv)) %>%
  select(dv, icc)

hddm_rels_refit = rel_df_refit %>%
  filter(dv %in% unique(refit_boot_df$dv)) %>%
  select(dv, icc) 

hddm_rels = hddm_rels_fullfit %>%
  left_join(hddm_rels_refit, by = "dv") %>%
  rename(fullfit = icc.x, refit = icc.y) %>%
  left_join(measure_labels[,c("dv", "rt_acc")], by = "dv") %>%
  filter(rt_acc %in% c("rt", "accuracy") == FALSE)

rm(hddm_rels_fullfit, hddm_rels_refit)