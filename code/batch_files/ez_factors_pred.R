library(caret)

input_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/input/'
output_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/output/batch_output/'

ez_pca_scores = read.csv(paste0(input_path, 'ez_pca_scores.csv'))
demog_fa_scores = read.csv(paste0(input_path, 'demog_fa_scores.csv'))

demog_factors = c("Obesity","Daily_Smoking","Problem_Drinking","Mental_Health","Drug_Use", "Lifetime_Smoking","Binge_Drinking","Unsafe_Drinking", "Income")
ez_factors = c("threshold","non_decision","drift_rate"  )

out = data.frame(dv=NA, iv=NA, Rsquared=NA, RsquaredSD=NA)

for(i in demog_factors){
  for(j in ez_factors){
    
    x = ez_pca_scores[,c("Age", "Sex", j)]
    y = demog_fa_scores[,i]
    
    print(paste0('Running CV for y= ', i, ' and x= ', j))
    
    model = train(x,y,
                  method="lm",
                  trControl = trainControl(method="cv", number=10),
                  na.action = na.exclude)
    
    tmp = data.frame(dv = i, iv = j, Rsquared = model$results$Rsquared, RsquaredSD = model$results$RsquaredSD) 
    
    out = rbind(out, tmp)
    
  }
}

print("Done with loop. Saving...")

write.csv(out, paste0(output_path, 'ez_factors_pred.csv'), row.names = F)