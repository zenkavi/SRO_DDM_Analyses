library(tidyverse)

retest_workspace_scripts = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_Retest_Analyses/code/workspace_scripts/'

ddm_workspace_scripts = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/code/workspace_scripts/'

source(paste0(ddm_workspace_scripts,'SRO_DDM_Analyses_Helper_Functions.R'))

test_data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/Complete_03-29-2018/'

retest_data_path = '/Users/zeynepenkavi/Documents/PoldrackLabLocal/Self_Regulation_Ontology/Data/Retest_03-29-2018/'

fig_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/output/figures/'

input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/'

source(paste0(ddm_workspace_scripts,'ddm_measure_labels.R'))

source(paste0(ddm_workspace_scripts,'ddm_subject_data.R'))

source(paste0(ddm_workspace_scripts,'ddm_boot_rel_data.R'))

source(paste0(ddm_workspace_scripts,'ddm_point_rel_data.R'))

source(paste0(ddm_workspace_scripts,'hddm_fitstat_data.R'))

