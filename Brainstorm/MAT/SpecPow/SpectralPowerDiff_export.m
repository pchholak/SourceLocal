% The program should be started after clearing the workspace and exporting
% the Test source time average file as 'xyz' and changing 'sub'

%% Given
sub = 5;
info.res_path_power = '/home/username/research/results/perception/Power/';
keywd = 'Pow(120by4s)';

%% Locate and list .mat files
fmatF = dir([info.res_path_power, keywd, '*_sub', sprintf('%02d',sub), '_F.mat']);
fmatB = dir([info.res_path_power, keywd, '*_sub', sprintf('%02d',sub), '_B.mat']);

%% Load files, average and take difference
load([info.res_path_power, fmatF(1).name]); clear fmatF
srcF = mean(src, 2);
load([info.res_path_power, fmatB(1).name]); clear fmatB
srcB = mean(src, 2);
D = (srcF-srcB)./srcB; img = [D, D];

%% Prepare to export
xyz.ImageGridAmp = img;
xyz.Comment = ['Diff_' keywd '_sub' sprintf('%02d',sub)];
clear info
