# SourceLocal

This repository contains the codebase for the publication:

Chholak, P., Kurkin, S., Hramov, A., and Pisarchik, A. (2020). Event-Related
Coherence in Visual Cortex and Brain Noise: a MEG study. Appl. Sci.
(revision phase)

To run the analyses on your computer after cloning this repository, follow the
following steps:

Save the data (/path_to_data/) in /home/username/data/perception/.

Make a directory to store results (/path_to_results/): /home/username/research/results/perception/.

Make a new Brainstorm protocol: Perception.

Run the whole Brainstorm analysis: SourceLocal/BST/main.m.

Strip trials using  SourceLocal/MAT/StripTrials/strip_main.m. Set:

    • info.root = /path_to_brainstorm_db/Perception/data/.

    • info.root_to_stripped = /path_to_results/StripTrials/.

Make a directory to store coherence results: /path_to_results/Coherence/.

Calculate coherence running SourceLocal/MAT/SrcCoh/SourceCoh_main.m. Set:

    • info.root_to_stripped = /path_to_results/StripTrials/.

    • info.res_path_coh = /path_to_results/Coherence/.

Finally, visualise difference of coherence using SourceLocal/MAT/SrcDiff/SourceDiff_main.m. Set:

    • info.res_path_coh = /path_to_results/Coherence/.

    • fscouts = /path_to_data/scout_V1_V2.mat.
