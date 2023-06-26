function [] = matlabreg(fn, movingPath, fixedPath, outdir, varargin)
    %MATLABREG Register 3D gresycale images, or apply a transform
    %
    %   MATLABREG provides a uniform interface to the MATLAB
    %   image-registration functions imregdeform, imregdemons,
    %   imregmoment, imregtform, and to the image-transformation
    %   function imwarp.  It takes as input paths to fixed and
    %   moving image in NIfTI format.  For a registration,
    %   it saves in output the registration transform, the
    %   transformed moving image, and the displacement field.
    %   For a tranformation, it saves in output the transformed
    %   moving image and, for affine transforms, the displacement field.
    %   The transformed moving image always has the same size,
    %   voxel dimensions and extent as the fixed image.
    %
    %   Syntax
    %     MATLABREG(fn, movingPath, fixedPath, outdir, varargin)
    %
    %   Input Arguments
    %     fn - name of registration/transform function to be called;
    %       may be any of "imregdeform", "imregdemons", "imregmoment",
    %       "imregtform", "imwarp"
    %       string scalar | character array
    %     movingPath - path to NIfTI file for 3D image to be registered
    %       string scalar | character array
    %     fixedPath - path to NIFTI file for 3D reference image;
    %       should be set to same as movingPath in case transform
    %       string scalar | character array
    %     outdir - path to directory for output
    %       string scalar | character array
    %     varargin - optional arguments and name-value pairs passed to
    %       registration/transform function
    %
    %   Spatial referencing information for moving and fixed images
    %   is obtained from the NIfTI metadata.
    %
    %   When the function name is "imregtform", the arguments
    %   optimizer and metric aren't given.  Instead, modality
    %   can be specified as "multimodal" (default) or "monomodal"
    %   as first optional argument.  Its value is used to create
    %   optimizer and metric configurations, via imregconfig.
    %
    %   All optional arguments and name-value pairs supported by
    %   the function identified by fn may be passed via varargin.
    %   Default values are as standard, except for the following:
    %
    %     When the function name is "imregdeform", the default value of
    %       PixelResolution is the voxel size of the moving image (which
    %       should be the same as the voxel size of the fixed image).
    %
    %     When the function name is "imregdemons", the default value of
    %       DisplayWaitbar is false.
    %
    %   Outputs are written to outdir, following the naming convention
    %   of elastix:
    %     https://elastix.lumc.nl/download/elastix-5.1.0-manual.pdf
    %   This gives:
    %     result.nii.0.nii - transformed moving image from registration;
    %     result.nii - transformed moving image from transformation;
    %     TransformParameters.0.txt - matrix elements
    %       for affine registration;
    %     TransformParameters.0.nii - displacement field
    %       for deformable registration;
    %     deformationField.nii - displacement field
    %       (all types of registration).
    %
    %   The registration functions imregmoment and imregtform
    %   can handle fixed image and moving image being different
    %   in size, voxel dimensions and extent, while imregdeform
    %   and imregdemons require that they be the same.
    %
    %   Deformable registration of images of different sizes,
    %   voxel dimensions and/or extent can be achieved in a two-step
    %   process.  In the first step, the fixed image and moving image are
    %   passed to matlabreg with "imregmoment" or "imregtform" as function
    %   name.  In the second step, the fixed image and transformed moving
    %   image from the first step are passed to matlabreg with
    %   "imregdeform" or "imregdemons" as function name.

    import mskrt.getdispfield
    import mskrt.getnumerics
    import mskrt.isrightsize
    import mskrt.niftiload
    import mskrt.niftisave

    % Define function names accepted.
    fNames = ["imregdeform", "imregdemons", "imregmoment",...
        "imregtform", "imwarp"];

    % Define and validate arguments common to all functions.
    p = inputParser;
    addRequired(p, 'fn', @(x) ismember(x, fNames));
    addRequired(p, 'movingPath', @(x) exist(x, "file"));
    addRequired(p, 'fixedPath', @(x) exist(x, "file"));
    addRequired(p, 'outdir', @(x) exist(x, "dir"));
    parse(p, fn, movingPath, fixedPath, outdir);

    % Load data from NIfTI files.
    moving = niftiload(movingPath);
    fixed = niftiload(fixedPath);

    % Initialise results to null values.
    transformed = [];
    dispField = [];
    tform = [];

    % Set default name of output file for transformed image.
    resultFile = "result.0.nii";

    % Call specified function.
    switch fn

        case "imregdeform"
            % Define and validate arguments for imregdeform().
            p = inputParser;
            addParameter(p, 'GridSpacing', [4, 4, 4], ...
                @(x) isrightsize(x, 1, 3));
            addParameter(p,'PixelResolution', ...
                moving.Info.PixelDimensions, ...
                @(x) isrightsize(x, 1, 3));
            addParameter(p, 'NumPyramidLevel', 3, ...
                @isrightsize);
            addParameter(p, 'GridRegularization', 0.11, ...
                @isrightsize);
            addParameter(p, 'DisplayProgress', 1, ...
                @isrightsize)
            parse(p, varargin{:});

            % Extract numerical values,
            % which may have been passed as strings.
            numerics = getnumerics(p.Results);

            % Perform the registration.
            [dispField, transformed] = imregdeform( ...
                moving.Voxels, fixed.Voxels, ...
                GridSpacing=numerics.GridSpacing, ...
                PixelResolution=numerics.PixelResolution, ...
                NumPyramidLevel=numerics.NumPyramidLevel, ...
                GridRegularization=numerics.GridRegularization, ...
                DisplayProgress=numerics.DisplayProgress);

        case "imregdemons"
            % Define and validate arguments for imregdemons().
            p = inputParser;
            addOptional(p, 'N', 100, @isrightsize)
            addParameter(p, 'AccumulatedFieldSmoothing', 1.0, ...
                @(x) isrightsize());
            addParameter(p, 'PyramidLevels', 3, @isrightsize);
            addParameter(p, 'DisplayWaitbar', 0, @isrightsize)
            parse(p, varargin{:});

            % Extract numerical values,
            % which may have been passed as strings.
            numerics = getnumerics(p.Results);

            % Perform the registration.
            [dispField, transformed] = imregdemons( ...
                moving.Voxels, fixed.Voxels, numerics.N, ...
                AccumulatedFieldSmoothing, ...
                numerics.AccumulatedFieldSmoothing, ...
                PyramidLevels, numerics.PyramidLevels, ...
                DisplayWaitbar. numerics.DisplayWaitbar);

        case "imregmoment"
            % Define and validate arguments for imregmoment().
            p = inputParser;
            addParameter(p, 'MedianThresholdBitmap', 0, @isrightsize);
            parse(p, varargin{:});

            % Extract numerical values,
            % which may have been passed as strings.
            numerics = getnumerics(p.Results);

            % Perform the registration.
            [tform, transformed] = imregmoment( ...
                moving.Voxels, moving.Ref3d, ...
                fixed.Voxels, fixed.Ref3d,...
                MedianThresholdBitmap=numerics.MedianThresholdBitmap);

        case "imregtform"
            % Define and validate arguments for imregtform().
            p = inputParser;
            addOptional(p, 'tformType', "translation", @(x) ismember(x, ...
                ["translation", "rigid", "similarity", "affine"]));
            addOptional(p, 'modality', "multimodal", @(x) ismember(x, ...
                ["monomodal", "multimodal"]))
            addOptional(p, 'interp', "linear", ...
                @(x) ismember(x, ["nearest", "linear", "cubic"]));
            addParameter(p, 'DisplayOptimization', 1, @isrightsize);
            parse(p, varargin{:});

            % Extract numerical values,
            % which may have been passed as strings.
            numerics = getnumerics(p.Results);

            [optimizer, metric] = imregconfig(p.Results.modality);

            % Perform the registration.
            tform = imregtform( ...
                moving.Voxels, moving.Ref3d, ...
                fixed.Voxels, fixed.Ref3d,...
                p.Results.tformType, optimizer, metric, ...
                'DisplayOptimization', numerics.DisplayOptimization);

            [transformed, transformedRef3d] = imwarp( ...
                moving.Voxels, moving.Ref3d, tform, p.Results.interp, ...
                'OutputView', fixed.Ref3d, 'FillValues', 0);

        case "imwarp"
            % Define and validate arguments for imwarp().
            p = inputParser;
            addRequired(p, 'tfile', @(x) exist(x, "file"));
            addOptional(p, 'interp', "linear", ...
                @(x) ismember(x, ["nearest", "linear", "cubic"]));
            addParameter(p, 'FillValues', 0);
            addParameter(p, 'SmoothEdges', 0, @isrightsize);

            parse(p, varargin{:});

            % Extract numerical values,
            % which may have been passed as strings.
            numerics = getnumerics(p.Results);
            if isprop(numerics, "FillValues")
                fillValues = numerics.FillValues;
            else
                fillValues = p.Results.FillValues;
            end

            % Load transform.
            [~, ~, ext] = fileparts(p.Results.tfile);
            if ".txt" == ext
                % Transform specified by affine matrix.
                A = readmatrix(p.Results.tfile);
                tformIn = affinetform3d(A);
                [transformed, transformedRef3d] = imwarp( ...
                    moving.Voxels, moving.Ref3d, tformIn, ...
                    p.Results.interp, 'FillValues', fillValues, ...
                    'SmoothEdges', logical(numerics.SmoothEdges), ...
                    'OutputView', fixed.Ref3d);
                dispField = getdispfield(fixed.Info, tformIn);
            else
                % Transform specified by displacement field.
                dispFieldIn = niftiread(p.Results.tfile);
                transformed = imwarp( ...
                    moving.Voxels, dispFieldIn, ...
                    p.Results.interp, 'FillValues', fillValues, ...
                    'SmoothEdges', logical(numerics.SmoothEdges));
            end

            % Change name of output file for transformed image.
            resultFile = "result.nii";

    end

    % Save results.
    if ~isempty(transformed)
        niftisave(transformed, fixed.Info, ...
            fullfile(outdir, resultFile));
    end

    if isprop(tform, "A")
        writematrix(tform.A, ...
            fullfile(outdir, "TransformParameters.0.txt"));
        dispField = getdispfield(fixed.Info, tform);
        niftisave(dispField, fixed.Info, ...
            fullfile(outdir, "deformationField.nii"));
        dispField = [];
    end

    if ~isempty(dispField)
        niftiwrite(dispField, ...
            fullfile(outdir, "TransformParameters.0.nii"));
        niftisave(dispField, fixed.Info, ...
            fullfile(outdir, "deformationField.nii"));
    end

end
