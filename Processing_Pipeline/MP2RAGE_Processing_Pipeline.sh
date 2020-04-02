#!/bin/bash

#This script processes 7T Terra MP2RAGE data.
#The processing pipeline includes: 
	#UNI and INV2 dicom to nifti conversion
	#structural brain masking
	#ANTS N4 bias field correction
	#FSL FAST (for tissue segmentation and gray matter probability maps)
	#UNI to MNI registration with ANTS SyN (rigid+affine+deformable syn)

#######################################################################################################
## DEFINE PATHS ##

structural=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Structural #path for processed structural output
dicoms=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Dicoms #path to dicoms
base=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project #project path
ANTSPATH=/data/joy/BBL/applications/ANTSlatest/build/bin
#######################################################################################################
## IDENTIFY CASES FOR PROCESSING ##

for i in $(ls /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Dicoms)
do
case=${i##*/}
echo "CASE: $case"

if ! [ -d $structural/$case ] && [ -d $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_INV2 ] && [ -d $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_UNI_Images ]

then
logfile=$base/logs/Structural/$case.log
{
echo "--------Processing structural data for $case---------" 
sleep 1.5
mkdir $structural/$case
mkdir $structural/$case/fast
mkdir $structural/$case/MNI_transforms
mkdir $structural/$case/atlases
#######################################################################################################
## STRUCTURAL DICOM CONVERSION ##

#convert UNI
/home/melliott/scripts/dicom2nifti.sh -u -F $structural/$case/$case-UNI.nii $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_UNI_Images/*dcm
gzip $structural/$case/$case-UNI.nii

#convert INV2
/home/melliott/scripts/dicom2nifti.sh -u -F $structural/$case/$case-INV2.nii $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_INV2/*dcm
gzip $structural/$case/$case-INV2.nii
#######################################################################################################
## STRUCTURAL BRAIN MASKING ##

#create initial mask with BET using INV2 image
bet $structural/$case/$case-INV2.nii.gz $structural/$case/$case -m -f 0.2
rm -f $structural/$case/$case.nii.gz

#generate final brain mask
fslmaths $structural/$case/$case-UNI.nii.gz -mul $structural/$case/${case}_mask.nii.gz $structural/$case/$case-UNI.nii.gz
rm -f $structural/$case/${case}_mask.nii.gz
fslmaths $structural/$case/$case-UNI.nii.gz -bin $structural/$case/$case-mask.nii.gz
fslmaths $structural/$case/$case-mask.nii.gz -ero -kernel sphere 1 $structural/$case/$case-UNI-mask-er.nii.gz
rm -f $structural/$case/$case-mask.nii.gz 

#apply final brain mask to UNI and INV2 images
fslmaths $structural/$case/$case-UNI.nii.gz -mas $structural/$case/$case-UNI-mask-er.nii.gz $structural/$case/$case-UNI-masked.nii.gz
fslmaths $structural/$case/$case-INV2.nii.gz -mas $structural/$case/$case-UNI-mask-er.nii.gz $structural/$case/$case-INV2-masked.nii.gz
#######################################################################################################
## BIAS FIELD CORRECTION ##

N4BiasFieldCorrection -d 3 -i $structural/$case/$case-UNI-masked.nii.gz -o $structural/$case/$case-UNI-processed.nii.gz
N4BiasFieldCorrection -d 3 -i $structural/$case/$case-INV2-masked.nii.gz -o  $structural/$case/$case-INV2-processed.nii.gz
#######################################################################################################
## FAST TISSUE SEGMENTATION ##

fast -n 3 -t 1 -g -p -o $structural/$case/fast/$case $structural/$case/$case-INV2-processed.nii.gz
#######################################################################################################
## UNI TO MNI152 REGISTRATION ##

#register processed UNI to upsampled MNI T1 template
#MNI152 T1 1mm template was upsampled to match UNI voxel resolution: ResampleImage 3 MNI152_T1_1mm_brain.nii.gz MNI152_T1_0.8mm_brain.nii.gz 0.8223684430X0.8223684430X0.8199999928 0 4
antsRegistrationSyN.sh -d 3 -f $structural/MNI_Templates/MNI/MNI152_T1_0.8mm_brain.nii.gz -m $structural/$case/$case-UNI-processed.nii.gz -o $structural/$case/MNI_transforms/$case-UNIinMNI-
#######################################################################################################
#clean up sweep sweep 
rm $structural/$case/$case-UNI.nii.gz
rm $structural/$case/$case-INV2.nii.gz 
rm $structural/$case/*log 

echo -e "\n$case SUCCESFULLY PROCESSED\n\n\n"
} | tee "$logfile"
else
echo "$case is either missing structural dicoms or already processed. Will not process"
sleep 1.5
fi
done 