### niftiload
Load image data from file in NIfTI format

### Description
`niftiload(niftiPath)` returns a structure array containing
data read from a file in NIfTI format at the path
niftiPath.  The returned structure array has the following
fields:

- `Path`: path to source file;
- `Info`: NIfTI metadata;
- `Voxels`: array of voxel intensities;
- `Min`: minimum voxel intensity;
- `Max`: maximum voxel intensith;
- `Ref3d`: [imref3d](https://uk.mathworks.com/help/images/ref/imref3d.html)
  referencing object;
- `Refxy`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to xy projection;
- `Refxz`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to xz projection;
- `Refyx`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to yx projection;
- `Refyz`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to yz projection;
- `Refzx`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to zx projection;
- `Refzy`: [imref2d](https://uk.mathworks.com/help/images/ref/imref2d.html)
  referencing object, relative to zy projection;

The patient coordinate system of the image read from file
is assumed to be RAS+, and is converted to LPS+.  For information about
patient coordinate systems, see, for example: [Coordinate systems and affines](https://nipy.org/nibabel/coordinate_systems.html).
