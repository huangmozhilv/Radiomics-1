function LongitudinalRadiomics2
% Main code
close all; clc;
ID = definePatientIDs;
Radiomics = computeMedulloBlastomaRadiomics(ID);
xlswrite('Radiomics2.xlsx', Radiomics)

function ID = definePatientIDs
% Define patient ID as cell array
ID = {'P39621.20130820'; 'P39621.20131106'; 'P39621.20140204'; 'P39621.20140506'};
% ID = {'P43913.20150811'; 'P43913.20151023'; 'P45280.20150624'; 'P45280.20160105'};

function Radiomics = computeMedulloBlastomaRadiomics(ALL_ID)
% Loop through each ID and perform the following:
% (1) Read image
% (2) Convert contour to mask
% (3) Compute radiomics for each Mask
% (4) Assemble radiomics for output
nID = length(ALL_ID);
Radiomics = [];
for i = 1:nID
    ID = ALL_ID{i}
    Case = readImage(ID);
    Case = filterContours(Case);
    Case.CT = Case.T1;
    FSMask = FreesurferMask(ID);
    Case = convertContourToMaskAndComputeRadiomics2(Case, FSMask);
    Radiomics = convertRadiomicsToTable(Radiomics, Case.Radiomics, ID);
    clear Case
end

function Case = filterContours(Case)
ContourList = { 'FrontalLobe'; 'TemporalLobe'; 'TemporalLobeGreyMatter'; 'OccipitalLobe'; 'OccipitalLobeGreyMatter';...
    'BrainStem'; 'CerebellumWhiteMatterLeft'; 'CerebellumWhiteMatterRight';...
    'ThalamusLeft'; 'ThalamusRight'; 'CaudateLeft'; 'CaudateRight';...
    'HippocampusLeft'; 'HippocampusRight'; 'LateralVentricleLeft'; 'LateralVentricleRight'; 'FourthVentricle';...
    'AccumbensAreaLeft'; 'AccumbensAreaRight'; 'ThirdVentricle'};

nContours = length(ContourList);
newRT.PointList = cell(1,nContours);
newRT.ContourNames = cell(1,nContours);
for i = 1:nContours
    currentContour = ContourList{i};
    idx = find(strcmp(Case.RT.ContourNames, currentContour));
    newRT.PointList{1,i} = Case.RT.PointList{1,idx};
    newRT.ContourNames{1,i} = Case.RT.ContourNames{1,idx};
end

Case.RT = newRT;

function Radiomics1 = convertRadiomicsToTable(Radiomics1, Radiomics2, ID)
% Take two input radiomics and combine into one for xlsx output
Studies = fieldnames(Radiomics2);
nStudies = length(Studies);
for i = 1:nStudies
    if isempty(Radiomics1)
        Radiomics1 = ['PatientID' fieldnames(Radiomics2.(Studies{1}))'];
    end
    name = Studies{i};
    B = [ID struct2cell(Radiomics2.(name))'];
    Radiomics1 = [Radiomics1; B];
end