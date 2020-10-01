%% ============================ Initial setup ============================
xxx
% Start brainstorm, if not open already
if ~brainstorm('status')
    brainstorm nogui
end
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'Test';

Subjects = 10;
data_dir = '/home/wilson/data/perception/';
reports_dir = '/home/wilson/research/results/perception/';
fname_raw = 'run_tsss.fif';
fname_empty = 'emptyroom_tsss.fif';
fname_event = 'events_MarkerFile-bst.mat';

SubjectNames = {}; RawFiles = {}; NoiseFiles = {}; RawEventFiles = {};
for iSubj=Subjects
    name = sprintf('sub%02d', iSubj);
    SubjectNames{end+1} = name;
    NoiseFiles{end+1} = fullfile(data_dir, name, fname_empty);
    RawFiles{end+1} = fullfile(data_dir, name, fname_raw);
    RawEventFiles{end+1} = fullfile(data_dir, name, fname_event);
end

%% ============ Load raw files, preprocess and import epochs ===================
iSubj = 1;
% Start display report for each subject
bst_report('Start');

% If subject already exists: delete it
[sSubject, iSubject] = bst_get('Subject', SubjectNames{iSubj});
if ~isempty(sSubject)
    db_delete_subjects(iSubject);
end

% Process: Create link to raw file
sFilesRun = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',    SubjectNames{iSubj}, ...
    'datafile',       {RawFiles{iSubj}, 'FIF'}, ...
    'channelreplace', 1, ...
    'channelalign',   1, ...
    'evtmode',        'value');

% Process: Create link to raw file
sFilesNoise = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',    SubjectNames{iSubj}, ...
    'datafile',       {NoiseFiles{iSubj}, 'FIF'}, ...
    'channelreplace', 1, ...
    'channelalign',   1, ...
    'evtmode',        'value');

% Process: Import events from file
bst_process('CallProcess', 'process_evt_import', sFilesRun, [], ...
    'evtfile', {RawEventFiles{iSubj}, 'BST'}, ...
    'evtname', 'New');

% Process: Notch filter: 50Hz 100Hz 150Hz    
sFilesRaw = [sFilesRun, sFilesNoise];
sFilesNotch = bst_process('CallProcess', 'process_notch', sFilesRaw, [], ...
    'sensortypes', 'MEG, EEG', ...
    'freqlist',    [50, 100, 150], ...
    'cutoffW',     1, ...
    'useold',      0, ...
    'read_all',    0);
