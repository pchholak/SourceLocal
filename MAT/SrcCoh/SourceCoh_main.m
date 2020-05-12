xxx

% Given
subj_indices = 13:17;
f = 120/9;
info.root_to_stripped = ['/home/anakin/Research/Results/', ...
    'SourceLocal/StripTrials'];
info.res_path_coh = ['/home/anakin/Research/Results/', ...
    'SourceLocal/Coherence'];

tic
for iSubj=subj_indices
    info.name = sprintf('sub%02d', iSubj);
    SourceCoh_cond(info, 'B', f)
    SourceCoh_cond(info, 'F', f)
end
toc