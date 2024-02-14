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

% Pass HIS, RCF and DAT in the user options
OUT = ZS_read(OPTS,'on');
OPTS.HIS = OUT.HISTORY_his;
OPTS.RCF = OUT.RESULTS_CONFIG_rcf; 
OPTS.DAT = OUT.MODEL_dat;

% Parse the maximal horizontal displacement of the wall
OPTS.Results.Nodal.QoI = ["U_X"];
OPTS.Results.Nodal.ID = [3 6 14 982 1015 1048 1081 1114 1147 1180 1213 1246 1279 1312 1345 ... 
                         1378 1411 1444 1477 1510 1543 1576 1609 1804 3278 3281 3284 3436 ...
                         3439 3442 3505 3508 3511];
OPTS.Results.Nodal.TimeStep = 9;
OPTS.Results.Nodal.Driver = "TIME_DEPENDENT";

OUT = ZS_read(OPTS);
RES.MAX_UX = max( abs(OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_X) );

% Parse the maximal vertical displacement of the surface ground
OPTS.Results.Nodal.QoI = ["U_Y"];
OPTS.Results.Nodal.ID = [8 11 2581 3604 3605 3606 3607 3608 3609 3610 3611 3612 3613 3614 ...
                         3615 3616 3617 3618 3619 3620 3621 3622 3623 3624 3625 3626 3627 ...
                         3628 3629 3630 3631 3632 3633 3634 3635 3636 3637 3638 3639 3640 ...
                         3641 3642 3643 3644];
OPTS.Results.Nodal.TimeStep = 9;
OPTS.Results.Nodal.Driver = "TIME_DEPENDENT";

OUT = ZS_read(OPTS);
RES.MAX_UY = max( abs(OUT.RESULTS.NODAL_s00.DISPLACEMENTS.U_Y) );