function [] = niftisave(imageVoxels, info, outPath)
    %NIFTISAVE Save image data to file in NIfTI format
    %
    %   NIFTISAVE(imageVoxels, info, outPath) saves voxel array
    %     imageVoxels and metadata data in NIfTI format to file
    %     at outPath.
    %
    %     The voxel array is adjusted prior to writing, to reverse
    %     the modifications of niftiload().
    
    % Obtain auto-generated metadata
    % for voxel data written in NIfTI format.
    niftiwrite(imageVoxels, outPath);
    info2 = niftiinfo(outPath);

    % Modify input metadata, 
    % based on size and type of imageVoxels array.
    ndim = ndims(imageVoxels);
    imageVoxels = permute(flip(imageVoxels, 1), [2, 1, 3:ndim]);
    info.ImageSize = size(imageVoxels);
    nextra = ndim - numel(info.PixelDimensions);
    info.PixelDimensions = [info.PixelDimensions, ones(1, nextra)];    
    info.Datatype = info2.Datatype;
    info.BitsPerPixel = info2.BitsPerPixel;

    niftiwrite(imageVoxels, outPath, info);
end

