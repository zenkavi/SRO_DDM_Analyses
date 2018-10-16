fullfit_boot_df <- read.csv(gzfile(paste0(retest_data_path,'bootstrap_merged.csv.gz')), header=T)

fullfit_boot_df = process_boot_df(fullfit_boot_df)

fullfit_boot_df = fullfit_boot_df[fullfit_boot_df$dv %in% measure_labels$dv,]

refit_boot_df = read.csv(gzfile(paste0(retest_data_path,'refits_bootstrap_merged.csv.gz')), header=T)

refit_boot_df = process_boot_df(refit_boot_df)