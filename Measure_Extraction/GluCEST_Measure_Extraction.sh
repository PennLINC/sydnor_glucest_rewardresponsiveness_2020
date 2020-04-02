#!/bin/bash

#This script calculates GluCEST contrast and gray matter density measures

#######################################################################################################
## DEFINE PATHS ##

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path to processed structural data
cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
outputpath=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures 

while read line
do
case=$line
mkdir $outputpath/$case
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt
#######################################################################################################
## REWARD NETWORK MEASURE EXTRACTION ##

#Reward Network (Figure 2A): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-Measures.csv
echo "Subject	RewardNetwork_CEST_mean	RewardNetwork_CEST_numvoxels	RewardNetwork_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network (Figure 2A): Gray Matter Density
touch $outputpath/GMDensity-RewardNetwork-Measures.csv
echo "Subject	RewardNetwork_GMDensity_mean	RewardNetwork_GMDensity_numvoxels	RewardNetwork_GMDensity_SD" >> $outputpath/GMDensity-RewardNetwork-Measures.csv
while read line
do
case=$line
#quantify GM density for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-RewardNetwork-GMDensity-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-GMDensity-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-GMDensity-measures.csv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-RewardNetwork-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network: Cortical Component (Figure 3A): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-Cortical-Measures.csv
echo "Subject	RewardNetwork_Cortical_CEST_mean	RewardNetwork_Cortical_CEST_numvoxels	RewardNetwork_Cortical_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-Cortical-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-Cortical.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-Cortical-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-Cortical-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-Cortical-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-Cortical-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-Cortical-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-Cortical-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network: Subcortical Component (Figure 3A): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-Subcortical-Measures.csv
echo "Subject	RewardNetwork_Subcortical_CEST_mean	RewardNetwork_Subcortical_CEST_numvoxels	RewardNetwork_Subcortical_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-Subcortical-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-SubCortical.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-Subcortical-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-Subcortical-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-Subcortical-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-Subcortical-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-Subcortical-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-Subcortical-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network: Salience Component (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-Salience-Measures.csv
echo "Subject	RewardNetworkC_CEST_mean RewardNetworkC_CEST_numvoxels	RewardNetworkC_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-Salience-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-posandneg-3C.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-posnegC-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-posnegC-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-posnegC-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-posnegC-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-posnegC-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-Salience-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network: Appetitive Component (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-PositiveOnly-Measures.csv
echo "Subject	RewardNetwork_Positive_CEST_mean	RewardNetwork_Positive_CEST_numvoxels	RewardNetwork_Positive_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-PositiveOnly-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-positiveonly-AminusC.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-PositiveOnly-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-PositiveOnly-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-PositiveOnly-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-PositiveOnly-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-PositiveOnly-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-PositiveOnly-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network: Aversive Component (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-NegativeOnly-Measures.csv
echo "Subject	RewardNetwork_Negative_CEST_mean	RewardNetwork_Negative_CEST_numvoxels	RewardNetwork_Negative_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-NegativeOnly-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-negativeonly-BminusC.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-NegativeOnly-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-NegativeOnly-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-NegativeOnly-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-NegativeOnly-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-NegativeOnly-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-NegativeOnly-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
touch $outputpath/GluCEST-RewardNetwork-Heatmap50-Measures.csv
echo "Subject	RewardNetwork_50_CEST_mean	RewardNetwork_50_CEST_numvoxels	RewardNetwork_50_CEST_SD" >> $outputpath/GluCEST-RewardNetwork-Heatmap50-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-50%Heatmap.nii.gz  -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-RewardNetwork-Heatmap50-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-RewardNetwork-Heatmap50-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-RewardNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-RewardNetwork-Heatmap50-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-RewardNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/GluCEST-RewardNetwork-Heatmap50-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt
#######################################################################################################
## NON-REWARD MEASURE EXTRACTION ##

#Non-Reward Brain Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-NonReward-Measures.csv
echo "Subject	NonReward_CEST_mean	NonReward_CEST_numvoxels	NonReward_CEST_SD" >> $outputpath/GluCEST-NonReward-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-NonReward-Cortical.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-NonReward-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-NonReward-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-NonReward-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-NonReward-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-NonReward-GluCEST-measures.csv >> $outputpath/GluCEST-NonReward-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt
#######################################################################################################
## REWARD NETWORK HARVARD OXFORD ANATOMICAL SUBREGIONS MEASURE EXTRACTION ##

#delineate cortical reward network anatomical regions with HO cortical atlas
while read line
do
case=$line
fslmaths $cest/$case/atlases/$case-2d-RewardAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz $cest/$case/atlases/$case-2d-RewardAtlas-HO-CorticalRegions.nii.gz
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network Harvard Oxford Cortical Regions (Supplementary Figure S1): GluCEST Contrast
touch $outputpath/GluCEST-HarvardOxford-Cortical-Reward-Measures.csv
echo "Subject	Frontal_Pole_mean	Frontal_Pole_numvoxels	Frontal_Pole_SD	Insular_Cortex_mean	Insular_Cortex_numvoxels	Insular_Cortex_SD	SFG_mean	SFG_numvoxels	SFG_SD	MFG_mean	MFG_numvoxels	MFG_SD	IFG_parstriangularis_mean	IFG_parstriangularis_numvoxels	IFG_parstriangularis_SD	IFG_parsopercularis_mean	IFG_parsopercularis_numvoxels	IFG_parsopercularis_SD	Precentral_Gyrus_mean	Precentral_Gyrus_numvoxels	Precentral_Gyrus_SD	Temporal_Pole_mean	Temporal_Pole_numvoxels	Temporal_Pole_SD	Superior_Temporal_Gyrus_ant_mean	Superior_Temporal_Gyrus_ant_numvoxels	Superior_Temporal_Gyrus_ant_SD	Superior_Temporal_Gyrus_post_mean	Superior_Temporal_Gyrus_post_numvoxels	Superior_Temporal_Gyrus_post_SD	Middle_Temporal_Gyrus_ant_mean	Middle_Temporal_Gyrus_ant_numvoxels	Middle_Temporal_Gyrus_ant_SD	Middle_Temporal_Gyrus_post_mean	Middle_Temporal_Gyrus_post_numvoxels	Middle_Temporal_Gyrus_post_SD	Middle_Temporal_Gyrus_temporoocc_mean	Middle_Temporal_Gyrus_temporoocc_numvoxels	Middle_Temporal_Gyrus_temporoocc_SD	Inferior_Temporal_Gyrus_ant_mean	Inferior_Temporal_Gyrus_ant_numvoxels	Inferior_Temporal_Gyrus_ant_SD	Inferior_Temporal_Gyrus_post_mean	Inferior_Temporal_Gyrus_post_numvoxels	Inferior_Temporal_Gyrus_post_SD	Inferior_Temporal_Gyrus_temporocc_mean	Inferior_Temporal_Gyrus_temporocc_numvoxels	Inferior_Temporal_Gyrus_temporocc_SD	Postcentral_Gyrus_mean	Postcentral_Gyrus_numvoxels	Postcentral_Gyrus_SD	Superior_Parietal_Lobule_mean	Superior_Parietal_Lobule_numvoxels	Superior_Parietal_Lobule_SD	Supramarginal_Gyrus_ant_mean	Supramarginal_Gyrus_ant_numvoxels	Supramarginal_Gyrus_ant_SD	Supramarginal_Gyrus_post_mean	Supramarginal_Gyrus_post_numvoxels	Supramarginal_Gyrus_post_SD	Angular_Gyrus_mean	Angular_Gyrus_numvoxels	Angular_Gyrus_SD	Lateral_Occipital_Cortex_sup_mean	Lateral_Occipital_Cortex_sup_numvoxels	Lateral_Occipital_Cortex_sup_SD	Lateral_Occipital_Cortex_inf_mean	Lateral_Occipital_Cortex_inf_numvoxels	Lateral_Occipital_Cortex_inf_SD	Intracalcarine_Cortex_mean	Intracalcarine_Cortex_numvoxels	Intracalcarine_Cortex_SD	Frontal_Medial_Cortex_mean	Frontal_Medial_Cortex_numvoxels	Frontal_Medial_Cortex_SD	Juxtapositional_Lobule_Cortex_mean	Juxtapositional_Lobule_Cortex_numvoxels	Juxtapositional_Lobule_Cortex_SD	Subcallosal_Cortex_mean	Subcallosal_Cortex_numvoxels	Subcallosal_Cortex_SD	Paracingulate_Gyrus_mean	Paracingulate_Gyrus_numvoxels	Paracingulate_Gyrus_SD	Anterior_cingulate_mean	Anterior_cingulate_numvoxels	Anterior_cingulate_SD	Posterior_cingulate_mean	Posterior_cingulate_numvoxels	Posterior_cingulate_SD	Precuneous_Cortex_mean	Precuneous_Cortex_numvoxels	Precuneous_Cortex_SD	Cuneal_Cortex_mean	Cuneal_Cortex_numvoxels	Cuneal_Cortex_SD	OFC_mean	OFC_numvoxels	OFC_SD	Parahippocampal_Gyrus_ant_mean	Parahippocampal_Gyrus_ant_numvoxels	Parahippocampal_Gyrus_ant_SD	Parahippocampal_Gyrus_post_mean	Parahippocampal_Gyrus_post_numvoxels	Parahippocampal_Gyrus_post_SD	Lingual_Gyrus_mean	Lingual_Gyrus_numvoxels	Lingual_Gyrus_SD	Temporal_Fusiform_Cortex_ant_mean	Temporal_Fusiform_Cortex_ant_numvoxels	Temporal_Fusiform_Cortex_ant_SD	Temporal_Fusiform_Cortex_post_mean	Temporal_Fusiform_Cortex_post_numvoxels	Temporal_Fusiform_Cortex_post_SD	Temporal_Occipital_Fusiform_Cortex_mean	Temporal_Occipital_Fusiform_Cortex_numvoxels	Temporal_Occipital_Fusiform_Cortex_SD	Occipital_Fusiform_Gyrus_mean	Occipital_Fusiform_Gyrus_numvoxels	Occipital_Fusiform_Gyrus_SD	Frontal_Operculum_Cortex_mean	Frontal_Operculum_Cortex_numvoxels	Frontal_Operculum_Cortex_SD	Central_Opercular_Cortex_mean	Central_Opercular_Cortex_numvoxels	Central_Opercular_Cortex_SD	Parietal_Operculum_Cortex_mean	Parietal_Operculum_Cortex_numvoxels	Parietal_Operculum_Cortex_SD	Planum_Polare_mean	Planum_Polare_numvoxels	Planum_Polare_SD	Heschls_Gyrus_mean	Heschls_Gyrus_numvoxels	Heschls_Gyrus_SD	Planum_Temporale_mean	Planum_Temporale_numvoxels	Planum_Temporale_SD	Supracalcarine_Cortex_mean	Supracalcarine_Cortex_numvoxels	Supracalcarine_Cortex_SD	Occipital_Pole_mean	Occipital_Pole_numvoxels	Occipital_Pole_SD" >> $outputpath/GluCEST-HarvardOxford-Cortical-Reward-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-HO-CorticalRegions.nii.gz -numROI 48 -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-HarvardOxford-Cortical-Reward-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-HarvardOxford-Cortical-Reward-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-HarvardOxford-Cortical-Reward-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-HarvardOxford-Cortical-Reward-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-HarvardOxford-Cortical-Reward-GluCEST-measures.csv >> $outputpath/GluCEST-HarvardOxford-Cortical-Reward-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#delineate subcortical reward network anatomical regions with HO subcortical atlas
while read line
do
case=$line
fslmaths $cest/$case/atlases/$case-2d-RewardAtlas-SubCortical.nii.gz -mul $cest/$case/atlases/$case-2d-HarvardOxford-sub.nii.gz $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions.nii.gz 
fslmaths $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions.nii.gz -bin $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions-bin.nii.gz 
fslmaths $cest/$case/atlases/$case-2d-RewardAtlas-SubCortical.nii.gz -sub $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions-bin.nii.gz $cest/$case/atlases/$case-2d-RewardAtlas-Subcortical-HO-unlabeled.nii.gz #create mask of reward network midbrain/brainstem voxels that the Harvard Oxford subcortical atlas does not label
fslmaths $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions.nii.gz -add $cest/$case/atlases/$case-2d-RewardAtlas-Subcortical-HO-unlabeled.nii.gz $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions.nii.gz #Add unlabeled midbrain/brainstem voxels to Reward Network HO subcortical atlas
rm $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions-bin.nii.gz $cest/$case/atlases/$case-2d-RewardAtlas-Subcortical-HO-unlabeled.nii.gz #remove intermediate files 
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

#Reward Network Harvard Oxford Subcortical Regions (Supplementary Figure S1): GluCEST Contrast
touch $outputpath/GluCEST-HarvardOxford-SubCortical-Reward-Measures.csv
echo "Subject	Unlabeled_voxels_mean	Unlabeled_voxels_numvoxels	Unlabeled_voxels_SD	Left_Cerebral_Cortex_mean	Left_Cerebral_Cortex_numvoxels	Left_Cerebral_Cortex__SD	Left_Lateral_Ventrical_mean	Left_Lateral_Ventrical_numvoxels	Left_Lateral_Ventrical_SD	Left_Thalamus_mean	Left_Thalamus_numvoxels	Left_Thalamus_SD	Left_Caudate_mean	Left_Caudate_numvoxels	Left_Caudate_SD	Left_Putamen_mean	Left_Putamen_numvoxels	Left_Putamen_SD	Left_Pallidum_mean	Left_Pallidum_numvoxels	Left_Pallidum_SD	Brain-Stem_mean	Brain-Stem_numvoxels	Brain-Stem_SD	Left_Hippocampus_mean	Left_Hippocampus_numvoxels	Left_Hippocampus_SD	Left_Amygdala_mean	Left_Amygdala_numvoxels	Left_Amygdala_SD	Left_Accumbens_mean	Left_Accumbens_numvoxels	Left_Accumbens_SD	Right_Cerebral_White_Matter_mean	Right_Cerebral_White_Matter_numvoxels	Right_Cerebral_White_Matter_SD	Right_Cerebral_Cortex_mean	Right_Cerebral_Cortex_numvoxels	Right_Cerebral_Cortex_SD	Right_Lateral_Ventricle_mean	Right_Lateral_Ventricle_numvoxels	Right_Lateral_Ventricle_SD	Right_Thalamus_mean	Right_Thalamus_numvoxels	Right_Thalamus_SD	Right_Caudate_mean	Right_Caudate_numvoxels	Right_Caudate_SD	Right_Putamen_mean	Right_Putamen_numvoxels	Right_Putamen_SD	Right_Pallidum_mean	Right_Pallidum_numvoxels	Right_Pallidum_SD	Right_Hippocampus_mean	Right_Hippocampus_numvoxels	Right_Hippocampus_SD	Right_Amygdala_mean	Right_Amygdala_numvoxels	Right_Amygdala_SD	Right_Accumbens_mean	Right_Accumbens_numvoxels	Right_Accumbens_SD" >> $outputpath/GluCEST-HarvardOxford-SubCortical-Reward-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant
3dROIstats -mask $cest/$case/atlases/$case-2d-RewardAtlas-HO-SubCorticalRegions.nii.gz -numROI 21 -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-HarvardOxford-SubCortical-Reward-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-HarvardOxford-SubCortical-Reward-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-HarvardOxford-SubCortical-Reward-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-HarvardOxford-SubCortical-Reward-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-HarvardOxford-SubCortical-Reward-GluCEST-measures.csv >> $outputpath/GluCEST-HarvardOxford-SubCortical-Reward-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt