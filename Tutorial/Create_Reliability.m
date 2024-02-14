clc
clear all
uqlab 
ZS_R

current_script_path = erase(mfilename("fullpath"),mfilename);
myPath = [current_script_path,'UQ'];

load(fullfile(myPath,"All_Inputs.mat"))
load(fullfile(myPath,"All_Models.mat"))

OPTS.Type = 'uq_reliability';
OPTS.Method = 'MCS';
OPTS.Input = All_Inputs.PCK;
OPTS.Model = All_Models.PCK.SF;
OPTS.LimitState.Threshold = 1;
OPTS.LimitState.CompOp = '<';
OPTS.Simulation.MaxSampleSize = 10^6; % For computational simplicity

MCS = uq_createAnalysis(OPTS);