function Case = computeMRRadiomics(Case, j)
% Loop through each study and each contour define the ROI and compute its radiomics
Studies = fieldnames(Case);
nStudies = length(Studies);
contourName = Case.RT.ContourNames{1,j}
for i = 1:nStudies
    name = Studies{i};
    if (strcmp(name, 'T1HybridMNI') == 1) || (strcmp(name, 'T2HybridMNI') == 1) || (strcmp(name, 'DC') == 1) || (strcmp(name, 'FLHybridMNI') == 1) || (strcmp(name, 'GDHybridMNI') == 1)
        Case = defineROI(Case, name, contourName);
        temp = [contourName '_' name];
        Case.Radiomics.(temp) = computeRadiomics(Case.(name).(contourName));
        Case.Radiomics.(temp) = addContourNameAndModality(contourName, name, Case.Radiomics.(temp));
        Case.Radiomics.(temp) = includeDICOMHeader(Case.Radiomics.(temp), Case.(name).Info{1,1});
    end
end

function STR = addContourNameAndModality(contourName, name, STR)
TEMP.ContourName = contourName;
TEMP.Modality = name;
M = [fieldnames(TEMP)' fieldnames(STR)'; struct2cell(TEMP)' struct2cell(STR)'];
STR = struct(M{:});        

function Case = defineROI(Case, name, contourName)
if     (strcmp(name, 'T1RegisteredMNI') == 1) || (strcmp(name, 'T1NormalizedMNI') == 1) || (strcmp(name, 'T1HybridMNI') == 1)
    RTMask = Case.RT.T1NormalizedMNIImage;
elseif (strcmp(name, 'T1RegisteredLOW') == 1) || (strcmp(name, 'T1NormalizedLOW') == 1) || (strcmp(name, 'T1HybridLOW') == 1)
    RTMask = Case.RT.T1NormalizedLOWImage;
elseif (strcmp(name, 'T2RegisteredMNI') == 1) || (strcmp(name, 'T2NormalizedMNI') == 1) || (strcmp(name, 'T2HybridMNI') == 1)
    RTMask = Case.RT.T2NormalizedMNIImage;
elseif (strcmp(name, 'T2RegisteredLOW') == 1) || (strcmp(name, 'T2NormalizedLOW') == 1) || (strcmp(name, 'T2HybridLOW') == 1)
    RTMask = Case.RT.T2NormalizedLOWImage;
elseif (strcmp(name, 'GDRegisteredMNI') == 1) || (strcmp(name, 'GDNormalizedMNI') == 1) || (strcmp(name, 'GDHybridMNI') == 1)
    RTMask = Case.RT.GDNormalizedMNIImage;
elseif (strcmp(name, 'GDRegisteredLOW') == 1) || (strcmp(name, 'GDNormalizedLOW') == 1) || (strcmp(name, 'GDHybridLOW') == 1)
    RTMask = Case.RT.GDNormalizedLOWImage;
elseif (strcmp(name, 'FLRegisteredMNI') == 1) || (strcmp(name, 'FLNormalizedMNI') == 1) || (strcmp(name, 'FLHybridMNI') == 1)
    RTMask = Case.RT.FLNormalizedMNIImage;
elseif (strcmp(name, 'FLRegisteredLOW') == 1) || (strcmp(name, 'FLNormalizedLOW') == 1) || (strcmp(name, 'FLHybridLOW') == 1)
    RTMask = Case.RT.FLNormalizedLOWImage;
else
    RTMask = Case.RT.Image;
end
I = double(Case.(name).Image);
Case.(name).(contourName).I_Mask = I.*RTMask;
Case.(name).(contourName).Stats = regionprops(RTMask, {'Area', 'BoundingBox', 'Centroid', 'FilledArea', 'FilledImage', 'Image', 'PixelIdxList', 'PixelList', 'SubarrayIdx'});
Case.(name).(contourName).Stats = Case.(name).(contourName).Stats(1);
Case.(name).(contourName).Stats.VoxelResolution = [Case.(name).Info{1, 1}.PixelSpacing(1) Case.(name).Info{1, 1}.PixelSpacing(2) Case.(name).Info{1, 1}.SliceThickness];

function STR = includeDICOMHeader(STR, Info)
if isfield(Info, 'EchoTrainLength')
    STR.EchoTrainLength = Info.EchoTrainLength;
else
    STR.EchoTrainLength = ' ';
end
if isfield(Info, 'FlipAngle')
    STR.FlipAngle = Info.FlipAngle;
else
    STR.FlipAngle = ' ';
end
if isfield(Info, 'ProtocolName')
    STR.ProtocolName = Info.ProtocolName;
else
    STR.ProtocolName = ' ';
end
if isfield(Info, 'MRAcquisitionType')
    STR.MRAcquisitionType = Info.MRAcquisitionType;
else
    STR.MRAcquisitionType = ' ';
end
if isfield(Info, 'ManufacturerModelName')
    STR.ManufacturerModelName = Info.ManufacturerModelName;
else
    STR.ManufacturerModelName = ' ';
end
if isfield(Info, 'MagneticFieldStrength')
    STR.MagneticFieldStrength = Info.MagneticFieldStrength;
else
    STR.MagneticFieldStrength = ' ';
end
if isfield(Info, 'ScanOptions')
    STR.ScanOptions = Info.ScanOptions;
else
    STR.ScanOptions = ' ';
end
if isfield(Info, 'SequenceVariant')
    STR.SequenceVariant = Info.SequenceVariant;
else
    STR.SequenceVariant = ' ';
end
if isfield(Info, 'ScanningSequence')
    STR.ScanningSequence = Info.ScanningSequence;
else
    STR.ScanningSequence = ' ';
end
if isfield(Info, 'InversionTime')
    STR.InversionTime = Info.InversionTime;
else
    STR.InversionTime = ' ';
end
if isfield(Info, 'EchoTime')
    STR.EchoTime = Info.EchoTime;
else
    STR.EchoTime = ' ';
end
if isfield(Info, 'RepetitionTime')
    STR.RepetitionTime = Info.RepetitionTime;
else
    STR.RepetitionTime = ' ';
end
if isfield(Info, 'PatientBirthDate')
    STR.BirthDate = Info.PatientBirthDate;
else
    STR.BirthDate = ' ';
end
if isfield(Info, 'StudyDate')
    STR.StudyDate = Info.StudyDate;
else
    STR.StudyDate = ' ';
end
if isfield(Info, 'PatientSex')
    STR.PatientSex = Info.PatientSex;
else
    STR.PatientSex = ' ';
end
if isfield(Info, 'PatientWeight')
    STR.PatientWeight = Info.PatientWeight;
else
    STR.PatientWeight = ' ';
end
if isfield(Info, 'Manufacturer')
    STR.Manufacturer = Info.Manufacturer;
else
    STR.Manufacturer = ' ';
end
if isfield(Info, 'PixelSpacing') && isfield(Info, 'SliceThickness')
    STR.VoxelSize = [num2str(Info.PixelSpacing(1)) 'x' num2str(Info.PixelSpacing(2)) 'x' num2str(Info.SliceThickness)];
else
    STR.VoxelSize = ' ';
end
if isfield(Info, 'ImageType')
    STR.ImageType = Info.ImageType;
else
    STR.ImageType = ' ';
end
if isfield(Info, 'SeriesDescription')
    STR.SeriesDescription = Info.SeriesDescription;
else
    STR.SeriesDescription = ' ';
end
if isfield(Info, 'PatientPosition')
    STR.PatientPosition = Info.PatientPosition;
else
    STR.PatientPosition = ' ';
end