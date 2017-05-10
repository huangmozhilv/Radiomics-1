function [GLCMRadiomics, GLRLMRadiomics] = computeTextureRadiomics(II)
 m = floor(min(min(min(II))));
 M = ceil(max(max(max(II))));
 GLCM = computeGrayLevelCoCurrenceMatrix(II, m:M);
 GLCMRadiomics = computeGLCMRadiomics(GLCM);
 GLRLM = computeGrayLevelRunLengthMatrix(II, m:M);
 GLRLMRadiomics = computeGLRLMRadiomics(GLRLM);
