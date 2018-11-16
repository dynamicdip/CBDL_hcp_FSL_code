# to extract ROIs from Desikan Killiany atlas

one_ROI ()
{
local i="$1"
fslmaths aparc+aseg.nii.gz -thr "$i" -uthr "$i" ROIs/nodes_"$i".nii.gz
fslmaths ROIs/nodes_"$i".nii.gz -bin ROIs/nodes_"$i"_bin.nii.gz
flirt -interp nearestneighbour -in ROIs/nodes_"$i"_bin.nii.gz -ref ${FSLDIR}/data/standard/MNI152_T1_2mm -applyxfm -init ntof.mat -out ROIs/nodes_"$i".nii.gz
echo "`pwd`/ROIs/nodes_"$i".nii.gz" >> seeds.txt
rm ROIs/nodes_"$i"_bin.nii.gz
echo "$1"
}

# Left Hemi
left_hemi () 
{
for i in `seq 1000 1035`
do
one_ROI "$i" 
done
}

# Right Hemi
right_hemi ()
{
for i in `seq 2000 2035`
do
one_ROI "$i" 
done
}

# Subcortical Regions
sub_cort ()
{
for i in `cat ~/hcp_data_codes/subcortical_regions.txt`
do
one_ROI "$i"
done
}

probtrack_func ()
{
probtrackx2 --samples=Diffusion.bedpostX/merged \
--mask=Diffusion.bedpostX/nodif_brain_mask --seed=seeds.txt \
--xfm=xfms/standard2acpc_dc --invxfm=xfms/acpc_dc2standard \
--seedref=T1w_restore.2.nii.gz --loopcheck --forcedir --network --omatrix1 \
--nsamples=100 -V 1 --dir=Network
}

###### main code begins ######

cd /scratch/`whoami`/"$1"

# make folders
mkdir -p ROIs
touch seeds.txt 

# linear registration for resoltion change
flirt -in aparc+aseg.nii.gz -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -omat ntof.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp trilinear

# hemispheres and subcortical
left_hemi &
sub_cort &
right_hemi 

# probability tractography
probtrack_func

cd ~/hcp_data_codes
