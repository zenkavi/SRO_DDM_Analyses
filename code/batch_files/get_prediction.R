library(tidyverse)
library(caret)
library(RCurl)

args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_prediction.R {IV_DATA} {DV_DATA} {CV_FOLDS} {OUTPUT_PATH}

iv_data <- args[1]
dv_data <- args[2]
cv_folds <- as.numeric(args[3])
output_path <- args[4]

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

if(iv_data %in% c('res_clean_test_data_raw', 'res_clean_retest_data_raw')){
    eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/raw_rtacc_data.R', ssl.verifypeer = FALSE)))
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))

retest_workers = c('s198', 's409', 's473', 's286', 's017', 's092', 's403', 's103','s081', 's357', 's291', 's492', 's294', 's145', 's187', 's226','s368', 's425', 's094', 's430', 's376', 's284', 's421', 's034','s233', 's027', 's108', 's089', 's196', 's066', 's374', 's007','s509', 's365', 's305', 's453', 's504', 's161', 's441', 's205','s112', 's218', 's129', 's093', 's180', 's128', 's170', 's510','s502', 's477', 's551', 's307', 's556', 's121', 's237', 's481','s259', 's467', 's163', 's111', 's427', 's508', 's190', 's091','s207', 's484', 's449', 's049', 's336', 's212', 's142', 's313','s369', 's165', 's028', 's216', 's346', 's083', 's391', 's388','s384', 's275', 's442', 's505', 's098', 's456', 's209', 's372','s179', 's168', 's084', 's329', 's373', 's065', 's277', 's026','s011', 's063', 's507', 's005', 's495', 's501', 's032', 's326','s396', 's420', 's469', 's244', 's359', 's110', 's383', 's254','s060', 's339', 's380', 's471', 's206', 's182', 's500', 's314','s285', 's086', 's012', 's097', 's149', 's192', 's173', 's262','s273', 's402', 's015', 's014', 's085', 's489', 's071', 's062','s042', 's009', 's408', 's184', 's106', 's397', 's451', 's269','s295', 's265', 's301', 's082', 's238', 's328', 's334')

demog_fa_scores_t1 = demog_fa_scores_t1 %>%
  filter(sub_id %in% retest_workers)

demog_fa_scores_t2 = demog_fa_scores_t2 %>%
  filter(sub_id %in% retest_workers)

 demog_fa_scores_t2_pred = demog_fa_scores_t2_pred %>%
   filter(sub_id %in% retest_workers)

demog_fa_scores_t1[is.na(demog_fa_scores_t1)]=0
demog_fa_scores_t2[is.na(demog_fa_scores_t2)]=0
demog_fa_scores_t2_pred[is.na(demog_fa_scores_t2_pred)]=0

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sro_predict.R', ssl.verifypeer = FALSE)))

out = sro_predict(get0(iv_data), get0(dv_data), cv_folds = cv_folds)
out$iv_data = iv_data
out$dv_data = dv_data

write.csv(out, paste0(output_path, 'pred_out_', iv_data, '_', dv_data, '.csv'), row.names = F)
