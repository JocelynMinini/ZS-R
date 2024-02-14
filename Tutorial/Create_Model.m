clc
clear all
uqlab 
ZS_R

current_script_path = erase(mfilename("fullpath"),mfilename);
myPath = [current_script_path,'UQ'];

% Create a ZSoil link model
ModelOpts.Name='HS-Brick-Exc-Berlin-Sand-2phase';
ModelOpts.Parser.Name = 'Parser';
ModelOpts.Parser.Path = myPath;
ModelOpts.Template.Path = myPath;
ModelOpts.ExecutionPath = myPath;

All_Models.ZSoil = ZS_createModel(ModelOpts);

file_save = strcat(current_script_path,"\UQ\","All_Models.mat");
save(file_save,"All_Models")

% Create multiple PCE
input_file = strcat(current_script_path,"\UQ\All_Inputs.mat");
load(input_file); clear input_file

ED_file = strcat( ...
    current_script_path,"\UQ\Backup_HS-Brick-Exc-Berlin-Sand-2phase_Initial_Sampling.mat");
load(ED_file); clear ED_file

QoI_Names = string(fieldnames(Y{1}));
converged =  ~cellfun(@isempty,Y); % Select the converged results

for i = 1:length(QoI_Names)
    OPTS.Type = 'Metamodel';
    OPTS.MetaType = 'PCE';
    OPTS.Input = All_Inputs.PCE;
    OPTS.Degree = [1:10];
    OPTS.ExpDesign.X = X(converged,:);
    temp_Y = cell2mat(Y(converged));
    temp_Y = [temp_Y.(QoI_Names(i))]';
    OPTS.ExpDesign.Y = temp_Y;
    
    PCE_Model = uq_createModel(OPTS);
    All_Models.PCE.(QoI_Names(i)) = PCE_Model;
    clear OPTS PCE_Model temp_Y
end

save(file_save,"All_Models")

% Create multiple PCK
input_file = strcat(current_script_path,"\UQ\All_Inputs.mat");
load(input_file); clear input_file

ED_file = strcat( ...
    current_script_path,"\UQ\Backup_HS-Brick-Exc-Berlin-Sand-2phase_Reduced_Sampling.mat");
load(ED_file); clear ED_file

X = ZS_removeConstant(X);

for i = 1:length(QoI_Names)
    OPTS.Type = 'Metamodel';
    OPTS.MetaType = 'PCK';
    OPTS.Input = All_Inputs.PCK;
    OPTS.Degree = [1:10];
    OPTS.ExpDesign.X = X;
    temp_Y = cell2mat(Y);
    temp_Y = [temp_Y.(QoI_Names(i))]';
    OPTS.ExpDesign.Y = temp_Y;
    
    PCK_Model = uq_createModel(OPTS);
    All_Models.PCK.(QoI_Names(i)) = PCK_Model;
    clear OPTS PCK_Model temp_Y
end

save(file_save,"All_Models")