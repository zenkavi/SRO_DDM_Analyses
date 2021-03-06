if(!exists('rel_df_fullfit') | !exists('rel_df_refit')){
  ddm_workspace_scripts = 'https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/'
  eval(parse(text = getURL(paste0(ddm_workspace_scripts,'ddm_point_rel_data.R'), ssl.verifypeer = FALSE))
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
