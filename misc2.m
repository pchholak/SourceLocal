%% ============================ Initial setup ============================
xxx
% Start brainstorm, if not open already
if ~brainstorm('status')
    brainstorm nogui
end
% The protocol name has to be a valid folder name
ProtocolName = 'Perception';

% Input files
SubjectNames = {'sub08'};
RawFiles = {...
    '/home/anakin/Data/MEG/Perception/sub08/run_tsss_1.fif'};
NoiseFiles = {...
    '/home/anakin/Data/MEG/Perception/sub08/emptyroom_tsss.fif'};
RawEventFiles = {...
    '/home/anakin/Data/MEG/Perception/sub08/events_MarkerFile-bst_1.mat'};

%% =================== Compute head model and sources ====================
% Start display report for all subjects
bst_report('Start');
for iSubj=1:length(SubjectNames)
    sFiles = script2(SubjectNames, iSubj);
end

%% ============================ Final report =============================
% Save and display report
ReportFile = bst_report('Save', []);
bst_report('Open', ReportFile);