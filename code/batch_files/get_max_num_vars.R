#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Usage:
#Rscript --vanilla get_max_num_vars.R file_name min_num_vars max_num_vars out_path

data = read.csv(args[1])
min_num_vars = as.numeric(args[2])
max_num_vars = as.numeric(args[3])
out_path = args[4]

out = data.frame(comb = NA, comb_det = NA)

for(cur_num_vars in c(min_num_vars:max_num_vars)){
  
  combos = combn(ncol(data), cur_num_vars)
  
  for(i in c(1:dim(combos)[2])){
    cur_comb = combos[,i]
    cur_comb_det = det(cor(data[,cur_comb]))
    tmp = c(cur_comb, cur_comb_det)
    out = rbind(out, tmp)
  }
  
}

out = out[-1,]

write.csv(out, paste0(out_path, 'max_num_vars.csv'), row.names = FALSE)

