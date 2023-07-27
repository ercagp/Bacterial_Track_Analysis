%% Overlay average speed vs. time plots
% for the time experiment on motility of KMT9 & KMT9F 
% 1-) Recall the combined data and take the average of all bugs in all
% acquisitions
% 2-) Calculate the standard error of the mean by standard deviation of the
% speed dist / sqrt(number of trajectories) 
clearvars;
close all;

%% Define the path and load data
Main_Path = 'Z:\Data\3D_Tracking_Data_Analysis'; 
Video_Date = '20191018';
Main_Path = fullfile(Main_Path,Video_Date); 
%Keyword to find the files associated with the strain label
Strain_Keyword = {'KMT9_GLu_5mM','KMT9_GLu_30mM','KMT9_MMVFv3'};
Strain_Labels = Strain_Keyword;
%Keyword to find the folder associated with the strain label
%Strain_Folder_Keyword = {'KMT9_+\w','KMT9F_+\w'};
BugStruct_Keyword = 'CombinedBugStruct';

for KMT_i = 1:length(Strain_Keyword)
%Retrieve the file list  
Files = getallfilenames(Main_Path,'off');
%Eliminate the files that are not labelled as the indicated strain name
Files = Files(contains(Files,Strain_Keyword{KMT_i})); 
%Find the combined Bugstruct
Files = Files(contains(Files,BugStruct_Keyword)); 

%Create export paths and load the data 
Main_Export_Path = 'Z:\Data\3D_Tracking_Data_Analysis';

i_max = length(Files);
%Preallocation 
axisText = cell(i_max); 
avgV = zeros(1,i_max); 
stdAllV = zeros(1,i_max);
semAvgV = zeros(1,i_max);
 for i = 1:i_max
     load(Files{i});
     %Get the speed statistics
     SpeedStats = SpeedStatistics(CB);
     %Retrieve all V 
     allV = cell2mat(SpeedStats.allV);
     %Take the mean of all velocities for all bugs in all acq. 
     avgV(i) = mean(allV); 
     %Get the standard deviation of the speed set 
     stdAllV(i) = std(allV);
     %Get the standard error 
     semAvgV(i) = SEMV(CB); %stdAllV(i)./sqrt(length(SpeedStats.allV));
 end

timeVec = [0 90]; %mins. 
%% Plotting average speed vs. time 
hf_1 = figure(1);

err{KMT_i} = errorbar(timeVec, avgV, semAvgV,'.-');
hold on 
%pl{KMT_i} = plot(timeVec, avgV,'-');

%Save variables 
%avgV - Standard error of the mean(semAvgV) 
save(fullfile(Main_Export_Path,Video_Date,['avgV_' Strain_Labels{KMT_i}]),'avgV','semAvgV','timeVec');

end

%Error bar Style 
err{1}.LineWidth = 1.5;
err{2}.LineWidth = 1.5;
err{3}.LineWidth = 1.5;
err{1}.MarkerSize = 15; 
err{2}.MarkerSize = 15; 
err{3}.MarkerSize = 15; 
% err_1.Color = [0 0 1]; 


ax = gca; 
ax.XLim = [-5 95]; 
ax.YLim = [0 50];
ax.XAxis.Label.String = 'Time (mins)';
ax.YAxis.Label.String = '<V> (\mum/s)';
ax.Title.String = {['KMT9 (' num2str(Video_Date) ')'], 'Whole Population'};
ax.Title.Interpreter = 'none'; 

%Legend 
lg_1 = legend({'Glu_5mM','Glu_30mM','MMVF_v3'},'Location','Best');%legend(Strain_Labels,'Location','Best');
lg_1.Interpreter = 'none';

%General Style 
ErcagGraphics
settightplot(ax)

%% Save figures in PDF, FIG and PNG formats 
printfig(hf_1,fullfile(Main_Export_Path,Video_Date, 'KMT9_MMVFv3Test_AverageSpeedvsTime'),'-dpng')
printfig(hf_1,fullfile(Main_Export_Path,Video_Date, 'KMT9_MMVFv3Test_AverageSpeedvsTime'),'-dpdf')
savefig(hf_1,fullfile(Main_Export_Path,Video_Date, 'KMT9_MMVFv3Test_AverageSpeedvsTime'))

   