function [Radiomics1, Radiomics2, Radiomics3] = computeWaveletRadiomics(I)
[Lo_D, Hi_D] = wfilters('coif1', 'd');

Lo_D3 = reshape(Lo_D, [1 1 length(Lo_D)]);
Hi_D3 = reshape(Hi_D, [1 1 length(Hi_D)]);
f = convn(convn(Lo_D, Lo_D'), Lo_D3);          %% LLL
f(:,:,:,2) = convn(convn(Lo_D, Lo_D'), Hi_D3); %% LLH
f(:,:,:,3) = convn(convn(Lo_D, Hi_D'), Lo_D3); %% LHL
f(:,:,:,4) = convn(convn(Lo_D, Hi_D'), Hi_D3); %% LHH
f(:,:,:,5) = convn(convn(Hi_D, Lo_D'), Lo_D3); %% HLL
f(:,:,:,6) = convn(convn(Hi_D, Lo_D'), Hi_D3); %% HLH
f(:,:,:,7) = convn(convn(Hi_D, Hi_D'), Lo_D3); %% HHL
f(:,:,:,8) = convn(convn(Hi_D, Hi_D'), Hi_D3); %% HHH
for i = 1:8
    F = f(:,:,:,i);
    II = imfilter(I, F);
    %     II = resampleImage(II);
    m = floor(min(min(min(II))));
    M = ceil(max(max(max(II))));
    II = (II-m)/(M-m);
    II = II*10;
    II = round(II);
    M = ceil(max(max(max(II))));
    m = floor(min(min(min(II))));
    ImageRadiomics = computeImageRadiomics(II, m:M);
    Radiomics1(1,i) = ImageRadiomics;    
    [GLCMRadiomics, GLRLMRadiomics] = computeTextureRadiomics(II);
    Radiomics2(1,i) = GLCMRadiomics;
    Radiomics3(1,i) = GLRLMRadiomics;
end