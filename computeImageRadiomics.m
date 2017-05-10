function Radiomics = computeImageRadiomics(I, levels)
N = numel(I);
X = reshape(I, [N 1]);
X_Bar = sum(X)/N;
if max(levels) == 0 && min(levels) == 0
    [P, ~] = histcounts(X);
else
    [P, ~] = histcounts(X, levels);
end
P = P/N;
Radiomics.Energy = sum(P.^2);
Radiomics.Entropy = -P(P~=0)*log2(P(P~=0)');
Radiomics.Kurtosis = kurtosis(X, 1);
Radiomics.Maximum = max(X);
Radiomics.Mean = X_Bar;
Radiomics.MeanAbsoluteDeviation = mad(X);
Radiomics.Median = median(X);
Radiomics.Minimum = min(X);
Radiomics.Range = range(X);
Radiomics.RootMeanSquare = rms(X);
Radiomics.Skewness = skewness(X, 1);
Radiomics.StandardDeviation = std(X);
Radiomics.Uniformity = P*P';
Radiomics.Variance = var(X);