function Pm = SpectralPower_cond(info, cond)

% Given
Fs = 1000; lcut = 13; hcut = 14;

% Estimate trial data size
sprintf('Estimating trial data size...')
path = fullfile(info.root_to_stripped, info.name);
files_cond = dir([path, '/*_', cond, '_*.mat']);
n_files = length(files_cond);

% Extract time 't' from the first trial and Kernel 'K'
load([path, '/', files_cond(1).name], 'Time'); t = Time;
kernel_file = dir([path, '/*_KERNEL_*.mat']);
load([path, '/', kernel_file.name], 'K')
[nV, nch] = size(K);

% Loop over each trial
P = zeros(nV, n_files);
for q=1:n_files
    sprintf('Loading file %d out of %d files', q, n_files)
    load([path, '/', files_cond(q).name], 'F')
    X = F(1:nch, :); % Already demeaned by Brainstorm
    % Bandpass filtering [13,14]-Hz
    X = bpass(X, Fs, lcut, hcut);
    % Calculate time series at each vertex
    sprintf('Calculating time series in source space...')
    S = X'*K';
    % Evaluate signal power at each vertex
    sprintf('Calculating Power in source space...')
    P(:, q) = (rms(S).^2)';
end
Pm = mean(P, 2);

% Visualise
figure
hist(Pm)

%% Write results
src = P;
fname = sprintf('Pow(120by3s)_%0.1f-%0.1fHz_%s_%s.mat', lcut, hcut, ...
    info.name, cond);
fpath = [info.res_path_power, '/', fname];
save(fpath, 'src')
