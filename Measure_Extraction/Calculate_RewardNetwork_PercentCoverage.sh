#!/bin/bash

#This script calculates the percentage of the whole brain reward network included in each participant's GluCEST image

#######################################################################################################
## DEFINE PATHS ##

cest=/data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST #path to processed GluCEST data
#######################################################################################################

touch /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures/RewardNetwork-PercentCoverage-Measures.csv
echo "Case	RewardNetwork_PercentCoverage" >> /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures/RewardNetwork-PercentCoverage-Measures.csv

#calculate reward network percent coverage for each participant
RewardNetworkVolume=127061.296875
while read line
do
case=$line
stats=$(fslstats $cest/$case/atlases/${case}-2d-RewardAtlas-TotalNetwork.nii.gz -V)
SubVolume=${stats#*\ }
percentcoverage=$(echo "scale=5 ; $SubVolume / $RewardNetworkVolume" | bc)
echo "${case}	${percentcoverage}" >> /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/Output_Measures/RewardNetwork-PercentCoverage-Measures.csv
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt
