#!/usr/bin/env Rscript
#Set up environment
library(tidyverse)
library(psych)
library(stringr)

args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla sample_size_rel.R test_data_file_name retest_data_file_name data_dir out_dir sample_sizes iterations dv

test_data_file_name <- args[1]
retest_data_file_name <- args[2] 
data_dir <- args[3]
out_dir  <- args[4]
# sample_sizes <- eval(parse(text=args[5]))
dv <- args[5]
iterations <- as.numeric(args[6])
sample_sizes <- as.numeric(unlist(str_split(args[7], ",")))

print(dv)
print(iterations)
print(sample_sizes)

helper_func_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/code/batch_files/'

print("Reading in helper functions...")

source(paste0(helper_func_path, 'match_t1_t2.R'))
source(paste0(helper_func_path, 'get_retest_stats_sherlock.R'))

print("Helper functions read in.")

#set seed to reproduce results
set.seed(3987439)

print("Seed set.")

#Create df of point estimate reliabilities
rel_df_cols = c('icc', 'var_subs', 'var_ind', 'var_resid', 'dv', 'sample_size', 'iteration')

rel_df_sample_size = as.data.frame(matrix(ncol = length(rel_df_cols)))

names(rel_df_sample_size) = rel_df_cols

print("Defining sample generation function...")

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

print("Starting reliability loop...")

#output of this should have iterations*length(sample_size) rows 
for(it in 1:iterations) {
  
  test_data = read.csv(paste0(data_dir, test_data_file_name))
  retest_data = read.csv(paste0(data_dir, retest_data_file_name))
  
  make_samples(sample_sizes)
  
  for(ss in sample_sizes){
    
    print(paste0(it,'_',ss))
    
    #set test and retest data to df's of sample size that are being tested
    test_data  = get(paste0("test_data_", as.character(ss)))
    retest_data = get(paste0("retest_data_", as.character(ss)))
    
    test_data_dv_level_len = length(unique(test_data$dv))
    retest_data_dv_level_len = length(unique(retest_data$dv))
    
    if(test_data_dv_level_len >=2 & retest_data_dv_level_len >= 2){
      tmp = get_retest_stats(dv, metric = c('icc', 'var_breakdown'))
    } else{
      print("DV levels <2")
      tmp = data.frame(icc = NA, var_subs = NA, var_ind = NA, var_resid = NA)
    }
    
    tmp$dv = dv
    tmp$sample_size = ss
    tmp$iteration = it
    
    rel_df_sample_size = rbind(rel_df_sample_size, tmp)
    
  }
}

print("Finished reliability loop.")

rel_df_sample_size = rel_df_sample_size[-which(is.na(rel_df_sample_size$dv)),]

print(paste0("Writing out rel_df_sample_size for ", dv))

write.csv(rel_df_sample_size, paste0(out_dir,dv,'_rel_df_sample_size.csv' ), row.names=FALSE)