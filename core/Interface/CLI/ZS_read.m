function LINK = ZS_read(OPTIONS,PRINT_OPTS)
%-------------------------------------------------------------------------------
% Name:           ZS_Read
% Purpose:        Read and extract the ZSoil output results according to
%                 OPTIONS
% Last Update:    27.08.2023
%-------------------------------------------------------------------------------
% Check arguments
if ~isstruct(OPTIONS)
    error("ZSLINK_ERROR : Argument must be a MATLAB data structure")
end

if ~exist('PRINT_OPTS','var')
    PRINT_OPTS = false;
end

if strcmp(PRINT_OPTS,'on')
    PRINT_OPTS = true;
    wait_time = 1;
else
    PRINT_OPTS = false;
    wait_time = 0;
end

%% Job
% Check Job field
if ~isfield(OPTIONS,"Job")
    error("ZSLINK_ERROR : OPTIONS must contain the field 'Job'")
else
    if ~isfield(OPTIONS.Job,"Name")
        error("ZSLINK_ERROR : OPTIONS.Job must contain the field 'Name'")
    end

    if ~isfield(OPTIONS.Job,"Path")
        OPTIONS.Job.Path = pwd;
    end
end

Name = OPTIONS.Job.Name;
Path = OPTIONS.Job.Path;

LINK = ZS_Link;
LINK = LINK.Get_job_name_path(Name,Path);

if PRINT_OPTS 
    fprintf('\n')
    fprintf('FE MODEL DATA :')
    fprintf('\n')
end

%% History of execution
if ~isfield(OPTIONS,"HIS")
    if PRINT_OPTS 
        fprintf(' - Reading history of execution file (.his)..........') 
    end
    tic
    
    LINK.check_file_exist('.his')
    
    LINK = LINK.Init_his;
        
    if PRINT_OPTS & isa(LINK.HISTORY_his,'MException')
        ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
    elseif PRINT_OPTS
        ZS_Display_Time(toc,PRINT_OPTS,wait_time)
    end
    
    
else
    tic
    if PRINT_OPTS 
        fprintf(' - History of execution (.his) given by the user.....') 
    end
    LINK.addprop("HISTORY_his");
    LINK.HISTORY_his = OPTIONS.HIS;
    ZS_Display_Time(toc,PRINT_OPTS,wait_time)
end

%% Result files configuration
if ~isfield(OPTIONS,"RCF")
    if PRINT_OPTS 
        fprintf(' - Reading results configuration setup file (.rcf)...') 
    end
    tic

    LINK.check_file_exist('.rcf')
    
    LINK = LINK.Init_rcf;

    if PRINT_OPTS & isa(LINK.RESULTS_CONFIG_rcf,'MException')
        ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
    elseif PRINT_OPTS
        ZS_Display_Time(toc,PRINT_OPTS,wait_time)
    end

else
    tic
    if PRINT_OPTS 
        fprintf(' - Results configuration (.rcf) given by the user....') 
    end
    LINK.addprop("RESULTS_CONFIG_rcf");
    LINK.RESULTS_CONFIG_rcf = OPTIONS.RCF;
    ZS_Display_Time(toc,PRINT_OPTS,wait_time)
end

%% FE Model data
if ~isfield(OPTIONS,"DAT")
    if PRINT_OPTS 
        fprintf(' - Reading FE model data file (.dat).................') 
    end
    tic
    
    LINK.check_file_exist('.dat')

    LINK = LINK.Init_dat;

    field_names = fieldnames(LINK.MODEL_dat);

    boole = [];
    for i = 1:length(field_names)
        boole(end+1) = isa(LINK.MODEL_dat.(field_names{i}),'MException');
    end
    is_failed = find(boole);
    n_failed  = length(is_failed);

    if n_failed > 0
        if PRINT_OPTS 
            fprintf(['[',char(num2str(n_failed)),' Failed] '])
            fprintf(' t = ')
            fprintf('%.2f', toc)
            fprintf(' s\n')
            for i = 1:n_failed
                fprintf(['   - ',field_names{is_failed(i)},' [Failed]\n'])
            end
        end
    else
        ZS_Display_Time(toc,PRINT_OPTS,wait_time)
    end

else
    tic
    if PRINT_OPTS 
        fprintf(' - FE model data (.dat) given by user................') 
    end
    LINK.addprop("MODEL_dat");
    LINK.MODEL_dat = OPTIONS.DAT;
    ZS_Display_Time(toc,PRINT_OPTS,wait_time)
end


%% Results
% Check Results field
if isfield(OPTIONS,"Results")

    if PRINT_OPTS 
        fprintf('\n')
        fprintf('FE MODEL RESULTS :')
        fprintf('\n')
    end

    LINK = LINK.Init_Results(OPTIONS,PRINT_OPTS,wait_time);
    
    if PRINT_OPTS 
        fprintf('\n')
    end
end



end