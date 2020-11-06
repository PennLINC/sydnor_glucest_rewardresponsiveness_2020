#!/bin/bash

#This script calculates the volume of the HMRS VOI and percent of the HMRS VOI occupied by reward network versus non-reward cortex 

#######################################################################################################
## DEFINE PATHS ##

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path to processed structural data
cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
outputpath=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures 
#######################################################################################################

touch $outputpath/SVSROI-Coverage-MP2RAGEspace.csv
echo "Case	SVSROI_Total_MP2RAGEspace	RewardNetwork_Percent_MP2RAGEspace	NonReward_Percent_MP2RAGEspace" >> $outputpath/SVSROI-Coverage-MP2RAGEspace.csv

#######################################################################################################
while read line
do 
case=$line

total=$(fslstats $structural/$case/svs_voxel/${case}-SVS-ROI.nii.gz -V)
SVSVolume=${total#*\ }
fslmaths $structural/$case/svs_voxel/${case}-SVS-ROI.nii.gz -mul $structural/$case/atlases/$case-RewardAtlas-TotalNetwork.nii.gz $structural/$case/svs_voxel/${case}-SVS-ROI-RewardAtlas.nii.gz
reward=$(fslstats $structural/$case/svs_voxel/${case}-SVS-ROI-RewardAtlas.nii.gz -V)
RewardVolume=${reward#*\ }
fslmaths $structural/$case/svs_voxel/${case}-SVS-ROI.nii.gz -sub $structural/$case/svs_voxel/${case}-SVS-ROI-RewardAtlas.nii.gz $structural/$case/svs_voxel/${case}-SVS-ROI-NonReward.nii.gz
nonreward=$(fslstats $structural/$case/svs_voxel/${case}-SVS-ROI-NonReward.nii.gz -V)
NonRewardVolume=${nonreward#*\ }

rewardcoverage=$(echo "scale=5 ; $RewardVolume / $SVSVolume" | bc)
nonrewardcoverage=$(echo "scale=5 ; $NonRewardVolume / $SVSVolume" | bc)

echo "$case	$SVSVolume	$rewardcoverage	$nonrewardcoverage" >> $outputpath/SVSROI-Coverage-MP2RAGEspace.csv

done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_HMRS_Caselist_N25.txt
