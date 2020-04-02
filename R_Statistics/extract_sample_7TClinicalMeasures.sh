#!/bin/bash

if [ -e ../../ClinicalMeasures/7TClinical_Summarymeasures_Timept1_PassQC.csv ]
then
rm ../../ClinicalMeasures/7TClinical_Summarymeasures_Timept1_PassQC.csv 
fi

touch ../../ClinicalMeasures/7TClinical_Summarymeasures_Timept1_PassQC.csv
sed -n "1p" ../../ClinicalMeasures/7TClinical_Summarymeasures.csv >> ../../ClinicalMeasures/7TClinical_Summarymeasures_Timept1_PassQC.csv #get column headers
while read line
do
cat ../../ClinicalMeasures/7TClinical_Summarymeasures.csv | grep ${line}, >> ../../ClinicalMeasures/7TClinical_Summarymeasures_Timept1_PassQC.csv #get participant clinical measures
done < ./BBLID-Timepoint1-PassQC.csv 
