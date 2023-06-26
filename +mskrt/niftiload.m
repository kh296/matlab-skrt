function image = niftiload(niftiPath)
    %NIFTILOAD Load image data from file in NIfTI format
    %
    %   NIFTILOAD(niftiPath) returns a structure array containing
    %     data read from a file in NIfTI format at the path
    %     niftiPath.  The returned structure array has the following
    %     fields:
    %     - Path: path to source file;
    %     - Info: NIfTI metadata;
    %     - Voxels: array of voxel intensities;
    %     - Min: minimum voxel intensity;
    %     - Max: maximum voxel intensith;
    %     - Ref3d: imref3d referencing object;
    %     - Refxy: imref2d referencing object, relative to xy projection.
    %     - Refzx: imref2d referencing object, relative to zx projection.
    %     - Refzy: imref2d referencing object, relative to zy projection.
    %
    %   The patient coordinate system of the image read from file
    %   is assumed to be RAS+, and is converted to LPS+. For information about
    %   patient coordinate systems, see, for example:
    %     - https://nipy.org/nibabel/coordinate_systems.html

    % Create structure and read data.
    image = struct();
    image.Path = niftiPath;
    image.Info = niftiinfo(niftiPath);
    image.Voxels = flip(permute(niftiread(image.Info), [2, 1, 3]), 1);
    image.Min = min(image.Voxels, [], "all");
    image.Max = max(image.Voxels, [], "all");
    
    % Determine image limits from transform
    % relating image coordinates to world coordinates
    affine = image.Info.Transform.T';
    affine(1:2,:) = -affine(1:2,:);
    voxelSize = diag(affine)';
    lims1 = affine(:,4)' - 0.5 * voxelSize;
    lims2 = lims1 + [image.Info.ImageSize, 1] .* voxelSize;
    lims = arrayfun(@(x1, x2) [min(x1, x2), max(x1, x2)], lims1, lims2, ...
        UniformOutput=false);

    % Obtain imref3d object.
    image.Ref3d = imref3d(size(image.Voxels), lims{1:3});

    % Obtain imref2d objects, relative to xy, zx, zy projections.
    image.Refxy = imref2d(image.Ref3d.ImageSize([1,2]), lims{[1,2]});
    image.Refxz = imref2d(image.Ref3d.ImageSize([3,2]), lims{[1,3]});
    image.Refyx = imref2d(image.Ref3d.ImageSize([2,1]), lims{[2,1]});
    image.Refyz = imref2d(image.Ref3d.ImageSize([3,1]), lims{[2,3]});
    image.Refzx = imref2d(image.Ref3d.ImageSize([2,3]), lims{[3,1]});
    image.Refzy = imref2d(image.Ref3d.ImageSize([1,3]), lims{[3,2]});
end


