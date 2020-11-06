#!/bin/bash

#This script calculates GluCEST contrast measures within the SVS ROI (and ROI reward/non-reward subdivisions)

#######################################################################################################
## DEFINE PATHS ##

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path to processed structural data
cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
outputpath=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures 
#######################################################################################################
## SVS ROI CEST MEASURE EXTRACTION ##

#SVS ROI
touch $outputpath/GluCEST-SVSROI-Measures.csv
echo "Subject	SVSROI_CEST_mean	SVSROI_CEST_numvoxels	SVSROI_CEST_SD" >> $outputpath/GluCEST-SVSROI-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/svs_voxel/$case-2d-SVS-ROI.nii.gz  -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-SVSROI-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-SVSROI-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-SVSROI-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-SVSROI-GluCEST-measures.csv
sed -n "2p" $outputpath/$case/$case-SVSROI-GluCEST-measures.csv >> $outputpath/GluCEST-SVSROI-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_HMRS_Caselist_N25.txt

#SVS ROI: Reward Network 
touch $outputpath/GluCEST-SVSROI-RewardNetwork-Measures.csv
echo "Subject	SVSROI_Reward_CEST_mean	SVSROI_Reward_CEST_numvoxels	SVSROI_Reward_CEST_SD" >> $outputpath/GluCEST-SVSROI-RewardNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/svs_voxel/$case-2d-SVS-ROI-RewardAtlas.nii.gz  -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-SVSROI-RewardNetwork-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-SVSROI-RewardNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-SVSROI-RewardNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-SVSROI-RewardNetwork-GluCEST-measures.csv
sed -n "2p" $outputpath/$case/$case-SVSROI-RewardNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-SVSROI-RewardNetwork-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_HMRS_Caselist_N25.txt

#SVS ROI: Non-Reward
touch $outputpath/GluCEST-SVSROI-NonReward-Measures.csv
echo "Subject	SVSROI_NonReward_CEST_mean	SVSROI_NonReward_CEST_numvoxels	SVSROI_NonReward_CEST_SD" >> $outputpath/GluCEST-SVSROI-NonReward-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/svs_voxel/$case-2d-SVS-ROI-NonReward.nii.gz  -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-SVSROI-NonReward-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-SVSROI-NonReward-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-SVSROI-NonReward-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-SVSROI-NonReward-GluCEST-measures.csv
sed -n "2p" $outputpath/$case/$case-SVSROI-NonReward-GluCEST-measures.csv >> $outputpath/GluCEST-SVSROI-NonReward-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_HMRS_Caselist_N25.txt

