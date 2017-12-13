#!/bin/bash

# Setup ANTs"
ANTSPATH="/data_local/softwares/ANTs/build/bin"
PATH="${ANTSPATH}:${PATH}"
export ANTSPATH PATH

# for ants parallelization
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10

# Atlas path used for brain extraction
currentDirectory=`pwd`
pathOASISTemplate="${currentDirectory}/brain_extraction_template_OASIS"

dataFolder="/data_remote/ABIDE/data"

for subjFolder in ${dataFolder}/subject_*; do	
	structFolder="${subjFolder}/anat"	
	strucFile="${structFolder}/anat"
	echo ${strucFile}
    
	${ANTSPATH}/antsBrainExtraction.sh -d 3 -a ${strucFile}.nii.gz -e ${pathOASISTemplate}/T_template0.nii.gz -m ${pathOASISTemplate}/T_template0_BrainCerebellumProbabilityMask.nii.gz -o ${structFolder}/ants -f ${pathOASISTemplate}/T_template0_BrainCerebellumRegistrationMask.nii.gz -k 1
	
	# rename and only keep what we need
	mv ${structFolder}/antsBrainExtractionBrain.nii.gz ${strucFile}_BFCorr_brain.nii.gz
	mv ${structFolder}/antsBrainExtractionMask.nii.gz ${strucFile}_BFCorr_brain_mask.nii.gz
	mv ${structFolder}/antsN4Corrected0.nii.gz ${strucFile}_BFCorr.nii.gz
	rm -rf ${structFolder}/ants*
done

