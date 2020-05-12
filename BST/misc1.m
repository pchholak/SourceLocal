xxx
% Start brainstorm, if not open already
if ~brainstorm('status')
    brainstorm nogui
end
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'Perception';

Subjects = 11;
data_dir = '/home/anakin/Data/MEG/Perception/';
reports_dir = '/home/anakin/Research/Results/';
fname_raw = 'run_tsss.fif';
fname_empty = 'emptyroom_tsss.fif';
fname_event = 'events_MarkerFile-bst.mat';

SubjectNames = {}; RawFiles = {}; NoiseFiles = {}; RawEventFiles = {};
for iSubj=Subjects
    name = sprintf('sub%02d', iSubj);
    SubjectNames{end+1} = name;
    NoiseFiles{end+1} = [data_dir, name, '/', fname_empty];
    RawFiles{end+1} = [data_dir, name, '/', fname_raw];
    RawEventFiles{end+1} = [data_dir, name, '/', fname_event];
end

%% ============ Load raw files, preprocess and import epochs =============
for iSubj=1:length(SubjectNames)
    % Start display report for each subject
    bst_report('Start');
    
    % If subject already exists: delete it
    [sSubject, iSubject] = bst_get('Subject', SubjectNames{iSubj});
    if ~isempty(sSubject)
        db_delete_subjects(iSubject);
    end

    sFiles = script_pre(SubjectNames, RawFiles, NoiseFiles, RawEventFiles, iSubj);
    
    % Save and display report
    ReportFile = bst_report('Save', []);
    if ~isempty(reports_dir) && ~isempty(ReportFile)
        bst_report('Export', ReportFile, bst_fullfile(reports_dir, ...
            ['report_' ProtocolName '_' SubjectNames{iSubj} '.html']));
    end
end

%% ============================= Open report =============================
% Display report
bst_report('Open', ReportFile);