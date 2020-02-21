# xcpEngineTutorial2
Steps to incorporate custom atlas with xcpEngine

James' tutorial: https://github.com/NeuroimagingUIowa/xcpEngineTutorial

# Create a custom atlas

Download the following 3 atlases:
  * [Buckner cerebellum](http://www.freesurfer.net/fswiki/CerebellumParcellation_Buckner2011)
  * [Choi striatum](https://surfer.nmr.mgh.harvard.edu/fswiki/StriatumParcellation_Choi2012)
  * [Schaefer cortical](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)

Use James's script [merge_atlas.py](https://github.com/NeuroimagingUIowa/xcpEngineTutorial2/blob/master/merge_atlas.py) to create a merged atlas

```
./merge_atlas.py \
  -a Schaefer/MNI/Schaefer2018_400Parcels_17Networks_order_FSLMNI152_2mm.nii.gz \
     Choi_JNeurophysiol12_MNI152/Choi2012_17Networks_MNI152_FreeSurferConformed1mm_LooseMask.nii.gz \
     Buckner_JNeurophysiol11_MNI152/Buckner2011_17Networks_MNI152_FreeSurferConformed1mm_LooseMask.nii.gz \
  -r /Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.11_multicore/data/standard/MNI152_T1_2mm_brain.nii.gz \
  -t schaefer_parcel-400_network-17.tsv -n Striatal Cerebellar
```
The output of this includes `mergedMNI.nii.gz` and `lut.tsv`.

# Clone your local xcpEngine

```
git clone https://github.com/PennBBL/xcpEngine.git
```

Follow [this](https://github.com/PennBBL/xcpEngine/tree/master/atlas/schaefer400x17) to know what you have to include in your custom atlas folder.

I created these files using [`create_xcpfiles.R`](https://github.com/NeuroimagingUIowa/xcpEngineTutorial2/blob/master/create_xcpfiles.R). These files were also uploaded on this github. Copy these files to a `merged` folder in your local xcpEngine (`xcpEngine/atlas/merged`).

Then, you need to edit `xcpEngine/space/MNI/MNI_atlas.json` by adding this:

```
"merged": {
    "CommunityNamesAPriori": "${BRAINATLAS}/merged/mergedCommunityNames.txt",
    "CommunityPartitionAPriori": "${BRAINATLAS}/merged/mergedCommunityAffiliation.txt",
    "Map": "${BRAINATLAS}/merged/mergedMNI.nii.gz",
    "NodeIndex": "${BRAINATLAS}/merged/mergedNodeIndex.txt",
    "NodeNames": "${BRAINATLAS}/merged/mergedNodeNames.txt",
    "Space": "MNI",
    "SpaceNative": "MNI",
    "Type": "Map"
 }
```

# Run xcpEngine with a custom atlas

Download the design file:

```
curl -O https://raw.githubusercontent.com/PennBBL/xcpEngine/master/designs/fc-36p_scrub.dsn 
sed -e "s|power264|merged|" fc-36p_scrub.dsn > fc-36p_scrub_merged.dsn
```

Create a cohort file with the content below:

```
id0,img
sub-1,fmriprep/sub-1/func/sub-1_task-rest_space-T1w_desc-preproc_bold.nii.gz
```

Create a job script with the content below to run xcpEngine:

```
#!/bin/sh

#$ -pe smp 5
#$ -q PINC
#$ -m e
#$ -M tien-tong@uiowa.edu
#$ -o /Users/tientong/xcpEngine_tut
#$ -e /Users/tientong/xcpEngine_tut

singularity run -B /Users/tientong/xcpEngine/atlas/merged:/xcpEngine/atlas/merged \
-B /Users/tientong/xcpEngine/space/MNI/MNI_atlas.json:/xcpEngine/space/MNI/MNI_atlas.json \
-H /Users/tientong/singularity_home \
/Users/tientong/xcpEngine.simg \
-d /Users/tientong/xcpEngine_tut/fc-36p_scrub_merged.dsn \
-c /Users/tientong/xcpEngine_tut/cohort.csv \
-o /Users/tientong/xcpEngine_tut/test \
-t 1 -r /Users/tientong/xcpEngine_tut
```

