#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_max_num_vars.R file_name min_num_vars max_num_vars num_reps out_path

data = read.csv(args[1])
min_num_vars = as.numeric(args[2])
max_num_vars = as.numeric(args[3])
num_reps = as.numeric(args[4])
out_path = args[5]

require(tidyverse)

get_sample_det = function(data, cur_num_vars){
  cur_vars = sample.int(ncol(data), cur_num_vars)
  cur_det = det(cor(data[,cur_vars]))
  out = data.frame(cur_num_vars = cur_num_vars, cur_vars = paste0(cur_vars, collapse=','), cur_det = cur_det)
  return(out)
}

# out = data.frame(comb = NA, comb_det = NA)
out = data.frame(cur_num_vars = NA, cur_vars = NA, cur_det = NA)

set.seed(308723857)

print('Begining loop for numbers of variables')
for(cur_num_vars in c(min_num_vars:max_num_vars)){

  # Going through all possible combinations would have been ideal but because there are so many of them it is not possible. Instead I'll use a sampling approach
  # print(paste0('Begining inner loop of variable combinations for num_vars: ', cur_num_vars))  
  # combos = combn(dim(data)[2], cur_num_vars)
  # for(i in c(1:dim(combos)[2])){
  #   cur_comb = combos[,i]
  #   cur_comb_det = det(cor(data[,cur_comb]))
  #   tmp = c(cur_comb, cur_comb_det)
  #   out = rbind(out, tmp)
  # }
  
  print(paste0('Beginning replication for ', cur_num_vars, ' variables'))
  tmp = data.frame(t(replicate(num_reps, get_sample_det(data, cur_num_vars), simplify = "matrix")))
  print('Done with replicate')
  out = rbind(out, tmp)
  
}

print('Done with loop for all number of variables')
print('Beginning output processing')

out = out[-1,]

out = out %>%
  mutate(cur_num_vars = unlist(out$cur_num_vars),
         cur_vars = unlist(out$cur_vars),
         cur_det = unlist(out$cur_det),
         cur_det_pos = ifelse(cur_det>0, 1, 0))

write.csv(out, paste0(out_path, 'max_num_vars.csv'), row.names = FALSE)
print('Wrote out raw output')

out_summary = out %>%
  group_by(cur_num_vars) %>%
  summarise(prop_det_pos = sum(cur_det_pos)/n())

write.csv(out_summary, paste0(out_path, 'max_num_vars_summary.csv'), row.names = FALSE)
print('Wrote out summary output')