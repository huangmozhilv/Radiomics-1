function [Coliage1, Coliage2] = computeColiageRadiomics(I)
[Entropy1, Entropy2] = coliage3D(I);
m = floor(min(min(min(Entropy1))));
M = ceil(max(max(max(Entropy1))));
Coliage1 = computeImageRadiomics(Entropy1, m:M);
m = floor(min(min(min(Entropy2))));
M = ceil(max(max(max(Entropy2))));
Coliage2 = computeImageRadiomics(Entropy2, m:M);

function [Entropy1, Entropy2] = coliage3D(I)
[~, A, E] = imgradient3(I);
w = 30; %%discretization factor
A = w*ceil(A/w-eps);
A(A == -180) = 180;
E = w*ceil(E/w-eps);
E(E == -90) = 90;

N = 3;
angles1 = -180:w:180;
angles2 = -90:w:90;
nAngles1 = length(angles1)-1;
nAngles2 = length(angles2)-1;
Entropy1 = zeros(size(I));
Entropy2 = zeros(size(I));
[nRow, nCol, nSli] = size(I);
nVoxel = numel(I);

A = (A-min(angles1))/w;
E = (E-min(angles2))/w;
[R, C, S] = meshgrid(1:size(I,1),1:size(I,2),1:size(I,3));
for i = 1:nVoxel
    r = R(i);
    c = C(i);
    s = S(i);
    startR = r-N;
    endR = r+N;
    startC = c-N;
    endC = c+N;
    startS = s-N;
    endS = s+N;
    if (startR < 1)
        startR = r;
    end
    if (endR > nRow)
        endR = nRow;
    end
    if (startC < 1)
        startC = c;
    end
    if (endC > nCol)
        endC = nCol;
    end
    if (startS < 1)
        startS = s;
    end
    if (endS > nSli)
        endS = nSli;
    end
    q1 = A(startR:endR, startC:endC, startS:endS);
    q2 = E(startR:endR, startC:endC, startS:endS);
    h = histcounts(q1);
    M1 = h'*h;
    h = histcounts(q2);
    M2 = h'*h;
    nq = numel(q1);
%     q1 = reshape(q1, [nq 1]);
%     q2 = reshape(q2, [nq 1]);
%     temp1 = repmat(q1', [nq 1]);
%     temp1 = reshape(temp1, [numel(temp1) 1]);
%     temp2 = repmat(q1, [nq 1]);
%     sub = [temp1 temp2];
%     M1 = accumarray(sub, 1, [nAngles1 nAngles1]);
%     temp1 = repmat(q2', [nq 1]);
%     temp1 = reshape(temp1, [numel(temp1) 1]);
%     temp2 = repmat(q2, [nq 1]);
%     sub = [temp1 temp2];
%     M2 = accumarray(sub, 1, [nAngles2 nAngles2]);
    Entropy1(r,c,s) = entropy(M1/nq);
    Entropy2(r,c,s) = entropy(M2/nq);
end