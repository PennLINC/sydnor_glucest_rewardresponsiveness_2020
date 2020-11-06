#!/bin/bash

#This script calculates the volume of the HMRS VOI that is present within the GlUCEST FOV, and percent of the HMRS VOI in GluCEST space that is occupied by reward network versus non-reward cortex 

#######################################################################################################
## DEFINE PATHS ##

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path to processed structural data
cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
outputpath=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures 
#######################################################################################################

touch $outputpath/SVSROI-Coverage-CESTspace.csv
echo "Case	SVSROI_Volume_CESTspace	RewardNetwork_Percent_CESTspace	NonReward_Percent_CESTspace" >> $outputpath/SVSROI-Coverage-CESTspace.csv

#######################################################################################################
## ALIGN SVS ROI TO GLUCEST IMAGES ##

while read line
do 
case=$line
3dresample -inset $structural/$case/svs_voxel/${case}_dacc_svs_mask.nii -master $structural/$case/$case-UNI-masked.nii.gz -prefix $structural/$case/svs_voxel/${case}-SVS-ROI.nii.gz
mkdir $cest/$case/svs_voxel
/home/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/svs_voxel/${case}-SVS-ROI.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii
gzip $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii
#######################################################################################################
## CALCULATE REWARD AND NON-REWARD NETWORK PERCENT COVERAGE IN SVS ROI ##

fslmaths $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii.gz -mul $cest/$case/atlases/$case-2d-RewardAtlas-TotalNetwork.nii.gz  $cest/$case/svs_voxel/$case-2d-SVS-ROI-RewardAtlas.nii.gz #reward SVS ROI voxels
fslmaths $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii.gz -sub $cest/$case/svs_voxel/$case-2d-SVS-ROI-RewardAtlas.nii.gz $cest/$case/svs_voxel/$case-2d-SVS-ROI-NonReward.nii.gz #non-reward SVS ROI voxels

total=$(fslstats $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii.gz -V)
SVSVolume=${total#*\ }
reward=$(fslstats $cest/$case/svs_voxel/$case-2d-SVS-ROI-RewardAtlas.nii.gz -V)
RewardVolume=${reward#*\ }
nonreward=$(fslstats $cest/$case/svs_voxel/$case-2d-SVS-ROI-NonReward.nii.gz -V)
NonRewardVolume=${nonreward#*\ }

rewardcoverage=$(echo "scale=5 ; $RewardVolume / $SVSVolume" | bc)
nonrewardcoverage=$(echo "scale=5 ; $NonRewardVolume / $SVSVolume" | bc)
#######################################################################################################

echo "${case}	$SVSVolume	$rewardcoverage	$nonrewardcoverage" >> $outputpath/SVSROI-Coverage-CESTspace.csv 

done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_HMRS_Caselist_N25.txt
