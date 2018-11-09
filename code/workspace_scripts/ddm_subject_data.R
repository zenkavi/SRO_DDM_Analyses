if(!exists('retest_data_path')){
  retest_data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/Retest_03-29-2018/'
}

if(!exists('measure_labels')){
  source('/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/ddm_measure_labels.R')
}

### Load time 1 data

test_data_hddm_fullfit <- read.csv(paste0(retest_data_path,'t1_data/variables_exhaustive.csv'))

test_data_hddm_fullfit_subs = as.character(test_data_hddm_fullfit$X)

test_data_hddm_fullfit = test_data_hddm_fullfit %>%
  select(measure_labels$dv)

test_data_hddm_fullfit$sub_id = test_data_hddm_fullfit_subs

rm(test_data_hddm_fullfit_subs)

### Load time 2 data 

retest_data <- read.csv(paste0(retest_data_path,'variables_exhaustive.csv'))

retest_data_subs = as.character(retest_data$X)

retest_data = retest_data %>%
  select(measure_labels$dv)

retest_data$sub_id = retest_data_subs

retest_data = retest_data[retest_data$sub_id %in% test_data_hddm_fullfit$sub_id,]

rm(retest_data_subs)

### HDDM parameters in t1 data

hddm_refits <- read.csv(paste0(retest_data_path,'t1_data/hddm_refits_exhaustive.csv'))

tmp = names(test_data_hddm_fullfit)[names(test_data_hddm_fullfit) %in% names(hddm_refits) == FALSE]

hddm_refit_subs = as.character(hddm_refits$X)

hddm_refits = hddm_refits[, c(names(hddm_refits) %in% measure_labels$dv)]

hddm_refits$sub_id <- hddm_refit_subs

rm(hddm_refit_subs)

###RERAN MOTOR SS FOR REFIT (MISSING REACTIVE CONTROL HDDM DRIFT) - still missing; while missing the values from fitting to the full sample are used
# after correction this should just be sub_id
# Update 10/31: Seems might need to run with separate samples for all vars. To be explored later
#tmp

test_data_hddm_refit = test_data_hddm_fullfit %>%
  select(tmp)

#merge hddm refits to test data
test_data_hddm_refit = merge(test_data_hddm_refit, hddm_refits, by="sub_id")

rm(hddm_refits, tmp)

test_data = test_data_hddm_refit
