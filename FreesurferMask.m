function FSMask = FreesurferMask(ID)
FSMask = [];
%% Brain
Segmentation = readFreesurferNII(ID, 'Aseg'); % Read Aseg for GM and WM
FSMask = defineRTContour(Segmentation, 'Brain', FSMask);

%% Cerebellum
Segmentation = defineCerebellum(Segmentation);
FSMask = defineRTContour(Segmentation, 'Cerebellum', FSMask);

%% Grey Matter Parcellation
Segmentation = readFreesurferNII(ID, 'AparcAseg'); % Read AparcAseg for GMParcellation
FSMask = defineRTContour(Segmentation, 'GMParcellation', FSMask);

%% Grey Matter Lobe
Segmentation = defineLobes(Segmentation, 'GM');
FSMask = defineRTContour(Segmentation, 'GMLobe', FSMask);

%% White Matter Parcellation
Segmentation = readFreesurferNII(ID, 'wmparc'); % Read WMAparc for WMParcellation
FSMask = defineRTContour(Segmentation, 'WMParcellation', FSMask);

%% White Matter Lobe
Segmentation = defineLobes(Segmentation, 'WM');
FSMask = defineRTContour(Segmentation, 'WMLobe', FSMask);

FSMask = groupMasks(FSMask);
FSMask = orderfields(FSMask);

function FSMask = groupMasks(FSMask)
names = {'FrontalLobe' 'ParietalLobe' 'TemporalLobe' 'OccipitalLobe'};
nNames = length(names);
for i = 1:nNames
    name = char(names(i));
    GreyMatterName = [name 'GreyMatter'];
    WhiteMatterName = [name 'WhiteMatter'];
    FSMask.(name).Image = FSMask.(GreyMatterName).Image | FSMask.(WhiteMatterName).Image;
end

function Seg = defineCerebellum(Seg)
temp = Seg;
temp(temp == 7) = 1001; temp(temp == 8) = 1001; temp(temp == 46) = 1001; temp(temp == 47) = 1001;
Seg = temp;

function Seg = defineLobes(Seg, type)
temp = Seg;
switch type
    case 'GM'
        %% Frontal
        temp(temp == 1026) = 101; temp(temp == 1027) = 101; temp(temp == 1028) = 101; temp(temp == 1003) = 101; temp(temp == 1018) = 101;
        temp(temp == 1020) = 101; temp(temp == 1019) = 101; temp(temp == 1012) = 101; temp(temp == 1014) = 101; temp(temp == 1024) = 101;
        temp(temp == 1017) = 101; temp(temp == 1032) = 101; temp(temp == 1002) = 101;
        
        temp(temp == 2026) = 101; temp(temp == 2027) = 101; temp(temp == 2028) = 101; temp(temp == 2003) = 101; temp(temp == 2018) = 101;
        temp(temp == 2020) = 101; temp(temp == 2019) = 101; temp(temp == 2012) = 101; temp(temp == 2014) = 101; temp(temp == 2024) = 101;
        temp(temp == 2017) = 101; temp(temp == 2032) = 101; temp(temp == 2002) = 101;
        %% Parietal
        temp(temp == 1029) = 102; temp(temp == 1008) = 102; temp(temp == 1031) = 102; temp(temp == 1022) = 102; temp(temp == 1025) = 102;
        temp(temp == 1010) = 102; temp(temp == 1023) = 102;
        
        temp(temp == 2029) = 102; temp(temp == 2008) = 102; temp(temp == 2031) = 102; temp(temp == 2022) = 102; temp(temp == 2025) = 102;
        temp(temp == 2010) = 102; temp(temp == 2023) = 102;
        %% Temporal
        temp(temp == 1030) = 103; temp(temp == 1015) = 103; temp(temp == 1009) = 103; temp(temp == 1001) = 103; temp(temp == 1007) = 103;
        temp(temp == 1034) = 103; temp(temp == 1006) = 103; temp(temp == 1033) = 103; temp(temp == 1016) = 103; temp(temp == 1035) = 103;
        
        temp(temp == 2030) = 103; temp(temp == 2015) = 103; temp(temp == 2009) = 103; temp(temp == 2001) = 103; temp(temp == 2007) = 103;
        temp(temp == 2034) = 103; temp(temp == 2006) = 103; temp(temp == 2033) = 103; temp(temp == 2016) = 103; temp(temp == 2035) = 103;
        
        temp(temp == 17) = 103; temp(temp == 18) = 103; temp(temp == 53) = 103; temp(temp == 54) = 103; % Amygdala & Hippocampus
        %% Occipital
        temp(temp == 1011) = 104; temp(temp == 1013) = 104; temp(temp == 1005) = 104; temp(temp == 1021) = 104;
        temp(temp == 2011) = 104; temp(temp == 2013) = 104; temp(temp == 2005) = 104; temp(temp == 2021) = 104;
    case 'WM'
        %% Frontal
        temp(temp == 3026) = 201; temp(temp == 3027) = 201; temp(temp == 3028) = 201; temp(temp == 3003) = 201; temp(temp == 3018) = 201;
        temp(temp == 3020) = 201; temp(temp == 3019) = 201; temp(temp == 3012) = 201; temp(temp == 3014) = 201; temp(temp == 3024) = 201;
        temp(temp == 3017) = 201; temp(temp == 3032) = 201; temp(temp == 3002) = 201;
        
        temp(temp == 4026) = 201; temp(temp == 4027) = 201; temp(temp == 4028) = 201; temp(temp == 4003) = 201; temp(temp == 4018) = 201;
        temp(temp == 4020) = 201; temp(temp == 4019) = 201; temp(temp == 4012) = 201; temp(temp == 4014) = 201; temp(temp == 4024) = 201;
        temp(temp == 4017) = 201; temp(temp == 4032) = 201; temp(temp == 4002) = 201;
        %% Parietal
        temp(temp == 4029) = 202; temp(temp == 4008) = 202; temp(temp == 4031) = 202; temp(temp == 4022) = 202; temp(temp == 4025) = 202;
        temp(temp == 4010) = 202; temp(temp == 4023) = 202;
        
        temp(temp == 3029) = 202; temp(temp == 3008) = 202; temp(temp == 3031) = 202; temp(temp == 3022) = 202; temp(temp == 3025) = 202;
        temp(temp == 3010) = 202; temp(temp == 3023) = 202;
        %% Temporal
        temp(temp == 3030) = 203; temp(temp == 3015) = 203; temp(temp == 3009) = 203; temp(temp == 3001) = 203; temp(temp == 3007) = 203;
        temp(temp == 3034) = 203; temp(temp == 3006) = 203; temp(temp == 3033) = 203; temp(temp == 3016) = 203; temp(temp == 3035) = 203;        
        
        temp(temp == 4030) = 203; temp(temp == 4015) = 203; temp(temp == 4009) = 203; temp(temp == 4001) = 203; temp(temp == 4007) = 203;
        temp(temp == 4034) = 203; temp(temp == 4006) = 203; temp(temp == 4033) = 203; temp(temp == 4016) = 203; temp(temp == 4035) = 203;
        temp(temp == 3034) = 203; temp(temp == 3006) = 203;        

        %% Occipital
        temp(temp == 3011) = 204; temp(temp == 3013) = 204; temp(temp == 3005) = 204; temp(temp == 3021) = 204;
        temp(temp == 4011) = 204; temp(temp == 4013) = 204; temp(temp == 4005) = 204; temp(temp == 4021) = 204;
end
Seg = temp;

function FSMask = defineRTContour(Seg, type, FSMask)
Seg = uint16(Seg);
switch type
    case 'Brain'
        load LookUpTableBrain.mat
    case 'GMParcellation'
        load LookUpTableGM.mat
    case 'GMLobe'
        load LookUpTableGMLobe.mat
    case 'WMParcellation'
        load LookUpTableWM.mat
    case 'WMLobe'
        load LookUpTableWMLobe.mat
    case 'Cerebellum'
        load LookUpTableCerebellum.mat
end
FSMask = readFreesurferMask(Seg, LUT, FSMask);

function FSMask = readFreesurferMask(Seg, LUT, FSMask)
nTissue = size(LUT,2);
for i = 1:nTissue
    Volume = Seg == LUT(i).Label;
    name = char(LUT(i).Name);
    FSMask.(name).Image = Volume;    
end

function I = readFreesurferNII(ID, part)
filename = ['Freesurfer/' ID '.' part '.nii'];
I = nii_read_volume(nii_read_header(filename));
I = permute(I, [3 1 2]);
I = flip(I,1);