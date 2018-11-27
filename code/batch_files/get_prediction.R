library(tidyverse)
library(caret)
library(RCurl)

args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_prediction.R {IV_DATA} {DV_DATA} {CV_FOLDS} {OUTPUT_PATH}

iv_data <- args[1]
dv_data <- args[2]
cv_folds <- as.numeric(args[3])

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))

if(iv_data %in% c('ez_t1_fa_3', 'ez_t2_fa_3', 'ez_t2_fa_3_pred', 'ez_t1_measures', 'ez_t2_measures')){
    eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))

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
}

if(iv_data %in% c('raw_t1_measures', 'raw_t2_measures')){
    eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/raw_rtacc_data.R', ssl.verifypeer = FALSE)))
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sro_predict.R', ssl.verifypeer = FALSE)))

demog_fa_scores = demog_fa_scores %>%
  filter(sub_id %in% ez_t1_fa_3_scores$sub_id)

demog_fa_scores[is.na(demog_fa_scores)]=0

out = sro_predict(get0(iv_data), get0(dv_data), cv_folds = cv_folds)
out$iv_data = iv_data
out$dv_data = dv_data

write.csv(..., paste0(output_path, '....csv'), row.names = F)
