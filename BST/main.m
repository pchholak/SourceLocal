%% ============================ Initial setup ============================
xxx
% Start brainstorm, if not open already
if ~brainstorm('status')
    brainstorm nogui
end
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'Perception';

Subjects = 13:17;
data_dir = '/home/wilson/data/perception/';
reports_dir = '/home/wilson/research/results/perception/';
fname_raw = 'run_tsss.fif';
fname_empty = 'emptyroom_tsss.fif';
fname_event = 'events_MarkerFile-bst.mat';

SubjectNames = {}; RawFiles = {}; NoiseFiles = {}; RawEventFiles = {};
for iSubj=Subjects
    name = sprintf('sub%02d', iSubj);
    SubjectNames{end+1} = name;
    NoiseFiles{end+1} = [data_dir, name, '/', fname_empty];
    if strcmp(name, 'sub08')
        RawFiles{end+1} = { ...
            [data_dir, name, '/', 'run_tsss_1.fif'], ...
            [data_dir, name, '/', 'run_tsss_2.fif']};
        RawEventFiles{end+1} = { ...
            [data_dir, name, '/', 'events_MarkerFile-bst_1.mat'], ...
            [data_dir, name, '/', 'events_MarkerFile-bst_2.mat']};
    else
        RawFiles{end+1} = [data_dir, name, '/', fname_raw];
        RawEventFiles{end+1} = [data_dir, name, '/', fname_event];
    end
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

    if strcmp(SubjectNames{iSubj}, 'sub08')
        sFiles = script_pre_sub8(SubjectNames, RawFiles, NoiseFiles, RawEventFiles, iSubj);
    else
        sFiles = script_pre(SubjectNames, RawFiles, NoiseFiles, RawEventFiles, iSubj);
    end

    % Save and display report
    ReportFile = bst_report('Save', []);
    if ~isempty(reports_dir) && ~isempty(ReportFile)
        bst_report('Export', ReportFile, bst_fullfile(reports_dir, ...
            ['report_' ProtocolName '_' SubjectNames{iSubj} '.html']));
    end
end

%% =================== Compute head model and sources ====================
% Start display report for all subjects
bst_report('Start');
for iSubj=1:length(SubjectNames)
    sFilesNoise = script_post(SubjectNames, iSubj);
end
ReportFile = bst_report('Save', []);
if ~isempty(reports_dir) && ~isempty(ReportFile)
    bst_report('Export', ReportFile, bst_fullfile(reports_dir, ...
        ['report_' ProtocolName '_' SubjectNames{iSubj} '.html']));
end

%% ============================= Open report =============================
% Save and display report
bst_report('Open', ReportFile);
