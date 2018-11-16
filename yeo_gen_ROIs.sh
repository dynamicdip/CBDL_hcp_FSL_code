# to extract ROIs from Desikan Killiany atlas

one_ROI ()
{
local i="$1"
fslmaths yeo_parcels_MNI_2mm.nii -thr "$i" -uthr "$i" yeo_ROIs/nodes_"$i".nii.gz
fslmaths yeo_ROIs/nodes_"$i".nii.gz -bin yeo_ROIs/nodes_"$i"_bin.nii.gz
flirt -interp nearestneighbour -in yeo_ROIs/nodes_"$i"_bin.nii.gz -ref ${FSLDIR}/data/standard/MNI152_T1_2mm -applyxfm -init ntof.mat -out yeo_ROIs/nodes_"$i".nii.gz
rm yeo_ROIs/nodes_"$i"_bin.nii.gz
echo "$1"
}

# Yeo Attention Regions
yeo_rois ()
{
for i in `cat ~/hcp_data_codes/yeo_attention_regions.txt`
do
one_ROI "$i"
done
}

###### main code begins ######

# get the transformation matrix
flirt -in yeo_parcels_MNI_2mm.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -omat ntof.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp trilinear

# make folders
mkdir -p yeo_ROIs

# make yeo attn rois
yeo_rois

wait
