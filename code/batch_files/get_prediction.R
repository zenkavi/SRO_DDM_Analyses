library(tidyverse)
library(caret)
library(RCurl)

set.seed(203872039)

args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_prediction.R {IV_DATA} {DV_DATA} {CV_FOLDS} {OUTPUT_PATH}

iv_data <- args[1]
dv_data <- args[2]
cv_folds <- as.numeric(args[3])
output_path <- args[4]

if(iv_data %in% c('ez_t1_fa_3_scores', 'ez_t1_522_fa_3_scores', 'ez_t2_fa_3_scores', 'ez_t2_fa_3_pred_scores', 'ez_t2_fa_522_3_pred_scores', 'res_clean_test_data_ez', 'res_clean_retest_data_ez')){
  
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))
  
  if(iv_data %in% c('ez_t1_fa_3_scores', 'ez_t2_fa_3_pred_scores')){
    
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
  }
  
  if(iv_data %in% c('ez_t1_fa_522_3_scores', 'ez_t2_fa_522_3_pred_scores')){
    
    ez_t1_522_fa_3 = fa(res_clean_test_data_ez_522, 3, rotate='oblimin', fm='minres', scores='Anderson')
    
    ez_t1_522_fa_3_scores = as.data.frame(ez_t1_522_fa_3$scores)
    
    ez_t1_522_fa_3_scores = ez_t1_522_fa_3_scores %>%
      mutate(sub_id = test_data_522$sub_id) %>%
      rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
      select(sub_id, everything()) 
    
    ez_t2_fa_522_3_pred = predict(ez_t1_522_fa_3, res_clean_retest_data_ez)
    
    ez_t2_fa_522_3_pred_scores = data.frame(ez_t2_fa_522_3_pred) %>%
      mutate(sub_id = retest_data$sub_id) %>%
      rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
      select(sub_id, everything())
  }

  if(iv_data %in% c('ez_t2_fa_3_scores')){
    ez_t2_fa_3 = fa(res_clean_retest_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')
    
    ez_t2_fa_3_scores = as.data.frame(ez_t2_fa_3$scores)
    
    ez_t2_fa_3_scores = ez_t2_fa_3_scores %>%
      mutate(sub_id = test_data$sub_id) %>%
      rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
      select(sub_id, everything())
  }
  
}

if(iv_data %in% c('res_clean_test_data_raw', 'res_clean_retest_data_raw')){
  eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/raw_rtacc_data.R', ssl.verifypeer = FALSE)))
}

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))

retest_workers = c('s005','s007','s009','s011','s012','s014','s015','s017','s026','s027','s028','s032','s034','s042','s049','s060','s062','s063','s065','s066','s071','s081','s082','s083','s084','s085','s086','s089','s091','s092','s093','s094','s097','s098','s103','s106','s108','s110','s111','s112','s121','s128','s129','s142','s145','s149','s161','s163','s165','s168','s170','s173','s179','s180','s182','s184','s187','s190','s192','s196','s198','s205','s206','s207','s209','s212','s216','s218','s226','s233','s237','s238','s244','s254','s259','s262','s265','s269','s273','s275','s277','s284','s285','s286','s291','s294','s295','s301','s305','s307','s313','s314','s326','s328','s329','s334','s336','s339','s346','s357','s359','s365','s368','s369','s372','s373','s374','s376','s380','s383','s384','s388','s391','s396','s397','s402','s403','s408','s409','s420','s421','s425','s427','s430','s441','s449','s451','s453','s456','s467','s469','s471','s473','s477','s481','s484','s489','s492','s495','s500','s501','s502','s504','s505','s507','s508','s509','s510','s551','s556')

if(dv_data %in% c("ian_demog_scores", "demog_fa_scores_t1") & iv_data %in% c('ez_t1_fa_3_scores','ez_t2_fa_3_scores', 'ez_t2_fa_3_pred_scores', 'ez_t2_522_fa_3_scores', 'ez_t2_522_fa_3_pred_scores', 'res_clean_retest_data_raw', 'res_clean_retest_data_ez')){
  ian_demog_scores = ian_demog_scores %>%
   filter(sub_id %in% retest_workers)
  
  demog_fa_scores_t1 = demog_fa_scores_t1 %>%
    filter(sub_id %in% retest_workers)
}

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
