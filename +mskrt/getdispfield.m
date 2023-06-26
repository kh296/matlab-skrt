function dispField = getdispfield(info, tform)
    %GETDISPFIELD Compute displacement field for an affine transform
    % 
    %   GETDISPFIELD(info, tform) returns a 4D array
    %     representing the displacment field for mapping points
    %     from a 3D fixed image to a 3D moving image, when the latter
    %     image is mapped to the former by the affinetform3d transform
    %     tform.  The fixed image is described by the NIfTI metadata info,
    %     as returned when reading a file in NIfTI format using niftiinfo.
    %
    %     The affine transform tform must be invertible.
    dispField = [];
    smallNumber = 0.001;
    if det(tform.A) > smallNumber
        nVoxel = prod(info.ImageSize);
        xyz1 = ones(nVoxel,4);
        [xyz1(:,1), xyz1(:,2), xyz1(:,3)] = ...
            ind2sub(info.ImageSize, 1:nVoxel);
        xyz1 = xyz1 * info.Transform.T;
        xyz2 = xyz1 * inv(tform.A)';
        dispField = ...
            reshape(xyz2(:,1:3) - xyz1(:,1:3), [info.ImageSize, 3]);
        dispField = permute(dispField, [2, 1, 3, 4]);
    end
end

