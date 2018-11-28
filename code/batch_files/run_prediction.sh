set -e
for iv_data in ez_t1_fa_3_scores ez_t2_fa_3_scores ez_t2_fa_3_pred_scores res_clean_test_data_ez res_clean_retest_data_ez res_clean_test_data_raw res_clean_retest_data_raw
do
  for dv_data in demog_fa_scores_t1 demog_fa_scores_t2 demog_fa_scores_t2_pred
  do
    sed -e "s/{IV_DATA}/$iv_data/g"  -e "s/{DV_DATA}/$dv_data/g" -e "s/{CV_FOLDS}/10/g" -e "s/{OUTPUT_PATH}/\/oak\/stanford\/groups\/russpold\/users\/zenkavi\/SRO_DDM_Analyses\/output\/batch_output\//g" get_prediction.batch | sbatch -p russpold
  done
done
