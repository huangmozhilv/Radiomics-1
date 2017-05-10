function Case = readImage(ID)
% Read Original DICOM, Registered MNI, Normalized MNI, and Downsampled MNI
% Comment respective lines if not needed
Case = readOriginal(ID);
% Case = readMNINative(ID, Case);
Case = readMNINormalized(ID, Case);
% Case = readLOWNative(Case);
% Case = readLOWNormalized(Case);

function Case = readOriginal(ID)
% Read DICOM from Patient ID folder
FolderList = dir(ID);
FolderName = {FolderList.name}';
nFolder = size(FolderName, 1);
for i = 3:nFolder %% Excluding ./ & ../
    name = FolderName{i};
    pathname = [ID '/' name '/'];
    list = dir([pathname '*.dcm']);
    file = [pathname list(1).name];
    info = dicominfo(file);
    if strcmp(name, 'RT') == 1
        Case.RT = readRTStructure(info);
    else
        Case.(name) = readDICOM(info, list, pathname);
    end
end

%% Native Resolution, Native Intensity
% Reorient MR to CT orientation
% for i = 3:nFolder
%     name = FolderName{i};
%     if (strcmp(name, 'CT') == 1) || (strcmp(name, 'RT') == 1)
%         continue
%     else
%         Case.(name) = reOrientMR(Case.CT, Case.(name));
%     end
% end

function Case = readMNINative(ID, Case)
%% MNI Registration, Native Intensity, Non-Stripped
% Read MNI registered .nii, harcoded to read files in nii folder
filename = ['nii/' ID '.T1.Registered.Corrected.nii'];
if exist(filename, 'file') == 2
    Case.T1RegisteredMNI = readNormalized(Case, filename, 'T1', ID);
end
filename = ['nii/' ID '.T2.Registered.Corrected.nii'];
if exist(filename, 'file') == 2
    Case.T2RegisteredMNI = readNormalized(Case, filename, 'T2', ID);
end
filename = ['nii/' ID '.GD.Registered.Corrected.nii'];
if exist(filename, 'file') == 2
    Case.GDRegisteredMNI = readNormalized(Case, filename, 'GD', ID);
end
filename = ['nii/' ID '.FL.Registered.Corrected.nii'];
if exist(filename, 'file') == 2
    Case.FLRegisteredMNI = readNormalized(Case, filename, 'FL', ID);
end

function Case = readMNINormalized(ID, Case)
%% MNI Registration, Normalized Intensity, Non-Stripped
% Read MNI normalzied .nii, harcoded to read files in nii folder
filename = ['nii/' ID '.T1.Registered.Corrected.Normalized.nii'];
if exist(filename, 'file') == 2
    Case.T1NormalizedMNI = readNormalized(Case, filename, 'T1', ID);
end
filename = ['nii/' ID '.T2.Registered.Corrected.Normalized.nii'];
if exist(filename, 'file') == 2
    Case.T2NormalizedMNI = readNormalized(Case, filename, 'T2', ID);
end
filename = ['nii/' ID '.T1.Registered.Corrected.Normalized.Hybrid.nii'];
if exist(filename, 'file') == 2
    Case.T1HybridMNI = readNormalized(Case, filename, 'T1', ID);
end
filename = ['nii/' ID '.T2.Registered.Corrected.Normalized.Hybrid.nii'];
if exist(filename, 'file') == 2
    Case.T2HybridMNI = readNormalized(Case, filename, 'T2', ID);
end
filename = ['nii/' ID '.GD.Registered.Corrected.Normalized.nii'];
if exist(filename, 'file') == 2
    Case.GDNormalizedMNI = readNormalized(Case, filename, 'GD', ID);
end
filename = ['nii/' ID '.FL.Registered.Corrected.Normalized.nii'];
if exist(filename, 'file') == 2
    Case.FLNormalizedMNI = readNormalized(Case, filename, 'FL', ID);
end
filename = ['nii/' ID '.GD.Registered.Corrected.Normalized.Hybrid.nii'];
if exist(filename, 'file') == 2
    Case.GDHybridMNI = readNormalized(Case, filename, 'GD', ID);
end
filename = ['nii/' ID '.FL.Registered.Corrected.Normalized.Hybrid.nii'];
if exist(filename, 'file') == 2
    Case.FLHybridMNI = readNormalized(Case, filename, 'FL', ID);
end

function Case = readLOWNative(Case)
%% LOW Registration, Native Intensity, Non-Stripped
% Downsample MNI registration to 2x2x2, using opensource code (resize)
if isfield(Case, 'T1RegisteredMNI')
    Case.T1RegisteredLOW = Case.T1RegisteredMNI;
    Case.T1RegisteredLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T1RegisteredLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T1RegisteredLOW.Info{1, 1}.SliceThickness = 2;
    Case.T1RegisteredLOW.Image = resize(Case.T1RegisteredMNI.Image, round(size(Case.T1RegisteredMNI.Image)/2));
end
if isfield(Case, 'T2RegisteredMNI')
    Case.T2RegisteredLOW = Case.T2RegisteredMNI;    
    Case.T2RegisteredLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T2RegisteredLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T2RegisteredLOW.Info{1, 1}.SliceThickness = 2;
    Case.T2RegisteredLOW.Image = resize(Case.T2RegisteredMNI.Image, round(size(Case.T2RegisteredMNI.Image)/2));
end
if isfield(Case, 'GDRegisteredMNI')
    Case.GDRegisteredLOW = Case.GDRegisteredMNI;
    Case.GDRegisteredLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.GDRegisteredLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.GDRegisteredLOW.Info{1, 1}.SliceThickness = 2;
    Case.GDRegisteredLOW.Image = resize(Case.GDRegisteredMNI.Image, round(size(Case.GDRegisteredMNI.Image)/2));
end
if isfield(Case, 'FLRegisteredMNI')
    Case.FLRegisteredLOW = Case.FLRegisteredMNI;
    Case.FLRegisteredLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.FLRegisteredLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.FLRegisteredLOW.Info{1, 1}.SliceThickness = 2;
    Case.FLRegisteredLOW.Image = resize(Case.FLRegisteredMNI.Image, round(size(Case.FLRegisteredMNI.Image)/2));
end

function Case = readLOWNormalized(Case)
%% LOW Registration, Normalized Intensity, Non-Stripped
% Downsample MNI normalized to 2x2x2, using opensource code (resize)
if isfield(Case, 'T1NormalizedMNI')
    Case.T1NormalizedLOW = Case.T1NormalizedMNI;    
    Case.T1NormalizedLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T1NormalizedLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T1NormalizedLOW.Info{1, 1}.SliceThickness = 2;
    Case.T1NormalizedLOW.Image = resize(Case.T1NormalizedMNI.Image, round(size(Case.T1NormalizedMNI.Image)/2));
end
if isfield(Case, 'T2NormalizedMNI')
    Case.T2NormalizedLOW = Case.T2NormalizedMNI;    
    Case.T2NormalizedLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T2NormalizedLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T2NormalizedLOW.Info{1, 1}.SliceThickness = 2;
    Case.T2NormalizedLOW.Image = resize(Case.T2NormalizedMNI.Image, round(size(Case.T2NormalizedMNI.Image)/2));
end
if isfield(Case, 'GDNormalizedMNI')
    Case.GDNormalizedLOW = Case.GDNormalizedMNI;    
    Case.GDNormalizedLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.GDNormalizedLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.GDNormalizedLOW.Info{1, 1}.SliceThickness = 2;
    Case.GDNormalizedLOW.Image = resize(Case.GDNormalizedMNI.Image, round(size(Case.GDNormalizedMNI.Image)/2));
end
if isfield(Case, 'FLNormalizedMNI')
    Case.FLNormalizedLOW = Case.FLNormalizedMNI;    
    Case.FLNormalizedLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.FLNormalizedLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.FLNormalizedLOW.Info{1, 1}.SliceThickness = 2;
    Case.FLNormalizedLOW.Image = resize(Case.FLNormalizedMNI.Image, round(size(Case.FLNormalizedMNI.Image)/2));
end
if isfield(Case, 'T1HybridMNI')
    Case.T1HybridLOW = Case.T1HybridMNI;    
    Case.T1HybridLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T1HybridLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T1HybridLOW.Info{1, 1}.SliceThickness = 2;
    Case.T1HybridLOW.Image = resize(Case.T1HybridMNI.Image, round(size(Case.T1HybridMNI.Image)/2));
end
if isfield(Case, 'T2HybridMNI')
    Case.T2HybridLOW = Case.T2HybridMNI;    
    Case.T2HybridLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.T2HybridLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.T2HybridLOW.Info{1, 1}.SliceThickness = 2;
    Case.T2HybridLOW.Image = resize(Case.T2HybridMNI.Image, round(size(Case.T2HybridMNI.Image)/2));
end
if isfield(Case, 'GDHybridMNI')
    Case.GDHybridLOW = Case.GDHybridMNI;    
    Case.GDHybridLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.GDHybridLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.GDHybridLOW.Info{1, 1}.SliceThickness = 2;
    Case.GDHybridLOW.Image = resize(Case.GDHybridMNI.Image, round(size(Case.GDHybridMNI.Image)/2));
end
if isfield(Case, 'FLHybridMNI')
    Case.FLHybridLOW = Case.FLHybridMNI;
    Case.FLHybridLOW.Info{1, 1}.PixelSpacing(1) = 2;
    Case.FLHybridLOW.Info{1, 1}.PixelSpacing(2) = 2;
    Case.FLHybridLOW.Info{1, 1}.SliceThickness = 2;
    Case.FLHybridLOW.Image = resize(Case.FLHybridMNI.Image, round(size(Case.FLHybridMNI.Image)/2));
end

function STR = readNormalized(Case, filename, type, ID)
% Read normalized images with transformation matrix for contours
% Transformation matrix information from R must be stored in nii folder
STR = Case.(type);
hdr = nii_read_header(filename);
STR.Info{1, 1}.PixelSpacing(1) = hdr.PixelDimensions(1);
STR.Info{1, 1}.PixelSpacing(2) = hdr.PixelDimensions(2);
STR.Info{1, 1}.SliceThickness = hdr.PixelDimensions(3);
STR.Image = nii_read_volume(hdr);
STR.SForm = [hdr.SrowX'; hdr.SrowY'; hdr.SrowZ'];
STR.SForm(:,4) = STR.SForm(:,4)*-1;
STR.Image = permute(STR.Image, [2 1 3]);
STR.Image = flip(STR.Image, 1);
% STR.Image = flip(STR.Image, 2);
STR.Image = flip(STR.Image, 3);

TransMxFile = ['nii/' ID '.' type '.Rigid0GenericAffine.mat'];
load(TransMxFile)
STR.TransMx = reshape(AffineTransform_float_3_3, [3 4]);
STR.TransMx(4, :) = [0 0 0 1];
a = STR.TransMx(1, 4);
STR.TransMx(1, 4) = STR.TransMx(2, 4);
STR.TransMx(2, 4) = a;

function MR = reOrientMR(CT, MR)
% Reorient MR to CT
if CT.ImagePositionPatient(1,3) > CT.ImagePositionPatient(2,3)
    CTOrientation = 'H2T';
else
    CTOrientation = 'T2H';
end
if MR.ImagePositionPatient(1,3) > MR.ImagePositionPatient(2,3)
    MROrientation = 'H2T';
else
    MROrientation = 'T2H';
end
if CTOrientation == MROrientation
else
    MR.Image = flip(MR.Image,3);
end
if CT.Info{1,1}.PatientPosition == MR.Info{1,1}.PatientPosition
else
    MR.Image = flip(MR.Image,1); %LR
    MR.Image = flip(MR.Image,2); %AP
end

function STR = readRTStructure(info)
% Read RTStructure file
contourNames = fieldnames(info.ROIContourSequence);
nContours = length(contourNames);
for j = 1:nContours
    currentContour = contourNames{j};
    ListNames = fieldnames(info.ROIContourSequence.(currentContour).ContourSequence);
    nFields = length(ListNames);
    PointList = [];
    for i = 1:nFields
        name = ListNames{i};
        ContourData = info.ROIContourSequence.(currentContour).ContourSequence.(name).ContourData;
        nPoints = length(ContourData)/3;
        ContourData = reshape(ContourData, [3 nPoints]);
        PointList = [PointList; ContourData'];
    end
    STR.PointList{1,j} = PointList;
    STR.ContourNames{1,j} = info.StructureSetROISequence.(currentContour).ROIName;
end

function STR = readDICOM(info, list, pathname)
% Read DICOM
nRows = info.Rows;
nCols = info.Columns;
nSlices = size(list,1);
STR.Image = zeros(nRows, nCols, nSlices, 'uint16');
for i = 1:nSlices
    file = [pathname list(i).name];
    info = dicominfo(file);
    I = uint16(dicomread(file));
    STR.Info{info.InstanceNumber,1} = info;
    STR.Image(:,:,info.InstanceNumber) = I;
    STR.ImagePositionPatient{info.InstanceNumber,1} = info.ImagePositionPatient;
end
STR.ImagePositionPatient = cell2mat(STR.ImagePositionPatient);
STR.ImagePositionPatient = reshape(STR.ImagePositionPatient, [3 nSlices]);
STR.ImagePositionPatient = double(STR.ImagePositionPatient');