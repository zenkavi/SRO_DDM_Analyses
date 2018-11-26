library(RCurl)
library(tidyverse)
library(psych)

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
eval(parse(text = getURL(paste0(helper_func_path,'get_demographics.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'residualize_baseline.R'), ssl.verifypeer = FALSE)))

data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/'
release = 'Complete_03-29-2018/'
dataset = 'demographic_health.csv'

demographics = get_demographics(dataset = paste0(data_path, release, dataset))

res_demographics = residualize_baseline(demographics)

demog_fa = fa(res_demographics, demog_comp_metrics$comp[1], rotate='oblimin', fm='ml', scores='tenBerge')

demog_fa_scores = data.frame(demog_fa$scores[]) %>%
  mutate(sub_id = demographics$X) %>%
  select(sub_id,everything()) %>%
  rename(Daily_Smoking=ML1,
         Lifetime_Smoking=ML2,
         Problem_Drinking=ML3,
         Mental_Health = ML4,
         Drug_Use = ML5,
         Obesity = ML6,
         Binge_Drinking=ML7,
         Unsafe_Drinking=ML8,
         Income_LifeMilestones=ML9)