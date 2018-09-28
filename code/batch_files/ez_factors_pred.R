library(caret)

input_path = '/oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/input/'

ez_pca_scores = read.csv(paste0(input_path, 'ez_factor_scores.csv'))
demog_fa_scores = read.csv(paste0(input_path, 'demog_fa_scores.csv'))

demog_factors = c("Obesity","Daily_Smoking","Problem_Drinking","Mental_Health","Drug_Use", "Lifetime_Smoking","Binge_Drinking","Unsafe_Drinking", "Income")
ez_factors = c("threshold","non_decision","drift_rate"  )

out = data.frame(dv=NA, iv=NA, Rsquared=NA, RsquaredSD=NA)

for(i in demog_factors){
  for(j in ez_vars){
    
    x = ez_oca_scores[,c("Age", "Sex", j)]
    y = demog_fa_scores[,i]
    
    model = train(x,y,
                  method="lm",
                  trControl = trainControl(method="cv", number=10),
                  na.action = na.exclude)
    
    tmp = data.frame(dv = i, iv = j, Rsquared = model$results$Rsquared, RsquaredSD = model$results$RsquaredSD) 
    
    out = rbind(out, tmp)
    
  }
}

write.csv(paste0(input_path, 'ez_factors_pred.csv'))