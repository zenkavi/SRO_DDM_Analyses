input_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/SRO_DDM_Analyses/input/'

measure_labels <- read.csv(paste0(input_path, 'measure_labels.csv'))

measure_labels = measure_labels %>% 
  select(-measure_description) %>%
  filter(ddm_task == 1) %>%
  select(-ddm_task) %>%
  filter(rt_acc != "other") %>%
  mutate(dv = as.character(dv),
         overall_difference = factor(overall_difference,levels = c("overall", "difference", "condition"), labels = c("non-contrast", "contrast", "condition")),
         ddm_raw = ifelse(raw_fit == "raw", "raw", "ddm")) %>%
  separate(dv, c("task_group", "var"), sep = "\\.", remove=FALSE, extra = "merge")
