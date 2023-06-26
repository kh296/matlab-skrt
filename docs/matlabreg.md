### matlabreg

Register 3D gresycale images, or apply a transform

### Description
`matlabreg` provides a uniform interface to the MATLAB
image-registration functions
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

### Syntax

```
matlabreg(fn, movingPath, fixedPath, outdir, varargin)
```

### Input Arguments
- `fn` - name of registration/transform function to be called;
  may be any of `"imregdeform"`, `"imregdemons"`, `"imregmoment"`,
  `"imregtform"`, `"imwarp"`
  string scalar | character array
- `movingPath` - path to NIfTI file for 3D image to be registered
  string scalar | character array
- `fixedPath` - path to NIFTI file for 3D reference image;
  should be set to same as movingPath in case transform
  string scalar | character array
- `outdir` - path to directory for output
  string scalar | character array
- `varargin` - optional arguments and name-value pairs passed to
  registration/transform function

Spatial referencing information for moving and fixed images
is obtained from the NIfTI metadata.

When the function name is "`imregtform"`, the arguments
`optimizer` and `metric` aren't given.  Instead, `modality`
can be specified as `"multimodal"` (default) or `"monomodal"`
as first optional argument.  Its value is used to create
`optimizer` and `metric` configurations, via
[imregconfig](https://uk.mathworks.com/help/images/ref/imregconfig.html).

All optional arguments and name-value pairs supported by
the function identified by `fn` may be passed via `varargin`.
Default values are as standard, except for the following:

When the function name is `"imregdeform"`, the default value of
`PixelResolution` is the voxel size of the moving image (which
should be the same as the voxel size of the fixed image).

When the function name is `"imregdemons"`, the default value of
`DisplayWaitbar` is `false`.

Outputs are written to `outdir`, following the naming convention
of [elastix](https://elastix.lumc.nl/download/elastix-5.1.0-manual.pdf).  This
 gives:

- `result.nii.0.nii` - transformed moving image from registration;
- `result.nii` - transformed moving image from transformation;
- `TransformParameters.0.txt` - matrix elements for affine registration;
- `TransformParameters.0.nii` - displacement field for deformable registration;
- `deformationField.nii` - displacement field (all types of registration).
