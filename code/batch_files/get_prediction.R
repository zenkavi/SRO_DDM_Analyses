from_gh=FALSE
if(from_gh){
  library(RCurl)
}

set.seed(2132129)

args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_prediction.R {IV_DATA} {DV_DATA} {CV_FOLDS} {OUTPUT_PATH}

if(length(args)>0){
  iv_data <- args[1]
  dv_data <- args[2]
  cv_folds <- as.numeric(args[3])
  method <- args[4]
  output_path <- args[5]
} else{
  iv_data = c("ez_t1_522_fa_3_condition_scores","res_clean_test_data_ez_522", "res_clean_test_data_raw_522")
  dv_data = "demog_fa_scores_t1"
  cv_folds = 10
  method = "ridge"
  output_path = "~/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/ridge_prediction/"
}

if(length(iv_data)>1){
  all_iv_data = iv_data
}

for(i in 1:length(all_iv_data)){
  iv_data = all_iv_data[i]
  
  if(iv_data %in% c('ez_t1_fa_3_scores', 'ez_t1_522_fa_3_scores', 'ez_t2_fa_3_scores', 'ez_t2_fa_3_pred_scores', 'ez_t2_522_fa_3_pred_scores', 'res_clean_test_data_ez', 'res_clean_retest_data_ez','res_clean_test_data_ez_522', 'res_clean_test_data_ez_nont2subs','ez_t1_522_fa_3_scores_t2subs', 'ez_t1_522_fa_3_scores_nont2subs','ez_t1_522_fa_3_condition_scores_t2subs', 'ez_t1_522_fa_3_condition_scores_nont2subs','ez_t1_522_fa_3_condition_scores')){
    
    if(from_gh){
      eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))
    } else{
      source("~/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ez_fa_data.R")
    }
    
    
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
    
    if(iv_data %in% c('ez_t1_522_fa_3_scores', 'ez_t2_522_fa_3_pred_scores', 'ez_t1_522_fa_3_scores_t2subs', 'ez_t1_522_fa_3_scores_nont2subs')){
      
      ez_t1_522_fa_3 = fa(res_clean_test_data_ez_522, 3, rotate='oblimin', fm='minres', scores='Anderson')
      
      ez_t1_522_fa_3_scores = as.data.frame(ez_t1_522_fa_3$scores)
      
      ez_t1_522_fa_3_scores = ez_t1_522_fa_3_scores %>%
        mutate(sub_id = test_data_522$sub_id) %>%
        rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
        select(sub_id, everything())
      
      ez_t1_522_fa_3_scores_t2subs = ez_t1_522_fa_3_scores %>%
        filter(sub_id %in% retest_data$sub_id)
      ez_t1_522_fa_3_scores_nont2subs = ez_t1_522_fa_3_scores %>%
        filter(sub_id %in% retest_data$sub_id == FALSE)
      
      ez_t2_522_fa_3_pred = predict(ez_t1_522_fa_3, res_clean_retest_data_ez)
      
      ez_t2_522_fa_3_pred_scores = data.frame(ez_t2_522_fa_3_pred) %>%
        mutate(sub_id = retest_data$sub_id) %>%
        rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
        select(sub_id, everything())
    }
    
    if(iv_data %in% c('ez_t1_522_fa_3_condition_scores', 'ez_t1_522_fa_3_condition_scores_t2subs', 'ez_t1_522_fa_3_condition_scores_nont2subs')){
      res_clean_test_data_ez_522_condition = res_clean_test_data_ez_522 %>%
        select((measure_labels %>%
                  filter(raw_fit == "EZ" & overall_difference == "condition"))$dv)
      
      ez_t1_522_fa_3_condition = fa(res_clean_test_data_ez_522_condition, 3, rotate='oblimin', fm='minres', scores='Anderson')
      
      ez_t1_522_fa_3_condition_scores = as.data.frame(ez_t1_522_fa_3_condition$scores)
      
      ez_t1_522_fa_3_condition_scores = ez_t1_522_fa_3_condition_scores %>%
        mutate(sub_id = test_data_522$sub_id) %>%
        rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
        select(sub_id, everything())
      
      ez_t1_522_fa_3_condition_scores_t2subs = ez_t1_522_fa_3_condition_scores %>%
        filter(sub_id %in% retest_data$sub_id)
      ez_t1_522_fa_3_condition_scores_nont2subs = ez_t1_522_fa_3_condition_scores %>%
        filter(sub_id %in% retest_data$sub_id == FALSE)
      
    }
    
    if(iv_data %in% c('ez_t2_fa_3_scores')){
      ez_t2_fa_3 = fa(res_clean_retest_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')
      
      ez_t2_fa_3_scores = as.data.frame(ez_t2_fa_3$scores)
      
      ez_t2_fa_3_scores = ez_t2_fa_3_scores %>%
        mutate(sub_id = test_data$sub_id) %>%
        rename(drift_rate = MR1, threshold = MR3, non_decision = MR2) %>%
        select(sub_id, everything())
    }
    
    if(iv_data %in% c('res_clean_test_data_ez', 'res_clean_retest_data_ez','res_clean_test_data_ez_522', 'res_clean_test_data_ez_nont2subs')){
      
      res_clean_test_data_ez = as.data.frame(apply(res_clean_test_data_ez, 2, as.vector))
      res_clean_retest_data_ez = as.data.frame(apply(res_clean_retest_data_ez, 2, as.vector))
      res_clean_test_data_ez_522 = as.data.frame(apply(res_clean_test_data_ez_522, 2, as.vector))
      res_clean_test_data_ez_nont2subs = as.data.frame(apply(res_clean_test_data_ez_nont2subs, 2, as.vector))
    }
    
  }
  
  if(iv_data %in% c('res_clean_test_data_raw', 'res_clean_retest_data_raw', 'res_clean_test_data_raw_522', 'res_clean_test_data_raw_nont2subs')){
    
    if(from_gh){
      eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/raw_rtacc_data.R', ssl.verifypeer = FALSE)))
    } else{
      source('~/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/raw_rtacc_data.R')
    }
    
    res_clean_test_data_raw = as.data.frame(apply(res_clean_test_data_raw, 2, as.vector))
    res_clean_retest_data_raw = as.data.frame(apply(res_clean_retest_data_raw, 2, as.vector))
    res_clean_test_data_raw_522 = as.data.frame(apply(res_clean_test_data_raw_522, 2, as.vector))
    res_clean_test_data_raw_nont2subs = as.data.frame(apply(res_clean_test_data_raw_nont2subs, 2, as.vector))
  }
  
  if(from_gh){
    eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))} else{
      source('~/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/demog_fa_data.R')
    }
  
  retest_workers = c('s005','s007','s009','s011','s012','s014','s015','s017','s026','s027','s028','s032','s034','s042','s049','s060','s062','s063','s065','s066','s071','s081','s082','s083','s084','s085','s086','s089','s091','s092','s093','s094','s097','s098','s103','s106','s108','s110','s111','s112','s121','s128','s129','s142','s145','s149','s161','s163','s165','s168','s170','s173','s179','s180','s182','s184','s187','s190','s192','s196','s198','s205','s206','s207','s209','s212','s216','s218','s226','s233','s237','s238','s244','s254','s259','s262','s265','s269','s273','s275','s277','s284','s285','s286','s291','s294','s295','s301','s305','s307','s313','s314','s326','s328','s329','s334','s336','s339','s346','s357','s359','s365','s368','s369','s372','s373','s374','s376','s380','s383','s384','s388','s391','s396','s397','s402','s403','s408','s409','s420','s421','s425','s427','s430','s441','s449','s451','s453','s456','s467','s469','s471','s473','s477','s481','s484','s489','s492','s495','s500','s501','s502','s504','s505','s507','s508','s509','s510','s551','s556')
  
  if(dv_data %in% c("ian_demog_scores", "demog_fa_scores_t1") & iv_data %in% c('ez_t1_fa_3_scores','ez_t2_fa_3_scores', 'ez_t2_fa_3_pred_scores', 'ez_t2_522_fa_3_scores', 'ez_t2_522_fa_3_pred_scores', 'res_clean_retest_data_raw', 'res_clean_retest_data_ez', 'res_clean_test_data_raw', 'res_clean_test_data_ez','ez_t1_522_fa_3_scores_t2subs', 'ez_t1_522_fa_3_condition_scores_t2subs')){
    ian_demog_scores = ian_demog_scores %>%
      filter(sub_id %in% retest_workers)
    
    demog_fa_scores_t1 = demog_fa_scores_t1 %>%
      filter(sub_id %in% retest_workers)
  }
  
  if(dv_data %in% c("ian_demog_scores", "demog_fa_scores_t1") & iv_data %in% c('ez_t1_522_fa_3_scores_nont2subs', 'ez_t1_522_fa_3_condition_scores_nont2subs', 'res_clean_test_data_ez_nont2subs', 'res_clean_test_data_raw_nont2subs')){
    ian_demog_scores = ian_demog_scores %>%
      filter(sub_id %in% retest_workers==FALSE)
    
    demog_fa_scores_t1 = demog_fa_scores_t1 %>%
      filter(sub_id %in% retest_workers==FALSE)
  }
  
  demog_fa_scores_t2 = demog_fa_scores_t2 %>%
    filter(sub_id %in% retest_workers)
  
  demog_fa_scores_t2_pred = demog_fa_scores_t2_pred %>%
    filter(sub_id %in% retest_workers)
  
  demog_fa_scores_t1[is.na(demog_fa_scores_t1)]=0
  demog_fa_scores_t2[is.na(demog_fa_scores_t2)]=0
  demog_fa_scores_t2_pred[is.na(demog_fa_scores_t2_pred)]=0
  
  if(method=="lm"){
    if(from_gh){
      eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sro_predict_lm.R', ssl.verifypeer = FALSE)))
    } else{
      source('~/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/sro_predict_lm.R') 
    }
    
    all_out = sro_predict(get0(iv_data), get0(dv_data), cv_folds = cv_folds, shuffle=TRUE)
    
    out = all_out$out
    out$iv_data = iv_data
    out$dv_data = dv_data
    
    write.csv(out, paste0(output_path, 'pred_out_', iv_data, '_', dv_data, '.csv'), row.names = F)
    fold_cors = all_out$fold_cors
    fold_cors$iv_data = iv_data
    fold_cors$dv_data = dv_data
    
    write.csv(fold_cors, paste0(output_path, 'pred_fold_cors_', iv_data, '_', dv_data, '.csv'), row.names = F)
    
  }else if(method == "ridge"){
    if(from_gh){
      eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/sro_predict_ridge.R', ssl.verifypeer = FALSE)))
    } else{
      source('~/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/helper_functions/sro_predict_ridge.R')
      
      all_out = sro_predict(x_df=get0(iv_data), x_var = iv_data, y_df = get0(dv_data), y_var = names(get0(dv_data))[-1])
      
      write.csv(all_out$out, paste0(output_path, 'ridge_coefs_', iv_data, '_', dv_data, '.csv'), row.names = F)
      write.csv(all_out$fold_cors, paste0(output_path, 'ridge_fold_cors_', iv_data, '_', dv_data, '.csv'), row.names = F)
    }
  }
}


