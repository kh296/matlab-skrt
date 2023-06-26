### getdispField

Compute displacement field for an affine transform

### Description

`getdispfield(info, tform)` returns a 4D array
representing the displacment field for mapping points
from a 3D fixed image to a 3D moving image, when the latter
image is mapped to the former by the
[affinetform3d](https://uk.mathworks.com/help/images/ref/affinetform3d.html)
transform `tform`.  The fixed image is described by the NIfTI metadata `info`,
as returned when reading a file in NIfTI format using
[niftiinfo](https://uk.mathworks.com/help/images/ref/niftiinfo.html).

The affine transform `tform` must be invertible.
