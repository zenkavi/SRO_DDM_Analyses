library(caret)
library(RCurl)

eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/ez_fa_data.R', ssl.verifypeer = FALSE)))
eval(parse(text = getURL('https://raw.githubusercontent.com/zenkavi/SRO_DDM_Analyses/master/code/workspace_scripts/demog_fa_data.R', ssl.verifypeer = FALSE)))

ez_t1_fa_3 = fa(res_clean_test_data_ez, 3, rotate='oblimin', fm='minres', scores='Anderson')

ez_t1_fa_3_scores = as.data.frame(ez_t1_fa_3$scores)

ez_t1_fa_3_scores = ez_t1_fa_3_scores %>%
  mutate(sub_id = test_data$sub_id) %>%
  rename(drift_rate = MR1, threshold = MR2, non_decision = MR3) %>%
  select(sub_id, everything())

demog_fa_scores = demog_fa_scores %>%
  filter(sub_id %in% ez_t1_fa_3_scores$sub_id)

demog_fa_scores[is.na(demog_fa_scores)]=0

function(x_df, y_df){

  require(tidyverse)

  out = data.frame(dv=NA, iv=NA, Rsquared=NA, RsquaredSD=NA)

  x_s = names(x_df)[-which(names(x_df)=="sub_id")]
  y_s = names(y_df)[-which(names(y_df)=="sub_id")]

  for(i in x_s){
    for(j in y_s){

      x = x_df%>%select(j)
      y = y_df[,i]
      
      print(paste0('Running CV for y= ', i, ' and x= ', j))

      model = train(x,y,
                    method="lm",
                    trControl = trainControl(method="cv", number=10),
                    na.action = na.exclude)

      tmp = data.frame(dv = i, iv = j, Rsquared = model$results$Rsquared, RsquaredSD = model$results$RsquaredSD)

      out = rbind(out, tmp)

      print("Done with loop. Saving...")
    }

  out = out[-1,]
  return(out)
}

output_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/output
/batch_output/'

write.csv(out, paste0(output_path, 'ez_factors_pred.csv'), row.names = F)
