# xcpEngineTutorial2
Steps to incorporate custom atlas with xcpEngine

# Create a custom atlas

Download the following 3 atlases:
  * [Buckner cerebellum](http://www.freesurfer.net/fswiki/CerebellumParcellation_Buckner2011)
  * [Choi striatum](https://surfer.nmr.mgh.harvard.edu/fswiki/StriatumParcellation_Choi2012)
  * [Schaefer cortical](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)

Use [James's script] to create a merged atlas

```
./merge_atlas.py \
  -a Schaefer/MNI/Schaefer2018_400Parcels_17Networks_order_FSLMNI152_2mm.nii.gz \
     Choi_JNeurophysiol12_MNI152/Choi2012_17Networks_MNI152_FreeSurferConformed1mm_LooseMask.nii.gz \
     Buckner_JNeurophysiol11_MNI152/Buckner2011_17Networks_MNI152_FreeSurferConformed1mm_LooseMask.nii.gz \
  -r /Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.11_multicore/data/standard/MNI152_T1_2mm_brain.nii.gz \
  -t schaefer_parcel-400_network-17.tsv -n Striatal Cerebellar
```
