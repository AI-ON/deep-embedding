#!/bin/bash

# Setup ANTs"
ANTSPATH="/data_local/softwares/ANTs/build/bin"
PATH="${ANTSPATH}:${PATH}"
export ANTSPATH PATH

# MNI directory
currentDirectory=`pwd`
mniTemplates="${currentDirectory}/mni_templates"

dataFolder="/data_remote/ABIDE/data"

for subjFolder in ${dataFolder}/subject_*; do

	structFolder="${subjFolder}/anat"
	structBrain="${structFolder}/anat_BFCorr_brain.nii.gz"

	# 1. normalization (structural to MNI) in ANTs
	${ANTSPATH}/antsRegistrationSyN.sh -d 3 -f ${mniTemplates}/MNI152_T1_2mm_brain.nii.gz -m ${structBrain} -o ${structFolder}/ANTsT1toMNI -n 12 -j 1 -x ${mniTemplates}/MNI152_T1_2mm_brain_mask_dil.nii.gz
	rm ${structFolder}/ANTsT1toMNIWarped.nii.gz
	rm ${structFolder}/ANTsT1toMNIInverseWarped.nii.gz

	# 2. transform structural to MNI space in 2 and 4mm space
	${ANTSPATH}/antsApplyTransforms -d 3 -i ${structBrain} -r ${mniTemplates}/MNI152_T1_2mm_brain.nii.gz -o ${structFolder}/anat_mni_2mm.nii.gz -n BSpline -t ${structFolder}/ANTsT1toMNI1Warp.nii.gz -t ${structFolder}/ANTsT1toMNI0GenericAffine.mat -v --float
	fslmaths ${structFolder}/anat_mni_2mm.nii.gz -mas ${mniTemplates}/MNI152_T1_2mm_brain_mask.nii.gz ${structFolder}/anat_mni_2mm.nii.gz

	${ANTSPATH}/antsApplyTransforms -d 3 -i ${structBrain} -r ${mniTemplates}/MNI152_T1_4mm_brain.nii.gz -o ${structFolder}/anat_mni_4mm.nii.gz -n BSpline -t ${structFolder}/ANTsT1toMNI1Warp.nii.gz -t ${structFolder}/ANTsT1toMNI0GenericAffine.mat -v --float
	fslmaths ${structFolder}/anat_mni_4mm.nii.gz -mas ${mniTemplates}/MNI152_T1_4mm_brain_mask.nii.gz ${structFolder}/anat_mni_4mm.nii.gz

done
