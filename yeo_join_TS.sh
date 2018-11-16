# to extract ROIs from Desikan Killiany atlas

fMRI="$1" # WM_LR, REST1_LR

cd ./TS_"$fMRI"

# make main TS file
touch TS_"$fMRI".txt

# Yeo Attention Regions
for i in `cat ~/hcp_data_codes/yeo_attention_regions.txt`
do
paste TS_"$fMRI".txt meants_"$i".txt > TS_"$fMRI"1.txt 
mv TS_"$fMRI"1.txt TS_"$fMRI".txt 
done

cd ..
