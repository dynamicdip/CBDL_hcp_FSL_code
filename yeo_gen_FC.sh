# get subject id
subjid="$1"

# collect files from aws server
bash ~/hcp_data_codes/script_data_FC.sh "$subjid"

# go to the folder
cd /scratch/`whoami`/"$subjid"/

# generate ROIs' BOLD timeseries
bash ~/hcp_data_codes/yeo_gen_fMRI.sh WM_LR
bash ~/hcp_data_codes/yeo_gen_fMRI.sh WM_RL

#wait

bash ~/hcp_data_codes/yeo_join_TS.sh WM_LR
bash ~/hcp_data_codes/yeo_join_TS.sh WM_RL

cp /scratch/`whoami`/"$subjid"/TS_WM_LR/TS_WM_LR.txt ~/HCP/WM_LR/"$subjid"_yeo.ts
cp /scratch/`whoami`/"$subjid"/TS_WM_RL/TS_WM_RL.txt ~/HCP/WM_RL/"$subjid"_yeo.ts

# come back!
cd ~/hcp_data_codes/

wait
