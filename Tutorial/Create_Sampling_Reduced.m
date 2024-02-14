clc
clear all
uqlab 
ZS_R

current_script_path = erase(mfilename("fullpath"),mfilename);

input_file = strcat(current_script_path,"\UQ\All_Inputs.mat");
load(input_file); clear input_file

model_file = strcat(current_script_path,"\UQ\All_Models.mat");
load(model_file); clear model_file

% Draw some samples
myInput = All_Inputs.ZSoil.Reduced;
X = uq_getSample(myInput,100,'lhs');

% Define the model and evaluate it
myModel = All_Models.ZSoil;
Y = ZS_parallel_evalModel(myModel,X,4);