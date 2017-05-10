function Case = convertContourToMaskAndComputeRadiomics2(Case, FSMask)
% Convert RT contour to image mask and computes radiomics
nContours = size(Case.RT.PointList, 2);
for j = 1:nContours
    Case.RT.Image = FSMask.(Case.RT.ContourNames{1,j}).Image;
    Case = convertNormalized(Case);
    Case = computeMRRadiomics(Case, j);
end

function Case = convertNormalized(Case)
if isfield(Case, 'T1NormalizedMNI')
    Case.RT.T1NormalizedMNIImage = Case.RT.Image;
end
if isfield(Case, 'T2NormalizedMNI')
    Case.RT.T2NormalizedMNIImage = Case.RT.Image;
end
if isfield(Case, 'GDNormalizedMNI')
    Case.RT.GDNormalizedMNIImage = Case.RT.Image;
end
if isfield(Case, 'FLNormalizedMNI')
    Case.RT.FLNormalizedMNIImage = Case.RT.Image;
end