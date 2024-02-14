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
OPTS.Results.Beam.ID = [3944 3945 3946 3947 3948 3949 3950 3951 3952 3953 3954 ...
                        3955 3956 3957 3958 3959 3960 3961 3962 3963 3964 3965 ...
                        3966 3967 3968 3969 3970 3971 3972 3973 3974 3975];
OPTS.Results.Beam.QoI = ["M_Z","Q_Y"];
OPTS.Results.Beam.TimeStep = 9;
OPTS.Results.Beam.Driver = "TIME_DEPENDENT";

OUT = ZS_read(OPTS,'on');

RES.Moment_Max = cell2mat( minmax(OUT.RESULTS.BEAM_s04.MOMENTS.M_Z') );
RES.Shear_Max = cell2mat( minmax(OUT.RESULTS.BEAM_s04.FORCES.Q_Y') );