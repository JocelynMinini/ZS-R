function RES = Parser(OutputFile)

try

[file_path,file_name] = fileparts(regexprep(OutputFile,'\.[^.]*$','')); 

OPTS.Job.Name = file_name;
OPTS.Job.Path = file_path;

% Store first the data, the his and the rcf solutions
OUT = ZS_read(OPTS);

DAT = OUT.MODEL_dat;
RCF = OUT.RESULTS_CONFIG_rcf;
HIS = OUT.HISTORY_his;

OPTS.DAT = DAT;
OPTS.RCF = RCF;
OPTS.HIS = HIS;

% Parse Ux_max
OPTS.Results.Nodal.QoI = "U_X";
OPTS.Results.Nodal.TimeStep = 9;
OPTS.Results.Nodal.Driver = "TIME_DEPENDENT";
OPTS.Results.Nodal.ID = [3 6 14 982 1015 1048 1081 1114 1147 1180 1213 1246 1279 1312 1345 ... 
                         1378 1411 1444 1477 1510 1543 1576 1609 1804 3278 3281 3284 3436 ...
                         3439 3442 3505 3508 3511];
OUT = ZS_read(OPTS);
RES.Ux_max =  max(abs(OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_X));
clear OUT

% Parse Uy_max
OPTS.Results.Nodal.QoI = "U_Y";
OPTS.Results.Nodal.TimeStep = 9;
OPTS.Results.Nodal.Driver = "TIME_DEPENDENT";
OPTS.Results.Nodal.ID = [8 11 2581 3604 3605 3606 3607 3608 3609 3610 3611 3612 3613 3614 ...
                         3615 3616 3617 3618 3619 3620 3621 3622 3623 3624 3625 3626 3627 ...
                         3628 3629 3630 3631 3632 3633 3634 3635 3636 3637 3638 3639 3640 ...
                         3641 3642 3643 3644];

OUT = ZS_read(OPTS);
RES.Uy_max =  max(abs(OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_Y));
clear OUT

% Parse M_max
OPTS.Results.Beam.ID = [3944 3945 3946 3947 3948 3949 3950 3951 3952 3953 3954 ...
                         3955 3956 3957 3958 3959 3960 3961 3962 3963 3964 3965 ...
                         3966 3967 3968 3969 3970 3971 3972 3973 3974 3975];
OPTS.Results.Beam.QoI = "M_Z";
OPTS.Results.Beam.TimeStep = 9;
OPTS.Results.Beam.Driver = "TIME_DEPENDENT";

OUT = ZS_read(OPTS);
M_max = OUT.RESULTS.BEAM_s04.MOMENTS.M_Z;
M_max = cell2mat(M_max);
RES.M_max = max(abs(M_max));
clear OUT

% Parse the last safety factor
OPTS.Results.Stability.TimeStep = 9;
OPTS.Results.Stability.SF = 'last';

OUT = ZS_read(OPTS);
RES.SF = OUT.RESULTS.STABILITY_his.SF;
clear OUT

catch

RES = [];

end

