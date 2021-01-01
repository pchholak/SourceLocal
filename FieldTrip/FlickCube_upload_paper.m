ft_defaults

%% Load input MEG data
fname='Data\subj1.fif';
load Data\events_sub1;

%% Load MRI data
load segmentedmri;
mri = ft_read_mri('Subject01.mri');

%% Align template MRI to the subject headshape (from MEG experiment)
headshape=ft_read_headshape(fname);
headshape = ft_convert_units(headshape,'mm');
lpa    = [29 145 155];
nas    = [87 60 116];
rpa    = [144 142 158];
  
cfg                 = [];
cfg.method          = 'fiducial';
cfg.fiducial.nas    = nas;
cfg.fiducial.lpa    = lpa;
cfg.fiducial.rpa    = rpa;
cfg.coordsys        = 'neuromag';
mri_realigned      = ft_volumerealign(cfg,mri);

cfg=[];
cfg.method = 'headshape';
cfg.headshape.headshape=headshape;
cfg.headshape.interactive='no';
cfg.headshape.icp='yes';
cfg.coordsys='neuromag';
mri_headshape=ft_volumerealign(cfg, mri_realigned);

T_neuromag = mri_headshape.transform;
segmentedmri.transform = T_neuromag;
segmentedmri.coordsys = 'neuromag';

%% Prepare head model
cfg = [];
cfg.method='singleshell';
headmodel = ft_prepare_headmodel(cfg, segmentedmri);
headmodel = ft_convert_units(headmodel,'cm');

for Ftrial=1:3   % 3 input F- and B-trials
%% Prepare input sub-trials
deltaT=4000;
f1=13;
f2=14;
t1=events(2).times(Ftrial)*1000;
t2=(events(2).times(Ftrial)+120)*1000;
tB=events(1).times(1)*1000;
df=1;

cfg = [];                                          
cfg.dataset                 = fname;     
cfg.trialfun             = 'ft_trialfun_general';
cfg.trialdef.triallength = deltaT/1000;                     
cfg.trialdef.ntrials     = 1;                   
cfg                      = ft_definetrial(cfg);

cfg.demean = 'yes';
cfg.bpfilter = 'yes';
cfg.bpfreq        = [f1 f2];
cfg.channel = {'MEG'};

ntrials=0;
Tcur=t1;
while ((Tcur+deltaT)<=t2)
      ntrials=ntrials+1;
      cfg.trl(ntrials,1:4)=[Tcur, Tcur+deltaT, 0, 127];   
      
       if (Ftrial==1)
        trl_Pre(ntrials,1:4)=[tB+(ntrials-1)*deltaT, tB+ntrials*deltaT, 0, 127];
       end;
    
      Tcur=Tcur+deltaT;
end;

data_MEG_Post = ft_preprocessing(cfg);  % Post-stimulus sub-trials

if (Ftrial==1)
    cfg.trl = [];
    cfg.trl = trl_Pre;
    data_MEG_Pre = ft_preprocessing(cfg);  % Pre-stimulus sub-trials
end;

cfg = [];
cfg.toilim = [0.5 3.5];
datapost = ft_redefinetrial(cfg, data_MEG_Post);
if (Ftrial==1)
    datapre = ft_redefinetrial(cfg, data_MEG_Pre);
end;

dataAll = ft_appenddata([], datapre, datapost);  % Pre+Post-stimulus sub-trials

cfg = [];
cfg.covariance = 'yes';
tlock_All = 	ft_timelockanalysis(cfg, dataAll);   % Timelock analysis for all sub-trials

cfg = [];
cfg.covariance = 'yes';
cfg.keeptrials = 'yes';
tlock_post = 	ft_timelockanalysis(cfg, datapost);   % Timelock analysis for post-stimulus sub-trials
if (Ftrial==1)
    tlock_pre = ft_timelockanalysis(cfg, datapre);    % Timelock analysis for pre-stimulus sub-trials
end;

%% Prepare Leadfield for source analysis
if (Ftrial==1)
    cfg         = [];
    cfg.grad    = tlock_post.grad;   % sensor information
    cfg.channel = tlock_post.label;  % the used channels
    cfg.headmodel = headmodel;   % volume conduction model
    cfg.resolution = 0.7;  
    cfg.unit       = 'cm';
    cfg.reducerank = 'no';
    [grid] = ft_prepare_leadfield(cfg);
end;

%% Perform source analysis (using sLORETA) for all data to calculate common filter
cfg=[];
cfg.method='sloreta';
cfg.sourcemodel = grid; 
cfg.grad = tlock_All.grad;
cfg.headmodel=headmodel;
cfg.sloreta.keepfilter='yes';
cfg.sloreta.lambda = '5%';
cfg.channel = tlock_All.label;
cfg.senstype = 'MEG';
cfg.sloreta.reducerank = 'no';
sourceAll=ft_sourceanalysis(cfg, tlock_All);

%% Perform source analysis separately for post- and pre-stimulus data
cfg=[];
cfg.method='sloreta';
cfg.sourcemodel = grid; 
cfg.sourcemodel.filter=sourceAll.avg.filter;
cfg.grad = tlock_post.grad;
cfg.headmodel=headmodel;
cfg.sloreta.lambda = '5%';
cfg.channel = tlock_post.label;
cfg.senstype = 'MEG';
cfg.sloreta.reducerank = 'no';
cfg.rawtrial    = 'yes';
sourcepst=ft_sourceanalysis(cfg, tlock_post);
if (Ftrial==1)
    sourcepre=ft_sourceanalysis(cfg, tlock_pre);
end;

cfg=[];
sourcepst_desc=ft_sourcedescriptives(cfg, sourcepst);
sourcepre_desc=ft_sourcedescriptives(cfg, sourcepre);

%% Baseline correction for sources power distribution
source_diff=sourcepst_desc;
source_diff.avg.pow=(sourcepst_desc.avg.pow-sourcepre_desc.avg.pow)./sourcepre_desc.avg.pow;

%% Average over all F-trials
if (Ftrial==1) 
     source_grAvg= source_diff;
else
     source_grAvg.avg.pow=source_grAvg.avg.pow+source_diff.avg.pow;
end;

end;
source_grAvg.avg.pow=source_grAvg.avg.pow/3;

%% Interpolate sources power distribution on MRI and save it
mri_headshape = ft_volumereslice([], mri_headshape);

cfg            = [];
cfg.downsample = 2;
cfg.parameter = 'pow';
source_Int = ft_sourceinterpolate(cfg, source_grAvg , mri_headshape);
 
save('SLoreta\Data2\subj1_3trials_3s_norm1_13-14Hz_grAvg_SepTrials_CommFilter_Int.mat', 'source_Int');

%% Plot the results
cfg = [];
cfg.method       = 'slice';
cfg.funparameter  = 'pow';
 cfg.atlas = atlas_t;
 cfg.roi=atlas_t.tissuelabel(idx);
ft_sourceplot(cfg,  source_Int);

cfg.method       = 'ortho';
ft_sourceplot(cfg,  source_Int);

%% Read the anatomical atlas
atlas = ft_read_atlas('ROI_MNI_V4.nii');
atlas_t= ft_convert_coordsys(atlas, 'neuromag');

%% Determine the areas of interest (visual cortex) in the atlas
idx = [43; 44; 45; 46; 47; 48];

%% Creating the mask based on the determined areas of interest
cfg = [];
cfg.atlas = atlas_t;
cfg.roi = atlas_t.tissuelabel(idx);
mask = ft_volumelookup(cfg, source_Int);

source_Int.mask=mask;

%% Calculating the average sources power in the visual cortex
pow_avg=0;
num=0;
num_th=0;
for i=1:128
    for j=1:128
        for k=1:128
            if source_Int.mask(i,j,k)>0
                ind=(k-1)*128*128+(j-1)*128+i;
                if ((source_Int.pow(ind)))>0 
                    pow_avg=pow_avg+source_Int.pow(ind);
                    num=num+1;
                end;
                if (source_Int.pow(ind))>0.1 
                    num_th=num_th+1;
                end
            end;
        end;
    end;
end;
pow_avg=pow_avg/num;
