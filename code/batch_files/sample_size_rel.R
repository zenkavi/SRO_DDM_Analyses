#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla sample_size_rel.R test_data_file_name retest_data_file_name data_dir out_dir sample_sizes iterations dv

test_data_file_name <- args[1]
retest_data_file_name <- args[2] 
data_dir <- args[3]
out_dir  <- args[4]
sample_sizes <- eval(parse(text=args[5]))
iterations <- as.numeric(args[6])
dv <- args[7]

#Set up environment
library(tidyverse)
library(psych)

helper_func_path = '...'

source(paste0(helper_func_path, 'match_t1_t2.R'))
source(paste0(helper_func_path, 'get_retest_stats.R'))

test_data = read.csv(paste0(data_dir, test_data_file_name))
retest_data = read.csv(paste0(data_dir, retest_data_file_name))

#set seed to reproduce results
set.seed(3987439)

#get list of dv's for which reliability will be calculated for
numeric_cols = get_numeric_cols()

#Create df of point estimate reliabilities
rel_df_cols = c('icc', 'var_subs', 'var_ind', 'var_resid', 'dv', 'sample_size', 'iteration')

rel_df_sample_size = as.data.frame(matrix(ncol = length(rel_df_cols)))

names(rel_df_sample_size) = rel_df_cols

make_samples = function(sample_sizes){
  while(length(sample_sizes)>0){
    cur_sample_size = max(sample_sizes)
    
    test_data = sample_n(test_data, cur_sample_size)
    retest_data = retest_data[retest_data$sub_id %in% test_data$sub_id,]
    
    test_data_obj_name = paste0("test_data_", cur_sample_size)
    retest_data_obj_name = paste0("retest_data_", cur_sample_size)
    
    assign(test_data_obj_name, test_data, envir = .GlobalEnv )
    assign(retest_data_obj_name, retest_data, envir = .GlobalEnv )
    
    sample_sizes = sample_sizes[-which(sample_sizes == cur_sample_size)]
  }
}

#output of this should have iterations*length(sample_size) rows 
for(it in 1:iterations) {
  
  print(it)
  
  make_samples(sample_sizes)
  
  for(ss in sample_sizes){
    
    #set test and retest data to df's of sample size that are being tested
    test_data  = get(paste0("test_data_", as.character(ss)))
    retest_data = get(paste0("retest_data_", as.character(ss)))
    
    tmp = get_retest_stats(dv, metric = c('icc', 'var_breakdown'))
    tmp$dv = dv
    tmp$sample_size = ss
    tmp$iteration = it
    
    if(it == 1){
      rel_df_sample_size = tmp
    }
    else{
      rel_df_sample_size = rbind(rel_df_sample_size, tmp)
    }
    
  }
}

write.csv(rel_df_sample_size, paste0(out_dir,dv,'_rel_df_sample_size.csv' ), row.names=FALSE)