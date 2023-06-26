### niftisave
Save image data to file in NIfTI format

### Description

`niftisave(imageVoxels, info, outPath)` saves voxel array
imageVoxels and metadata data in NIfTI format to file
at outPath.

The voxel array is adjusted prior to writing, to reverse
the modifications of [niftiload](niftiload.md).
