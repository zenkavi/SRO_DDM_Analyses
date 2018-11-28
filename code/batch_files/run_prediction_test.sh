set -e
for iv_data in ez_t1_fa_3
do
  for dv_data in demog_fa_scores_t1
  do
    sed -e "s/{IV_DATA}/$iv_data/g"  -e "s/{DV_DATA}/$dv_data/g" -e "s/{CV_FOLDS}/10/g" -e "s/{OUTPUT_PATH}/\/oak\/stanford\/groups\/russpold\/users\/zenkavi\/SRO_DDM_Analyses\/output\/batch_output\//g" get_prediction.batch | sbatch -p russpold
  done
done
