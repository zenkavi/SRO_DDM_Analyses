library(RCurl)
library(tidyverse)
library(psych)

helper_func_path = 'https://raw.githubusercontent.com/zenkavi/SRO_Retest_Analyses/master/code/helper_functions/'
eval(parse(text = getURL(paste0(helper_func_path,'get_demographics.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helper_func_path,'residualize_baseline.R'), ssl.verifypeer = FALSE)))

data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/'
release = 'Complete_03-29-2018/'
dataset = 'demographic_health.csv'

demographics_t1 = get_demographics(dataset = paste0(data_path, release, dataset))

res_demographics_t1 = residualize_baseline(demographics_t1)

demog_fa_t1 = fa(res_demographics_t1, 9, rotate='oblimin', fm='ml', scores='tenBerge')

demog_fa_loadings_t1 = data.frame(demog_fa_t1$loadings[]) %>%
  mutate(dv = row.names(.)) %>%
  select(dv,everything()) %>%
  rename(Daily_Smoking=ML1,
         Lifetime_Smoking=ML2,
         Problem_Drinking=ML3,
         Mental_Health = ML4,
         Drug_Use = ML5,
         Obesity = ML6,
         Binge_Drinking=ML7,
         Unsafe_Drinking=ML8,
         Income_LifeMilestones=ML9)

demog_fa_scores_t1 = data.frame(demog_fa_t1$scores[]) %>%
  mutate(sub_id = demographics_t1$X) %>%
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

data_path = 'https://raw.githubusercontent.com/zenkavi/Self_Regulation_Ontology/master/Data/'
release = 'Retest_03-29-2018/'
dataset = 'demographic_health.csv'

demographics_t2 = get_demographics(dataset = paste0(data_path, release, dataset))

res_demographics_t2 = residualize_baseline(demographics_t2)
res_demographics_t2 = res_demographics_t2 %>% select(names(res_demographics_t2)[which(names(res_demographics_t2)%in%names(res_demographics_t1))])

demog_fa_scores_t2_pred = predict(demog_fa_t1, res_demographics_t2)

demog_fa_scores_t2_pred = data.frame(demog_fa_scores_t2_pred) %>%
  mutate(sub_id = demographics_t2$X,
         time = "T2") %>%
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

demog_fa_t2 = fa(res_demographics_t2, 4, rotate='oblimin', fm='ml', scores='tenBerge')

demog_fa_loadings_t2 = data.frame(demog_fa_t2$loadings[])
demog_fa_loadings_t2[abs(demog_fa_loadings_t2)<0.3] = NA
demog_fa_loadings_t2 = demog_fa_loadings_t2 %>%
  mutate(num_load = 4-(is.na(ML1)+is.na(ML2)+is.na(ML3)+is.na(ML4))) %>%
  filter(num_load>0)

demog_fa_loadings_t2 = demog_fa_loadings_t2 %>%
  mutate(dv = row.names(.)) %>%
  select(dv, everything()) %>%
  rename(Smoking = ML1,
         Mental_Health = ML2,
         Drug_Use = ML3,
         Alcohol_Use = ML4)