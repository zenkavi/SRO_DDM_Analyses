library(dplyr)
library(caret)
library(RCurl)

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sro_predict.R', ssl.verifypeer = FALSE)))

ez_t1_fa_3 = fa(res_clean_test_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t1_fa_3_scores = as.data.frame(ez_t1_fa_3$scores)

ez_t1_fa_3_scores = ez_t1_fa_3_scores %>%
  mutate(sub_id = test_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR2, non_decision = MR3) %>%
  select(sub_id, everything())

ez_t2_fa_3_pred = predict(ez_t1_fa_3, res_clean_retest_data_ez)

ez_t2_fa_3_pred_scores = data.frame(ez_t2_fa_3_pred) %>%
  mutate(sub_id = retest_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR2, non_decision = MR3) %>%
  select(sub_id, everything())

ez_t2_fa_3 = fa(res_clean_retest_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t2_fa_3_scores = as.data.frame(ez_t2_fa_3$scores)

ez_t2_fa_3_scores = ez_t2_fa_3_scores %>%
  mutate(sub_id = test_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR2, non_decision = MR3) %>%
  select(sub_id, everything())

demog_fa_scores = demog_fa_scores %>%
  filter(sub_id %in% ez_t1_fa_3_scores$sub_id)

demog_fa_scores[is.na(demog_fa_scores)]=0

ez_t1_factors_pred = sro_predict(ez_t1_fa_3_scores, demog_fa_scores)
ez_t1_factors_pred$model = "ez_t1_fa_3"

ez_t2_preds_pred = sro_predict(ez_t2_fa_3_pred_scores, demog_fa_scores)
ez_t2_preds_pred$model = "ez_t2_fa_3_pred"

ez_t2_factors_pred = sro_predict(ez_t2_fa_3_scores, demog_fa_scores)
ez_t2_factors_pred$model = "ez_t2_fa_3"

ez_t1_measures_pred = sro_predict(res_clean_test_data_ez, demog_fa_scores)
ez_t1_measures_pred$model = "ez_t1_measures"

ez_t2_measures_pred = sro_predict(res_clean_retest_data_ez, demog_fa_scores)
ez_t2_measures_pred$model = "ez_t2_measures"

ez_pred_out = rbind(ez_t1_factors_pred, ez_t2_preds_pred, ez_t2_factors_pred, ez_t1_measures_pred, ez_t1_measures_pred)

output_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/output
/batch_output/'

write.csv(ez_pred_out, paste0(output_path, 'ez_pred_out.csv'), row.names = F)
