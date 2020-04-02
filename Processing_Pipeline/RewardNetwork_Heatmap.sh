#!/bin/bash

#This script creates the reward network coverage heatmap used to identify network voxels wherein greater than 50% of participants had GluCEST data.
#RewardNetwork-Heatmap-50%.nii.gz was used for the coverage sensitivity analysis.

#######################################################################################################
## DEFINE PATHS #

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path to processed structural data
cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
reward_dir=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural/MNI_Templates/Reward_Atlas/2D_RewardNetworks_inMNI
#######################################################################################################
## TRANSFORM 5mm REWARD NETWORK SLICES BACK TO MNI SPACE ##

while read line
do
case=$line
antsApplyTransforms -d 3 -i $cest/$case/atlases/$case-2d-RewardAtlas-TotalNetwork.nii.gz -r $structural/MNI_Templates/MNI/MNI152_T1_0.8mm_brain.nii.gz -n NearestNeighbor -o $structural/MNI_Templates/Reward_Atlas/2D_RewardNetworks_inMNI/$case-2d-RewardAtlas-inMNI.nii.gz -t $structural/$case/MNI_transforms/$case-UNIinMNI-1Warp.nii.gz -t $structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt
#######################################################################################################
## CREATE REWARD NETWORK HEATMAP ## 

firstcase=$(ls ${reward_dir} | head -1) 
othercases=$(ls ${reward_dir} | tail -n+2)

for casefile in ${othercases}; do
	echo -n "-add " >> ${reward_dir}/fslmaths_inputs.txt
	echo -n "$reward_dir/${casefile} " >> ${reward_dir}/fslmaths_inputs.txt
done

fslmaths $reward_dir/$firstcase $(cat ${reward_dir}/fslmaths_inputs.txt) $reward_dir/RewardNetwork-Heatmap.nii.gz
rm ${reward_dir}/fslmaths_inputs.txt
#######################################################################################################
## CREATE 50% OVERLAP REWARD ATLAS ##

#threshold heatmap at >50% of participants
fslmaths $reward_dir/RewardNetwork-Heatmap.nii.gz -thr 23 $reward_dir/RewardNetwork-Heatmap-50%.nii.gz
fslmaths $reward_dir/RewardNetwork-Heatmap-50%.nii.gz -bin $reward_dir/RewardNetwork-Heatmap-50%.nii.gz

#transform RewardNetwork-Heatmap-50%.nii.gz to GluCEST space
while read line
do
case=$line
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $reward_dir/RewardNetwork-Heatmap-50%.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-RewardAtlas-50%Heatmap.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/home/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-RewardAtlas-50%Heatmap.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-RewardAtlas-50%Heatmap.nii 
gzip $cest/$case/atlases/$case-2d-RewardAtlas-50%Heatmap.nii
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt