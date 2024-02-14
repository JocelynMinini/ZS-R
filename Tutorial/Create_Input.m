clc
clear all
uqlab 
ZS_R

current_script_path = erase(mfilename("fullpath"),mfilename);
save_path = strcat(current_script_path,"\UQ\","All_Inputs.mat");

% Create initial input ZSoil + full metamodels
InputOpts.Marginals(1).Name='Phi_S1';
InputOpts.Marginals(1).Type='Lognormal';
InputOpts.Marginals(1).Moments=[35,0.1*35];

InputOpts.Marginals(2).Name='C_S1';
InputOpts.Marginals(2).Type='Lognormal';
InputOpts.Marginals(2).Moments=[1,0.2*1];

InputOpts.Marginals(3).Name='E_S1';
InputOpts.Marginals(3).Type='Lognormal';
InputOpts.Marginals(3).Moments=[45,0.3*45];

InputOpts.Marginals(4).Name='Phi_S2';
InputOpts.Marginals(4).Type='Lognormal';
InputOpts.Marginals(4).Moments=[38,0.1*38];

InputOpts.Marginals(5).Name='C_S2';
InputOpts.Marginals(5).Type='Lognormal';
InputOpts.Marginals(5).Moments=[1,0.2*1];

InputOpts.Marginals(6).Name='E_S2';
InputOpts.Marginals(6).Type='Lognormal';
InputOpts.Marginals(6).Moments=[75,0.3*75];

InputOpts.Marginals(7).Name='E_Wall';
InputOpts.Marginals(7).Type='Lognormal';
InputOpts.Marginals(7).Moments=[30000,0.1*30000];

InputOpts.Copula.Type = 'Independent';

myInput = uq_createInput(InputOpts);
All_Inputs.ZSoil.Initial = myInput; % For Link model
All_Inputs.PCE = myInput;           % For PCE model
save(save_path,"All_Inputs")
clear InputOpts myInput

% Create reduced input ZSoil
InputOpts.Marginals(1).Name='Phi_S1';
InputOpts.Marginals(1).Type='Lognormal';
InputOpts.Marginals(1).Moments=[35,0.1*35];

InputOpts.Marginals(2).Name='C_S1';
InputOpts.Marginals(2).Type='Constant';
InputOpts.Marginals(2).Moments=1;

InputOpts.Marginals(3).Name='E_S1';
InputOpts.Marginals(3).Type='Lognormal';
InputOpts.Marginals(3).Moments=[45,0.3*45];

InputOpts.Marginals(4).Name='Phi_S2';
InputOpts.Marginals(4).Type='Lognormal';
InputOpts.Marginals(4).Moments=[38,0.1*38];

InputOpts.Marginals(5).Name='C_S2';
InputOpts.Marginals(5).Type='Constant';
InputOpts.Marginals(5).Moments=1;

InputOpts.Marginals(6).Name='E_S2';
InputOpts.Marginals(6).Type='Lognormal';
InputOpts.Marginals(6).Moments=[75,0.3*75];

InputOpts.Marginals(7).Name='E_Wall';
InputOpts.Marginals(7).Type='Constant';
InputOpts.Marginals(7).Moments=30000;

InputOpts.Copula.Type = 'Independent';

myInput = uq_createInput(InputOpts);
All_Inputs.ZSoil.Reduced = myInput;
save(save_path,"All_Inputs")
clear InputOpts myInput

% Create reduced input metamodel 
InputOpts.Marginals(1).Name='Phi_S1';
InputOpts.Marginals(1).Type='Lognormal';
InputOpts.Marginals(1).Moments=[35,0.1*35];

InputOpts.Marginals(2).Name='E_S1';
InputOpts.Marginals(2).Type='Lognormal';
InputOpts.Marginals(2).Moments=[45,0.3*45];

InputOpts.Marginals(3).Name='Phi_S2';
InputOpts.Marginals(3).Type='Lognormal';
InputOpts.Marginals(3).Moments=[38,0.1*38];

InputOpts.Marginals(4).Name='E_S2';
InputOpts.Marginals(4).Type='Lognormal';
InputOpts.Marginals(4).Moments=[75,0.3*75];

InputOpts.Copula.Type = 'Independent';

myInput = uq_createInput(InputOpts);
All_Inputs.PCK = myInput;
save(save_path,"All_Inputs")
clear InputOpts myInput
