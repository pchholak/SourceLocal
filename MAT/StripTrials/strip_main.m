close all
clear
clc

% Given
<<<<<<< HEAD
subj_indices = 1:17;
info.root = '/home/anakin/brainstorm_db/Perception/data';
info.root_to_stripped = '/home/anakin/research/results/perception/StripTrials';
=======
subj_indices = 2:17;
info.root = '/home/rommel/brainstorm_db/Perception/data';
info.root_to_stripped = '/home/rommel/research/results/perception/StripTrials';
>>>>>>> 7245d0715878c053f601763f29fa5a837677b386

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
