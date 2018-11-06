process_fitstats = function(samples=c('t1_hierarchical', 't1_flat', 'refit_hierarchical','refit_flat', 'refit'), input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/hddm_fitstat/'){
  fitstats = data.frame()
  for(s in samples){
    file_path = paste0(input_path, s, "/")
      for(f in list.files(file_path)){
        tmp = read.csv(paste0(file_path, f), row.names=NULL)
        if(length(unique(tmp$subj_id)) == 1){
          tmp$subj_id = tmp$sub_id
          tmp = tmp[,-which(names(tmp)=="sub_id")]
        }
        num_samples = as.numeric(gsub('.*_([0-9]+).*','\\1',f))
        tmp$num_samples = ifelse(is.na(num_samples), 500, num_samples)
        tmp$task_name = gsub(paste0("_",s,".*$"), "", f)
        tmp$sample = s
        fitstats = rbind(fitstats, tmp)
      }
    }
  return(fitstats)
  }

#t1_flat_fitstats = process_fitstats(sample=c("t1_flat"))
t1_hierarchical_fitstats = process_fitstats(sample=c("t1_hierarchical"))

#retest_flat_fitstats = process_fitstats(sample=c("retest_flat"))
retest_hierarchical_fitstats = process_fitstats(sample=c("retest_hierarchical"))

refit_fitstats = process_fitstats(sample=c("refit"))