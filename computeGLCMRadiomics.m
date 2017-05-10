function Radiomics = computeGLCMRadiomics(glcm)
nMatrices = size(glcm,3);
nLevels = size(glcm,2);

Radiomics.GLCMAutocorrelation = zeros(nMatrices,1);
Radiomics.GLCMClusterProminence = zeros(nMatrices,1);
Radiomics.GLCMClusterShade = zeros(nMatrices,1);
Radiomics.GLCMClusterTendency = zeros(nMatrices,1);
Radiomics.GLCMContrast = zeros(nMatrices,1);
Radiomics.GLCMCorrelation = zeros(nMatrices,1);
Radiomics.GLCMDifferenceEntropy = zeros(nMatrices,1);
Radiomics.GLCMDifferenceVariance = zeros(nMatrices,1);
Radiomics.GLCMDissimilarity = zeros(nMatrices,1);
Radiomics.GLCMEnergy = zeros(nMatrices,1);
Radiomics.GLCMEntropy = zeros(nMatrices,1);
Radiomics.GLCMHomogeneity1 = zeros(nMatrices,1);
Radiomics.GLCMHomogeneity2 = zeros(nMatrices,1);
Radiomics.GLCMIMC1 = zeros(nMatrices,1);
Radiomics.GLCMIMC2 = zeros(nMatrices,1);
Radiomics.GLCMIDN = zeros(nMatrices,1);
Radiomics.GLCMIDMN = zeros(nMatrices,1);
Radiomics.GLCMInverseVariance = zeros(nMatrices,1);
Radiomics.GLCMMaximumProbability = zeros(nMatrices,1);
Radiomics.GLCMSumAverage = zeros(nMatrices,1);
Radiomics.GLCMSumEntropy = zeros(nMatrices,1);
Radiomics.GLCMSumVariance = zeros(nMatrices,1);
Radiomics.GLCMVariance = zeros(nMatrices,1);

for k = 1:nMatrices
    P = glcm(:,:,k)/sum(sum(glcm(:,:,k)));
    mu = mean2(P);
    px = sum(P,1);
    py = sum(P,2);
    mux = sum((1:nLevels)*P);
    muy = sum((1:nLevels)*P');
    stdx = sum(((1:nLevels)-mux).^2*P);
    stdy = sum(((1:nLevels)-muy).^2*P');
    HX = -(px+eps)*log(px+eps)'; %HX = entropy(px);
    HY = -(py+eps)'*log(py+eps); %HX = entropy(px);
    temp = reshape(P,nLevels*nLevels,1);
    H = -(temp+eps)'*log(temp+eps);    
    HXY1 = 0;
    HXY2 = 0;
    pxminusy = zeros(nLevels,1);
    pxplusy = zeros(2*nLevels-1,1);
    for i = 1:nLevels
        for j = 1:nLevels
            Radiomics.GLCMAutocorrelation(k,1) = i*j*P(i,j)+Radiomics.GLCMAutocorrelation(k,1);
            Radiomics.GLCMClusterProminence(k,1) = (i+j-mux-muy)^4*P(i,j)+Radiomics.GLCMClusterProminence(k,1);
            Radiomics.GLCMClusterShade(k,1) = (i+j-mux-muy)^3*P(i,j)+Radiomics.GLCMClusterShade(k,1);
            Radiomics.GLCMClusterTendency(k,1) = (i+j-mux-muy)^2*P(i,j)+Radiomics.GLCMClusterTendency(k,1);
            Radiomics.GLCMContrast(k,1) = (i-j)*(i-j)*P(i,j)+Radiomics.GLCMContrast(k,1);
            if stdx*stdy == 0
                Radiomics.GLCMCorrelation(k,1) = 0+Radiomics.GLCMCorrelation(k,1);
            else
                Radiomics.GLCMCorrelation(k,1) = ((i-mux)*(j-muy)*P(i,j))/sqrt(stdx*stdy)+Radiomics.GLCMCorrelation(k,1); % Different Definition
            end
            Radiomics.GLCMDissimilarity(k,1) = abs(i-j)*P(i,j)+Radiomics.GLCMDissimilarity(k,1);
            Radiomics.GLCMHomogeneity1(k,1) = P(i,j)/(1+abs(i-j))+Radiomics.GLCMHomogeneity1(k,1);
            Radiomics.GLCMHomogeneity2(k,1) = P(i,j)/(1+abs(i-j)^2)+Radiomics.GLCMHomogeneity2(k,1);
            Radiomics.GLCMIDMN(k,1) = P(i,j)/(1+(abs(i-j)^2/nLevels^2))+Radiomics.GLCMIDMN(k,1);
            Radiomics.GLCMIDN(k,1) = P(i,j)/(1+(abs(i-j)/nLevels))+Radiomics.GLCMIDN(k,1);
            Radiomics.GLCMVariance(k,1) = (i-mu)^2*P(i,j)+Radiomics.GLCMVariance(k,1);
            
            if i == j
            else
                Radiomics.GLCMInverseVariance(k,1) = P(i,j)/abs(i-j)^2+Radiomics.GLCMInverseVariance(k,1);
            end
            HXY1 = HXY1+P(i,j)*log(px(i)*py(j)+eps);
            HXY2 = HXY2+px(i)*py(j)*log(px(i)*py(j)+eps);
            
            kk = abs(i-j)+1;
            ll = i+j-1;
            pxminusy(kk,1) = pxminusy(kk,1)+P(i,j);
            pxplusy(ll,1) = pxplusy(ll,1)+P(i,j);
        end
    end
    Radiomics.GLCMEnergy(k,1) = sum(sum(P.^2));
    Radiomics.GLCMEntropy(k,1) = H;
    Radiomics.GLCMDifferenceEntropy(k,1) = -(pxminusy+eps)'*log(pxminusy+eps);
    Radiomics.GLCMDifferenceVariance(k,1) = (0:nLevels-1).^2*pxminusy;
    HXY1 = -HXY1;
    HXY2 = -HXY2;
    Radiomics.GLCMIMC1(k,1) = (H-HXY1)/max(HX,HY);
    Radiomics.GLCMIMC2(k,1) = sqrt(1-exp(-2*(HXY2-H)));
    Radiomics.GLCMMaximumProbability(k,1) = max(max(P));
    Radiomics.GLCMSumAverage(k,1) = (2:2*nLevels)*pxplusy;
    Radiomics.GLCMSumEntropy(k,1) = -(pxplusy'+eps)*log(pxplusy+eps);
    Radiomics.GLCMSumVariance(k,1) = ((2:2*nLevels)-Radiomics.GLCMSumEntropy(k,1)).^2*pxplusy;
end

Radiomics.GLCMAutocorrelation = mean(Radiomics.GLCMAutocorrelation);
Radiomics.GLCMClusterProminence = mean(Radiomics.GLCMClusterProminence);
Radiomics.GLCMClusterShade = mean(Radiomics.GLCMClusterShade);
Radiomics.GLCMClusterTendency = mean(Radiomics.GLCMClusterTendency);
Radiomics.GLCMContrast = mean(Radiomics.GLCMContrast);
Radiomics.GLCMCorrelation = mean(Radiomics.GLCMCorrelation);
Radiomics.GLCMDifferenceEntropy = mean(Radiomics.GLCMDifferenceEntropy);
Radiomics.GLCMDifferenceVariance = mean(Radiomics.GLCMDifferenceVariance);
Radiomics.GLCMDissimilarity = mean(Radiomics.GLCMDissimilarity);
Radiomics.GLCMEnergy = mean(Radiomics.GLCMEnergy);
Radiomics.GLCMEntropy = mean(Radiomics.GLCMEntropy);
Radiomics.GLCMHomogeneity1 = mean(Radiomics.GLCMHomogeneity1);
Radiomics.GLCMHomogeneity2 = mean(Radiomics.GLCMHomogeneity2);
Radiomics.GLCMIMC1 = mean(Radiomics.GLCMIMC1);
Radiomics.GLCMIMC2 = mean(Radiomics.GLCMIMC2);
Radiomics.GLCMIDN = mean(Radiomics.GLCMIDN);
Radiomics.GLCMIDMN = mean(Radiomics.GLCMIDMN);
Radiomics.GLCMInverseVariance = mean(Radiomics.GLCMInverseVariance);
Radiomics.GLCMMaximumProbability = mean(Radiomics.GLCMMaximumProbability);
Radiomics.GLCMSumAverage = mean(Radiomics.GLCMSumAverage);
Radiomics.GLCMSumEntropy = mean(Radiomics.GLCMSumEntropy);
Radiomics.GLCMSumVariance = mean(Radiomics.GLCMSumVariance);
Radiomics.GLCMVariance = mean(Radiomics.GLCMVariance);