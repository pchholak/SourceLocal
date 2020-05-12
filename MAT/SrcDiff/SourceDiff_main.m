xxx

% Given
exc = [8, 11];
subj_indices = 1:17; nsub = length(subj_indices);
info.res_path_coh = '/home/anakin/Research/Results/SourceLocal/Coherence';
keywd = 'Coh(120by3s)';
fscouts = '/home/anakin/Research/Results/SourceLocal/scout_V1_V2.mat'; 
K = [4.0807, 4.4821, 4.0067, 3.9300, 2.7739, 2.5521, 2.8468, 3.4994, ...
    3.1721, 2.9328, 3.0600, 4.0513, 2.8507, 3.6662, 3.2144, 3.2878, 2.7215];
N = 1./K;
label_gap = .005;

% Load scout vertices
load(fscouts)
nscouts = length(Scouts);
V = [];
for p=1:nscouts
    V = [V, Scouts(p).Vertices];
end
info.scout_vert = V;

% Absolute difference in coherence of areas marked by vertices V
names = cell(1, nsub);
ACm = zeros(1, nsub); Cm = ACm;
for iSubj=subj_indices
    names{iSubj} = num2str(iSubj);
    info.name = sprintf('sub%02d', iSubj);
    [AC, C] = SourceDiff_sub(info, keywd);
    ACm(iSubj) = mean(AC);
    Cm(iSubj) = mean(C);
end
    
%% Visualise
figure
custom_scatter(N, Cm, exc, label_gap, names);
xlabel('Noise'), ylabel('C_v')
grid
set(gca, 'FontSize', 14)

% figure
% [~, lm] = custom_scatter(log(K), log(ACm), exc, label_gap, names);
% bfl = lm.Coefficients.Estimate; slp = bfl(2);
% text(.62, .85, sprintf('Slope = %0.4f', slp), 'Units', 'normalized', ...
%     'FontSize', 14)
% xlabel('Log(K)'), ylabel('Log(C_v)')
% grid
% set(gca, 'FontSize', 14)