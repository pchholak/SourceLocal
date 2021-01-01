close all
clear
clc

% Given
subj_indices = 1:17;
info.root_to_stripped = '/home/username/research/results/perception/StripTrialsPower';
info.res_path_power = '/home/username/research/results/perception/Power';

for iSubj=subj_indices
    info.name = sprintf('sub%02d', iSubj);
    SpectralPower_cond(info, 'B');
    SpectralPower_cond(info, 'F');
end
