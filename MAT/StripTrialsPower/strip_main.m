close all
clear
clc

% Given
subj_indices = 1:17;
info.root = '/home/username/brainstorm_db/Perception/data';
info.root_to_stripped = ['/home/username/research/results/perception/', ...
    'StripTrialsPower'];

% Loop over each subject and 'B'/'F' trials
for iSubj=subj_indices
    info.name = sprintf('sub%02d', iSubj);
    if strcmp(info.name, 'sub08')
        info.folder = 'run_tsss_1_notch';
        strip_trials(info, 'B', 1)
        info.folder = 'run_tsss_2_notch';
        strip_trials(info, 'F')
    else
        info.folder = 'run_tsss_notch';
        strip_trials(info, 'B', 1)
        strip_trials(info, 'F')
    end
end
