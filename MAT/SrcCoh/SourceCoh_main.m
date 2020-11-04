close all
clear
clc

% Given
subj_indices = 1:17;
f = 120/9;
info.root_to_stripped = '/home/rommel/research/results/perception/StripTrials';
info.res_path_coh = '/home/rommel/research/results/perception/Coherence';

tic
for iSubj=subj_indices
    info.name = sprintf('sub%02d', iSubj);
    SourceCoh_cond(info, 'B', f)
    SourceCoh_cond(info, 'F', f)
end
toc
