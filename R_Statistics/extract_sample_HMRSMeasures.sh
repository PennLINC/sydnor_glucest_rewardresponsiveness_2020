#!/bin/bash

if [ -e ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData_Timept1_PassQC.csv ]
then
rm ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData_Timept1_PassQC.csv
fi

touch ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData_Timept1_PassQC.csv
sed -n "1p" ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData.csv >> ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData_Timept1_PassQC.csv # get column headers
while read line
do
cat ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData.csv | grep ${line}, >> ../../MRSMeasures/GluCEST-HMRS-ACC-VoxelData_Timept1_PassQC.csv #get participant mrs measures
done < ./BBLID-Timepoint1-PassQC.csv
