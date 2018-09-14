cd /oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/output/batch_output
cat *rel_df_sample_size.csv > /oak/stanford/groups/russpold/users/zenkavi/SRO_DDM_Analyses/output/batch_output/rel_df_sample_size.csv
awk '!a[$0]++' rel_df_sample_size.csv > rel_df_sample_size_clean.csv
rm rel_df_sample_size.csv
mv rel_df_sample_size_clean.csv ./rel_df_sample_size.csv
gzip rel_df_sample_size.csv