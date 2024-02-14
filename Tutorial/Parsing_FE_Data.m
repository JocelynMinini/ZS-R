clear all
clc
ZS_R

% Define the file location
current_script_path = erase(mfilename("fullpath"),mfilename);
ZSoil_File_path = [current_script_path,'\ZSOIL'];
ZSoil_File_Name = 'HS-Brick-Exc-Berlin-Sand-2phase';

% Create the user options

% Job field
OPTS.Job.Path = ZSoil_File_path;
OPTS.Job.Name = ZSoil_File_Name;

% Get FE data
OUT = ZS_read(OPTS,'on');
FE_DATA = OUT.MODEL_dat;
clear OUT

% Extract node coordinates
Node_XYZ = vertcat(FE_DATA.NODES.XYZ);

% Extract standard beam (BEL2) node IDs
temp = [FE_DATA.ELEMENTS.BEAMS.BEL2.NODES];
BEL2_Node_IDs = vertcat(temp.MASTER);
clear temp

% Plot all load time function
LF = FE_DATA.LOAD_TIME_FUNCTIONS;
N_LF = length(LF);
for i = 1:N_LF
    temp_ID = LF(i).ID;
    temp_data = LF(i).LTF;
    figure(i)
    plot(temp_data(:,1),temp_data(:,2))
    title(['Load function number ',num2str(temp_ID)])
    xlabel('Time (s)') 
    ylabel('Value') 
end
clear temp_data temp_ID i N_LF