# Multi-step image registration

## Overview

The `matlab-skrt` toolbox provides a set of functions for multi-step rigid
and deformable registration of 3D medical images in the format of the
Neuroimaging Informatics Technology Initiative
([NIfTI](https://nifti.nimh.nih.gov/)).  The
functions implement a MATLAB image-registration engine for
[scikit-rt](https://scikit-rt.github.io/scikit-rt/), a Python toolkit for
radiotherapy data, but may also be used standalone.

This work was supported by Cancer Research UK RadNet Cambridge [C17918/A28870].

<img src="docs/images/RadNet_Cambridge.png" alt="RadNet logo" height="150"/>

## Usage

The main function is `mskrt.matlabreg()`, which provides a uniform interface
to the MATLAB image-registration functions:

- [imregdeform](https://uk.mathworks.com/help/medical-imaging/ref/imregdeform.html)
- [imregdemons](https://uk.mathworks.com/help/images/ref/imregdemons.html)
- [imregmoment](https://uk.mathworks.com/help/medical-imaging/ref/imregmoment.html)
- [imregtform](https://uk.mathworks.com/help/images/ref/imregtform.html)

and to the MATLAB image-transformation function:

- [imwarp](https://uk.mathworks.com/help/images/ref/imwarp.html).

It takes as input paths to fixed and moving image in
[NIfTI](https://nifti.nimh.nih.gov/) format.  For a registration,
it saves in output the registration transform, the
transformed moving image, and the displacement field.
For a tranformation, it saves in output the transformed
moving image and, for affine transforms, the displacement field.
The transformed moving image always has the same size,
voxel dimensions and extent as the fixed image.

### Example

See: [Two-step deformable image registration](examples/deformable_registration.md)

### Package functions

The full list of package functions is:
- [getdispfield](docs/getdispfield.md) - Compute displacement field
  for an affine transform
- [getnumerics](docs/getnumerics.md) - Obtain numeric values from
   input structure array
- [isrightsize](docs/isrightsize.md) - Determine whether input is a
   numeric array of required size
- [istext](docs/istext.md) - Determine whether input is a character array or
   string scalar
- [matlabreg](docs/matlabreg.md) - Register 3D gresycale images, or apply
   a transform
- [niftiload](docs/niftiload.md) - Load image data from file in NIfTI format
- [niftisave](docs/niftisave.md) - Save image data to file in NIfTI format
- [niftishowpair](docs/niftishowpair.md) - Display pair of images, read
  from files in NIfTI format 
