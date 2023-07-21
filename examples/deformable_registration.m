% Deformable image registration for images of different size
%
% The registration functions imregmoment and imregtform
% can handle fixed image and moving image being different
% in size, voxel dimensions and extent, while imregdeform
% and imregdemons require that they be the same.
%
% Deformable registration of images of different sizes,
% voxel dimensions and/or extent can be achieved in a two-step
% process.  In the first step, the fixed image and moving image are
% passed to matlabreg with "imregmoment" or "imregtform" as function
% name.  In the second step, the fixed image and transformed moving
% image from the first step are passed to matlabreg with
% "imregdeform" or "imregdemons" as function name.
%
% This script demonstrates deformable image registration for
% two images differing in all of size, voxel dimensions and extent
% (all values except image size in world coordinates):
%
% fixed image: sphere.nii.gz
%   image size (rows, columns, slices): [80, 100, 40]
%   voxel size (x, y, z): [0.8, 1.0, 1.5]
%   image extent (x, y, z): [[-40.40 39.60], [-35.50 44.50], [-20.75 39.25]]
%   spere of radius 15, centred at [7, -5, 11]
%
% moving image: cube.nii.gz
%   image size (rows, columns, slices): [100, 60, 50]
%   voxel size (x, y, z): [1.5, 1.2, 1.0]
%   image extent (x, y, z): [[-40.40 39.60], [-35.50 44.50], [-20.75 39.25]]
%   cube with side length 30, centred at [15, -13, 19]
%
% The challenge for the registration is to determine the transformations
% that will translate and deform the cube to matches the sphere.

% Initialise workspace.
clear
close all

% Try to ensure that mskrt package is in the path.
mskrtRoot = fileparts(fileparts(mfilename('fullpath')));
if ~contains(path, mskrtRoot)
    addpath(mskrtRoot)
end

% Define path to data folder.
dataDir = fullfile(mskrtRoot, "examples", "data");

% Define paths to NIfTI files for fixed and moving image.
spherePath = fullfile(dataDir, "sphere.nii.gz");
cubePath = fullfile(dataDir, "cube.nii.gz");

% Define path to results folder.
resultsDir = fullfile(mskrtRoot, "registration_results");

% Ensure that results folder exists and is empty.
if exist(resultsDir, "dir")
    rmdir(resultsDir, "s")
end

% Create subfolder for each registration step.
imregtformDir = fullfile(resultsDir, "imregtformDir");
imregdeformDir = fullfile(resultsDir, "imregdeformDir");
mkdir(resultsDir)
mkdir(imregtformDir)
mkdir(imregdeformDir)

% Use shape centres to define slices for viewing, and choose view.
xyz1 = [7, -5, 11];
xyz2 = [15, -13, 19];
view = "x-y";

% Display initial images.
mskrt.niftishowpair(spherePath, cubePath, xyz1, xyz2, view=view, ...
    titles=["Fixed image", "Moving image", "Fixed image vs Moving image"])

% Perform first registration step: translation.
mskrt.matlabreg("imregtform", cubePath, spherePath, imregtformDir, ...
    "translation", "monomodal", "nearest")

% Display images after applying the translation
% from the first registration step to the moving image.
% The transformed cube is approximately superimposed on the sphere.
cubeTranslatedPath = fullfile(imregtformDir, "result.0.nii");
mskrt.niftishowpair(spherePath, cubeTranslatedPath, ...
    xyz1, xyz1, view=view, ...
    titles=["Fixed image", "Translated moving image", ...
    "Fixed image vs Translated moving image"])

% Perform second registration step: deformation.
mskrt.matlabreg("imregdeform", cubeTranslatedPath, spherePath, ...
    imregdeformDir)

% Display images after also applying the deformation
% from the second registration step to the moving image.
% The transformed cube approximately matches the sphere.
cubeDeformedPath = fullfile(imregdeformDir, "result.0.nii");
mskrt.niftishowpair(spherePath, cubeDeformedPath, ...
    xyz1, xyz1, view=view, ...
    titles=["Fixed image", "Translated and deformed moving image", ...
    "Fixed image vs Translated and deformed moving image"])
