#!/bin/bash

dataFolder="/data_remote/ABIDE/data"
currentDirectory=`pwd`
checksFolder="${currentDirectory}/checks_registration" 

for subjFolder in ${dataFolder}/subject_*; do
	echo ${subjFolder}
	structFolder="${subjFolder}/anat"
	structBrain="${structFolder}/anat_mni_2mm.nii.gz"
	
	fslmaths ${structBrain} -thrP 5 -bin ${structFolder}/mask_mni2mm
done

fslmerge -t ${checksFolder}/mask_merge.nii.gz `ls ${dataFolder}/*/anat/mask_mni2mm.nii.gz`
fslmaths ${checksFolder}/mask_merge.nii.gz -TMean ${checksFolder}/maskAVG.nii.gz
imrm ${checksFolder}/mask_merge.nii.gz
