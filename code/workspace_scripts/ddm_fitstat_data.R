process_fitstats = function(samples=c('t1_hierarchical', 't1_flat', 'refit_hierarchical','refit_flat', 'refit'), input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/hddm_fitstat/'){
  fitstats = data.frame()
  for(s in samples){
    file_path = paste0(input_path, s, "/")
      for(f in list.files(file_path, pattern="fitstats_summary")){
        tmp = read.csv(paste0(file_path, f), row.names=NULL)
        if(length(unique(tmp$subj_id)) == 1){
          tmp$subj_id = tmp$sub_id
          tmp = tmp[,-which(names(tmp)=="sub_id")]
        }
        num_samples = unlist(regmatches(f, gregexpr("[[:digit:]]+", f)))
        num_samples = ifelse(length(num_samples)>1, num_samples[-1], 
                             ifelse(is.na(num_samples), '500', num_samples))
        tmp$num_samples = ifelse(is.na(num_samples), '500', num_samples)
        tmp$task_name = gsub(paste0("_",s,".*$"), "", f)
        tmp$sample = s
        tmp = tmp %>% select('m_kl', 'm_int_pval', 'm_int_val', 'm_log_int_pval', 'm_log_int_val', 'm_log_rsq', 'm_log_rsq_adj', 'm_log_slope_pval', 'm_log_slope_val', 'm_rsq', 'm_rsq_adj', 'm_slope_pval','m_slope_val', 'sem_kl', 'sem_int_pval', 'sem_int_val', 'sem_log_int_pval', 'sem_log_int_val', 'sem_log_rsq', 'sem_log_rsq_adj', 'sem_log_slope_pval', 'sem_log_slope_val', 'sem_rsq', 'sem_rsq_adj', 'sem_slope_pval','sem_slope_val', 'subj_id', 'num_samples', 'task_name', 'sample')
        fitstats = rbind(fitstats, tmp)
      }
    }
  return(fitstats)
  }

t1_flat_fitstats = process_fitstats(sample=c("t1_flat"))
t1_hierarchical_fitstats = process_fitstats(sample=c("t1_hierarchical"))

retest_flat_fitstats = process_fitstats(sample=c("retest_flat"))
retest_hierarchical_fitstats = process_fitstats(sample=c("retest_hierarchical"))

refit_fitstats = process_fitstats(sample=c("refit"))
