#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla sample_size_rel.R test_data_file_name retest_data_file_name data_dir out_dir sample_sizes iterations dv

test_data_file_name <- args[1]
retest_data_file_name <- args[2] 
data_dir <- args[3]
out_dir  <- args[4]
sample_sizes <- args[5]
iterations <- eval(parse(text=args[6]))

#Set up environment
library(tidyverse)
library(psych)

helper_func_path = '...'

source(paste0(helper_func_path, 'match_t1_t2.R'))
source(paste0(helper_func_path, 'get_retest_stats.R'))

test_data_150 = read.csv(paste0(data_dir, test_data_file_name))
retest_data_150 = read.csv(paste0(data_dir, retest_data_file_name))

#set seed to reproduce results
set.seed(3987439)

#get list of dv's for which reliability will be calculated for
numeric_cols = get_numeric_cols()

#Create df of point estimate reliabilities
rel_df_cols = c('icc', 'var_subs', 'var_ind', 'var_resid', 'dv', 'sample_size', 'iteration')

rel_df_sample_size = as.data.frame(matrix(ncol = length(rel_df_cols)))

names(rel_df_sample_size) = rel_df_cols

make_samples = function(sample_sizes){
  
  for(ss in sample_sizes){
    
    assign(test_data_name, test_data, envir = .GlobalEnv )
    assign(retest_data_name, retest_data, envir = .GlobalEnv )
  }
}

#output of this should have 100*4*273 rows (109200)
for(it in 1:iterations) {
  
  make_samples(sample_sizes)
  
  #set samples
  test_data_125 = sample_n(test_data_150, 125)
  test_data_100 = sample_n(test_data_125, 100)
  test_data_75 = sample_n(test_data_100, 75)
  test_data_50 = sample_n(test_data_75, 50)
  test_data_25 = sample_n(test_data_50, 25)
  
  retest_data_125 = retest_data_150[retest_data_150$sub_id %in% test_data_125$sub_id,]
  retest_data_100 = retest_data_150[retest_data_150$sub_id %in% test_data_100$sub_id,]
  retest_data_75 = retest_data_150[retest_data_150$sub_id %in% test_data_75$sub_id,]
  retest_data_50 = retest_data_150[retest_data_150$sub_id %in% test_data_50$sub_id,]
  retest_data_25 = retest_data_150[retest_data_150$sub_id %in% test_data_25$sub_id,]
  
  for(ss in sample_sizes){
    #set test and retest data to df's of sample size that are being tested
    test_data  = get(paste0("test_data_", as.character(ss)))
    retest_data = get(paste0("retest_data_", as.character(ss)))
    
    for(var in 1:length(numeric_cols)){
      
      tmp = get_retest_stats(numeric_cols[var], metric = c('icc', 'var_breakdown'))
      tmp$dv = numeric_cols[var]
      tmp$sample_size = ss
      tmp$iteration = it
      
      if(it == 1 & var == 1){
        rel_df_sample_size = tmp
      }
      else{
        rel_df_sample_size = rbind(rel_df_sample_size, tmp)
      }
    } 
  }
}

write.csv(rel_df_sample_size, paste0(out_dir,dv,'_rel_df_sample_size.csv' ), row.names=FALSE)