close all
clear
clc

% Given
subj_indices = 1:17;
% info.root_to_stripped = '/home/rommel/research/results/perception/StripTrials';
% info.res_path_power = '/home/rommel/research/results/perception/Power';
% info.root_to_stripped = '/home/wilson/research/results/src_local/StripTrials';
% info.res_path_power = '/home/wilson/research/results/src_local/Power';
info.root_to_stripped = '/home/anakin/research/results/perception/StripTrialsPower';
info.res_path_power = '/home/anakin/research/results/perception/Power';

for iSubj=subj_indices
    info.name = sprintf('sub%02d', iSubj);
    SpectralPower_cond(info, 'B');
    SpectralPower_cond(info, 'F');
end
