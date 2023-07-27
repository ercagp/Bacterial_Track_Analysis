%Weighted Mean for Individual Acquisitions
%by Ercag
%February 2019 
clearvars; 
close all; 
%% Define the path and load data
Main_Path = 'Z:\Data\3D_Tracking_Data'; 
Video_Date = '20190522';
Strain_Label = 'KMT9';
Label_Ext = '_OD_0.56';
Sample_Label = [Strain_Label Label_Ext] ;
Extra_SubFolder = '';
ROI = 'ROI_2'; %Region of Interest
Track_Label = '20190525_Tracking';
Folder =  fullfile(Main_Path,Video_Date,Sample_Label,Extra_SubFolder,...
         ROI,Track_Label);
%Define the lambda value of ADMM; 
lambda = 1; 

%Find the list specifically contains the ADMM label
list_final = findlist(Folder,lambda);

%Define Export Path 
Export_Path = 'Z:\Data\3D_Tracking_Data_Analysis';
Export_Folder = fullfile(Export_Path,Video_Date,Sample_Label,Extra_SubFolder,ROI,Track_Label,['lambda_' num2str(lambda)]);
%Make Export Path 
mkdir(Export_Folder);

%List the smoothed trajectory file with a specific lambda value
FileName = list_final.name; 
load(fullfile(Folder,FileName))

%% Carry the speed statistics 
%Create the structure containing speed info 
S.Speeds = B_Smooth.Speeds;
S.Parameters = B_Smooth.Parameters;
%Get the speed statistics
SpeedStats = SpeedStatistics(S); 

%% Figures
%Edge vector for all histograms 
Edges = 0:5:200; 
%Mean Speed Distribution 
hf_1 = figure; 
histogram(SpeedStats.meanV,Edges,'Normalization','pdf'); 
title({[Strain_Label ' ' Label_Ext(2:end) ' - ' ROI],'Mean Speed Distribution'},'interpreter','none')
ax_h1 = gca;
%Set Axes Titles
ax_h1.XLabel.String = 'Speed(\mum/s)';
ax_h1.YLabel.String = 'PDF';
%Adjust style 
ErcagGraphics
settightplot(ax_h1)
%Save the figure to the target(i.e. export) folder 
printfig(hf_1,[Export_Folder filesep Sample_Label '_MeanSpeedDist.pdf'],'-dpdf')

%All Speed Distribution 
hf_2 = figure;
all_V = cell2mat(SpeedStats.allV);
histogram(all_V,Edges,'Normalization','pdf'); 
%Set Title
title({[Strain_Label ' ' Label_Ext(2:end) ' - ' ROI],'Speed Distribution'},'interpreter','none')
ax_h2 = gca;
%Set Axes Titles
ax_h2.XLabel.String = 'Speed(\mum/s)';
ax_h2.YLabel.String = 'PDF';
%Adjust style 
ErcagGraphics
settightplot(ax_h2)
%Save the figure to the target(i.e. export) folder 
printfig(hf_2,[Export_Folder filesep Sample_Label '_AllSpeedDist.pdf'],'-dpdf')

%% Functions within 
function list_final = findlist(Folder,lambda)
%Flag for the decision if the file is raw or trend filtered
raw_flag = ismember(0,lambda);

list_mat = dir([Folder filesep '*.mat']); 
%Find the list of trend filtered files 
new_list_handle = cellfun(@(x) contains(x,'ADMM'),{list_mat.name});
list_mat_ADMM = list_mat(new_list_handle); 
%Find the list of raw files
list_mat_raw = list_mat(~new_list_handle); 

    if raw_flag
    list_final = list_mat_raw;
    else
    %Find the file having a specific lambda number
    final_handle = cellfun(@(x) contains(x,['Lambda_' num2str(lambda)]),{list_mat_ADMM.name});
    list_final = list_mat_ADMM(final_handle);
    end
end

