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

% Parse the min max value of bending moments and shear forces
OPTS.Results.Truss.ID = [3985 3986 3987 3988 3989 3990 3991 3992 3993];
OPTS.Results.Truss.QoI = "N_X";
OPTS.Results.Truss.TimeStep = 9;
OPTS.Results.Truss.Driver = "TIME_DEPENDENT";

OUT = ZS_read(OPTS,'on');

RES = max( cell2mat(OUT.RESULTS.TRUSS_s03.N_X) );

