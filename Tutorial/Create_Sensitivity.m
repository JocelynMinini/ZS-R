clc
clear all
uqlab 

current_script_path = erase(mfilename("fullpath"),mfilename);

input_file = strcat(current_script_path,"\UQ\All_Inputs.mat");
load(input_file); clear input_file

model_file = strcat(current_script_path,"\UQ\All_Models.mat");
load(model_file); clear input_file

PCE_model_names = string(fieldnames(All_Models.PCE));
Total_indices = [];

for i = 1:length(PCE_model_names)
    OPTS.Name = PCE_model_names(i);
    OPTS.Type = 'Sensitivity';
    OPTS.Method = 'Sobol';
    OPTS.Input = All_Inputs.PCE;
    OPTS.Model = All_Models.PCE.(PCE_model_names(i));
    OPTS.Sobol.PCEBased = true;
    Sobol = uq_createAnalysis(OPTS);
    All_Sensitivity.(PCE_model_names(i)) = Sobol;
    Total_indices = [Total_indices,Sobol.Results.Total];
    uq_display(Sobol)
end

figure
var = categorical({All_Inputs.ZSoil.Initial.Marginals.Name});
var = reordercats(var,{All_Inputs.ZSoil.Initial.Marginals.Name});
bar(var,Total_indices)
legend(PCE_model_names)