clear all
clc
ZS_R

% Define the file location
current_script_path = erase(mfilename("fullpath"),mfilename);
ZSoil_File_path = [current_script_path,'\ZSOIL'];
ZSoil_File_Name = 'HS-Brick-Exc-Berlin-Sand-2phase';

% Job field
OPTS.Job.Path = ZSoil_File_path;
OPTS.Job.Name = ZSoil_File_Name;

% Parse one node at the top of the wall
OPTS.Results.Nodal.QoI = ["U_X","U_Y"];
OPTS.Results.Nodal.ID = 6;
OPTS.Results.Nodal.TimeStep = 9;
OPTS.Results.Nodal.Driver = "TIME_DEPENDENT";

% Get nodal results
OUT = ZS_read(OPTS,'on');
U_X_6 = OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_X; %(Matrix output)
U_Y_6 = OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_Y; %(Matrix output)

% Store the results as a structure
RES.UX_6 = OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_X;
RES.UY_6 = OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_Y;