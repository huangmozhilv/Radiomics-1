function Radiomics = computeRadiomics(Seg)
nStructures = size(Seg.Stats, 1);
temp = [];
for i = 1:nStructures
    roi = round(Seg.Stats(i).BoundingBox);
    I = Seg.I_Mask(roi(2):roi(2)+roi(5)-1, roi(1):roi(1)+roi(4)-1, roi(3):roi(3)+roi(6)-1);
    %% Group 1
    m = floor(min(min(min(I))));
    M = ceil(max(max(max(I))));
    ImageRadiomics = computeImageRadiomics(I, m:M);
    %% Group 2
    ShapeRadiomics = computeShapeRadiomics(Seg.Stats(i));
    %% Group 3
    II = resampleImage(I);
    [GLCMRadiomics, GLRLMRadiomics] = computeTextureRadiomics(II);
%     TextureRadiomics = combineStructures(GLCMRadiomics, GLRLMRadiomics);
    %% Group 4
    [WaveletRadiomics1, WaveletRadiomics2, WaveletRadiomics3] = computeWaveletRadiomics(I);
%     WaveletRadiomics = combineWaveletRadiomics(WaveletRadiomics1, WaveletRadiomics2, WaveletRadiomics3);
    %% Coliage
    [Coliage1, Coliage2] = computeColiageRadiomics(I);
%     Coliage1 = renameRadiomics(Coliage1, '1', 'Coliage');
%     Coliage2 = renameRadiomics(Coliage2, '2', 'Coliage');
%     ColiageRadiomics = combineStructures(Coliage1, Coliage2);
    %%
    Radiomics = combineStructures(ImageRadiomics, ShapeRadiomics);
%     Radiomics = combineStructures(Radiomics, TextureRadiomics);
%     Radiomics = combineStructures(Radiomics, WaveletRadiomics);
%     Radiomics = combineStructures(Radiomics, ColiageRadiomics);
    %%
    temp = [temp; Radiomics];
end
Radiomics = temp;

function WaveletRadiomics = combineWaveletRadiomics(WaveletRadiomics1, WaveletRadiomics2, WaveletRadiomics3)
name = {'LLL' 'LLH' 'LHL' 'LHH' 'HLL' 'HLH' 'HHL' 'HHH'};
for i = 1:8
    tempRadiomics1 = renameRadiomics(WaveletRadiomics1(i), name{i}, 'Wavelet');
    tempRadiomics2 = renameRadiomics(WaveletRadiomics2(i), name{i}, 'Wavelet');
    tempRadiomics3 = renameRadiomics(WaveletRadiomics3(i), name{i}, 'Wavelet');
    WaveletRadiomics = combineStructures(tempRadiomics1, tempRadiomics2);
    WaveletRadiomics = combineStructures(WaveletRadiomics, tempRadiomics3);
end

function I = resampleImage(I)
m = floor(min(min(min(I))));
M = ceil(max(max(max(I))));
I = (I-m)/(M-m);
I = I*10;
I = round(I);

function Radiomics = combineStructures(Radiomics1, Radiomics2)
temp = [fieldnames(Radiomics1)' fieldnames(Radiomics2)';...
    struct2cell(Radiomics1)' struct2cell(Radiomics2)'];
Radiomics = struct(temp{:});

function Radiomics = renameRadiomics(Radiomics, type, name)
oldNames = fieldnames(Radiomics);
nFields = length(oldNames);
for i = 1 :nFields
    newName = [name type oldNames{i}];
    Radiomics.(newName) = Radiomics.(oldNames{i});
    Radiomics = rmfield(Radiomics, oldNames{i});
end