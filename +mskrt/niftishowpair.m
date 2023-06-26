function [] = niftishowpair(niftiPath1, niftiPath2, varargin)
    %NIFTISHOWPAIR Display pair of images, read from files in NIfTI format
    %   
    %   NIFTISHOWPAIR reads data for two images from files in
    %   NIfTI format, then plots a single slice per image, side
    %   by side and/or superimposed.
    %
    %   Syntax
    %     NIFTISHOWPAIR(niftiPath1, niftiPath2, varargin)
    %
    %   Input Arguments
    %     niftiPath1 - path to NIfTI file for first image
    %       string scalar | character array
    %     niftiPath1 - path to NIfTI file for second image
    %       string scalar | character array
    %
    %   Optional Argumeents
    %     xyz1 - specification in world coordinates of slice to be
    %       plotted for first image (default: 0)
    %       scalar | three-element row vector
    %     xyz2 - specification in world coordinates of slice to be
    %       plotted for second image (default: 0)
    %       scalar | three-element row vector
    % 
    %   The world coordinate of a slice to be plotted may be given
    %   either as a scalar or as an element in an [x, y, z] row vector.
    %   The latter allows the same slice specification to be used
    %   with multiple views.
    %
    %   Name-Value Arguments
    %     View - specification of view to be plotted, one of
    %       "x-y" (default), "x-z", "y-x", "y-z", "z-x", "z-y".
    %       In each case, the first letter indicates the axis that
    %       will be plotted horizontally, and the second letter indicates
    %       the axis that will be plotted vertically.
    %       string scalar | character array
    %     Separate - if true (default), produce plot of image slices
    %       side by side; if false, omit this plot
    %       logical
    %     Together - if true (default), produce plot of image slices
    %       superimposed; if false, omit this plot
    %     Titles - image titles in order: first image in side-by-side plot,
    %       second image in side-by-side plot, image of slices superimposed
    %       (default: ["", "", ""])
    %       3-element string array

    import mskrt.isrightsize
    import mskrt.niftiload

    % Define and validate arguments.
    p = inputParser;
    addRequired(p, 'niftiPath1', @(x) exist(x, "file"));
    addRequired(p, 'niftiPath2', @(x) exist(x, "file"));
    addOptional(p, 'xyz1', NaN, ...
        @(x) isrightsize(x, 1) || isrightsize(x, 1, 3));
    addOptional(p, 'xyz2', NaN, ...
        @(x) isrightsize(x, 1) || isrightsize(x, 1, 3));
    addParameter(p, 'View', "x-y", @(x) ismember( ...
        x, ["x-y", "x-z", "y-x", "y-z", "z-x", "z-y"]));
    addParameter(p, 'Separate', 1, @(x) islogical(x) || isscalar(x));
    addParameter(p, 'Together', 1, @(x) islogical(x) || isscalar(x));
    addParameter(p, 'Titles', ["", "", ""], ...
        @(x) isstring(x) && 3 == numel(x));
    parse(p, niftiPath1, niftiPath2, varargin{:});

    % Load images.
    image1 = niftiload(niftiPath1);
    image2 = niftiload(niftiPath2);

    % Convert from world coordinates to image coordinates.
    xyz = {p.Results.xyz1, p.Results.xyz2};
    ijk = zeros(2, 3);
    ref = {image1.Ref3d, image2.Ref3d};
    for idx = 1:2
        if isnan(xyz{idx})
            xyz{idx} = {0, 0, 0};
        elseif isscalar(xyz{idx})
            xyz{idx} = repelem({xyz{idx}}, 3);
        else
            xyz{idx} = num2cell(xyz{idx});
        end
        [i, j, k] = worldToIntrinsic(ref{idx}, xyz{idx}{:});
        ijk(idx,:) = arrayfun(@round, [i, j, k]);
    end

    % Select voxels and spatial reference information
    % for selected view and slice.
    switch p.Results.View
        case "x-y"
            ref1 = image1.Refxy;
            ref2 = image2.Refxy;
            voxels1 = permute(image1.Voxels(:,:,ijk(1,3)), [1,2,3]);
            voxels2 = permute(image2.Voxels(:,:,ijk(2,3)), [1,2,3]);
        case "x-z"
            ref1 = image1.Refxz;
            ref2 = image2.Refxz;
            voxels1 = permute(image1.Voxels(ijk(1,2),:,:), [3,2,1]);
            voxels2 = permute(image2.Voxels(ijk(2,2),:,:), [3,2,1]);
        case "y-x"
            ref1 = image1.Refyx;
            ref2 = image2.Refyx;
            voxels1 = permute(image1.Voxels(:,:,ijk(1,3)), [2,1,3]);
            voxels2 = permute(image2.Voxels(:,:,ijk(2,3)), [2,1,3]);
        case "y-z"
            ref1 = image1.Refyz;
            ref2 = image2.Refyz;
            voxels1 = permute(image1.Voxels(:,ijk(1,1),:), [3,1,2]);
            voxels2 = permute(image2.Voxels(:,ijk(2,1),:), [3,1,2]);
        case "z-x"
            ref1 = image1.Refzx;
            ref2 = image2.Refzx;
            voxels1 = permute(image1.Voxels(ijk(1,2),:,:), [2,3,1]);
            voxels2 = permute(image2.Voxels(ijk(2,2),:,:), [2,3,1]);
        case "z-y"
            ref1 = image1.Refzy;
            ref2 = image2.Refzy;
            voxels1 = permute(image1.Voxels(:,ijk(1,1),:), [1,3,2]);
            voxels2 = permute(image2.Voxels(:,ijk(2,1),:), [1,3,2]);
    end

    % Define axis labels.
    view = char(p.Results.View);
    xtext = view(1);
    ytext = view(3);

    % Show image slices side by side.
    if logical(logical(p.Results.Separate))
        figure
        subplot(1, 2, 1)
        imshow(voxels1, ref1)
        title((p.Results.Titles(1)))
        xlabel(xtext)
        ylabel(ytext)
        subplot(1, 2, 2)
        imshow(voxels2, ref2)
        title((p.Results.Titles(2)))
        xlabel(xtext)
        ylabel(ytext)
    end

    % Show image slices superimposed.
    if logical(logical(p.Results.Together))
        figure
        imshowpair(voxels1, ref1, voxels2, ref2)
        title((p.Results.Titles(3)))
        xlabel(xtext)
        ylabel(ytext)
    end
end
