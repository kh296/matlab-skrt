### niftishowpair

Display pair of images, read from files in NIfTI format

### Description
`niftishowpair` reads data for two images from files in
NIfTI format, then plots a single slice per image, side
by side and/or superimposed.

### Syntax
```
niftishowpair(niftiPath1, niftiPath2, varargin)
```

### Input Arguments
- `niftiPath1` - path to NIfTI file for first image
  string scalar | character array
- `niftiPath1` - path to NIfTI file for second image
  string scalar | character array

### Optional Argumeents
- `xyz1` - specification in world coordinates of slice to be
  plotted for first image (default: `0`)
  scalar | three-element row vector
- `xyz2` - specification in world coordinates of slice to be
  plotted for second image (default: `0`)
  scalar | three-element row vector

The world coordinate of a slice to be plotted may be given
either as a scalar or as an element in an `[x, y, z]` row vector.
The latter allows the same slice specification to be used
with multiple views.

### Name-Value Arguments
- `View` - specification of view to be plotted, one of
  `"x-y"` (default), `"x-z"`, `"y-x"`, `"y-z"`, `"z-x"`, `"z-y"`.
  In each case, the first letter indicates the axis that
  will be plotted horizontally, and the second letter indicates
  the axis that will be plotted vertically.
  string scalar | character array
- `Separate` - if `true` (default), produce plot of image slices
  side by side; if `false`, omit this plot logical
- `Together` - if `true` (default), produce plot of image slices
  superimposed; if `false`, omit this plot
- `Titles` - image titles in order: first image in side-by-side plot,
  second image in side-by-side plot, image of slices superimposed
  (default: `["", "", ""]`)
  3-element string array
