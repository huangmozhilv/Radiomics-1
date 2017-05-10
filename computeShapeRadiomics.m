function Radiomics = computeShapeRadiomics(Stats)
shp = alphaShape(Stats.PixelList);
V = shp.volume;
A = shp.surfaceArea;

V = V*Stats.VoxelResolution(1)*Stats.VoxelResolution(2)*Stats.VoxelResolution(3);
A = A*(Stats.VoxelResolution(1)^2*Stats.VoxelResolution(2)^2*Stats.VoxelResolution(3)^2)^(1/3);
Radiomics.SurfaceVolumeRatio = A/V;
Radiomics.Compactness1 = V/sqrt(pi)/A^(2/3);
Radiomics.Compactness2 = 36*pi*V*V/A/A/A;
R = (V*3/4/pi)^(1/3);
Radiomics.SphericalDisproportion = A/4/pi/R/R;
Radiomics.Sphericity = pi^(1/3)*(6*V)^(2/3)/A;
Radiomics.VolumeML = V*1e-3; %mL
Radiomics.SurfaceArea = A*1e-2; %cm^2

%% Centroid Information 
% Radiomics.CentroidX = Stats.Centroid(1);
% Radiomics.CentroidY = Stats.Centroid(2);
% Radiomics.CentroidZ = Stats.Centroid(3);
% Radiomics.Classification = Stats.Classification;

%% Major Axis and MAximum Diameter Information
% nVoxels = size(Stats.PixelList,1);
% Radiomics.MaximumDiameter = 0;
% Radiomics.MajorAxisX = 0;
% Radiomics.MajorAxisY = 0;
% Radiomics.MajorAxisZ = 0;
% for i = 1:nVoxels
%     D = 2*norm(Stats.Centroid-Stats.PixelList(i));
%     if D > Radiomics.MaximumDiameter
%         Radiomics.MaximumDiameter = D; %%Check
%         Radiomics.MajorAxisX = Stats.PixelList(i,1)-Radiomics.CentroidX;
%         Radiomics.MajorAxisY = Stats.PixelList(i,2)-Radiomics.CentroidY;
%         Radiomics.MajorAxisZ = Stats.PixelList(i,3)-Radiomics.CentroidZ;
%     end
% end
% Radiomics.MaximumDiameter = Radiomics.MaximumDiameter*sqrt(Stats.VoxelResolution(1)^2+Stats.VoxelResolution(2)^2+Stats.VoxelResolution(3)^2);

