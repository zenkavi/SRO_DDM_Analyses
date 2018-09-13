while read dv; do
  sed "s/{DV}/$dv/g" sample_size_rel.batch | sbatch
done <numeric_cols_test.txt
