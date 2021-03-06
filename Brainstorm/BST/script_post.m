function sSrcMeg = script_post(SubjectNames, iSubj)

% Process: Select data files in: */*
sFiles = bst_process('CallProcess', 'process_select_files_data', [], [], ...
    'subjectname',   SubjectNames{iSubj});

% Process: Compute head model
bst_process('CallProcess', 'process_headmodel', sFiles(1), [], ...
    'comment',      '', ...
    'sourcespace',  1, ...
    'meg',          3);  % Overlapping spheres

% Get all the runs for this subject (ie the list of the study indices)
iStudyOther = setdiff(unique([sFiles.iStudy]), sFiles(1).iStudy);
% Copy the forward model file to the other runs
sHeadmodel = bst_get('HeadModelForStudy', sFiles(1).iStudy);
for iStudy = iStudyOther
    db_add(iStudy, sHeadmodel.FileName);
end

% Process: Compute sources [2018]
sSrcMeg = bst_process('CallProcess', 'process_inverse_2018', sFiles, [], ...
    'output',  1, ...  % Kernel only: shared
    'inverse', struct(...
         'Comment',        'MN: MEG ALL', ...
         'InverseMethod',  'minnorm', ...
         'InverseMeasure', 'amplitude', ...
         'SourceOrient',   {{'fixed'}}, ...
         'Loose',          0.2, ...
         'UseDepth',       1, ...
         'WeightExp',      0.5, ...
         'WeightLimit',    10, ...
         'NoiseMethod',    'reg', ...
         'NoiseReg',       0.1, ...
         'SnrMethod',      'fixed', ...
         'SnrRms',         1e-06, ...
         'SnrFixed',       3, ...
         'ComputeKernel',  1, ...
         'DataTypes',      {{'MEG'}}));