function P = SpecDiff_sub(info, keywd)

% Locate and list .mat files
fmatF = dir([info.res_path_power, '/', keywd, '*_' info.name '_F.mat']);
fmatB = dir([info.res_path_power, '/', keywd, '*_' info.name '_B.mat']);

% Load files, average and take difference
load([info.res_path_power, '/', fmatF(1).name], 'src'); clear fmatF
srcF = mean(src(info.scout_vert, :), 2);
load([info.res_path_power, '/', fmatB(1).name], 'src'); clear fmatB
srcB = mean(src(info.scout_vert, :), 2);

% Evaluate normalized difference of power (P)
P = (srcF - srcB) ./ srcB;
