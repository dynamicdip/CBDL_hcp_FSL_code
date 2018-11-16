# to extract ROIs from Desikan Killiany atlas

fMRI="$1" # WM_LR, REST1_LR

one_ROI ()
{
local i="$1"
fslmeants -i tfMRI_"$2".nii.gz -o TS_"$2"/meants_"$i".txt -m ~/hcp_data_codes/yeo_ROIs/nodes_"$i".nii.gz 
echo "$i"
}

# Yeo Attention Regions
yeo_rois ()
{
for i in `cat ~/hcp_data_codes/yeo_attention_regions.txt`
do
one_ROI "$i" "$1"
done
}

###### main code begins ######

# make folders
mkdir -p TS_"$fMRI"

# get ts for yeo rois
yeo_rois "$fMRI"

wait
