classdef ZS_Link < dynamicprops 

    properties
    JOB
    end

    methods

    function self = Get_job_name_path(self,Name,Path)
    %-------------------------------------------------------------------------------
    % Name:           get_job_name_path
    % Purpose:        Give the job name and path
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    if ~( ischar(Name) & ischar(Path) )
        error("Both arguments 'Name' and 'Path' must be character vectors")
    end
    self.JOB.NAME = Name;
    self.JOB.PATH = Path;
    end

    function [self,DYN] = Init_his(self)
    %-------------------------------------------------------------------------------
    % Name:           Init_his
    % Purpose:        Read the data from the .his file and store it
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    DYN = self.addprop('HISTORY_his');
    DYN.SetAccess = 'protected';

    Name = self.JOB.NAME;
    Path = self.JOB.PATH;
    file = [fullfile(Path,Name),'.his'];
    
    try
        self.HISTORY_his = ZS_History;
        self.HISTORY_his = self.HISTORY_his.Instanciate(file);
    catch ME
        self.HISTORY_his = ME;
    end
    fclose('all');
    end

    function self = Init_rcf(self)
    %-------------------------------------------------------------------------------
    % Name:           Init_his
    % Purpose:        Read the data from the .his file and store it
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    DYN = self.addprop('RESULTS_CONFIG_rcf');
    DYN.SetAccess = 'protected';

    Name = self.JOB.NAME;
    Path = self.JOB.PATH;
    file = [fullfile(Path,Name),'.rcf'];
    
    try
        self.RESULTS_CONFIG_rcf = ZS_Results_Config;
        self.RESULTS_CONFIG_rcf = self.RESULTS_CONFIG_rcf.Instanciate(file);
    catch ME    
        self.RESULTS_CONFIG_rcf = ME;
    end
    fclose('all');
    end

    function self = Init_dat(self)
    %-------------------------------------------------------------------------------
    % Name:           Init_dat
    % Purpose:        Read the data from the .dat file and store it
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('MODEL_dat');
    Name = self.JOB.NAME;
    Path = self.JOB.PATH;
    f = [fullfile(Path,Name),'.dat'];
    
    self.MODEL_dat = ZS_Model;

    % Version
    try
        self.MODEL_dat = self.MODEL_dat.Init_version(f);
    catch ME
        self.MODEL_dat.VERSION = ME;
    end

    % Problem
    try
        self.MODEL_dat = self.MODEL_dat.Init_problem(f);
    catch ME
        self.MODEL_dat.PROBLEM_TYPE = ME;
    end

    % Elements
    try
        self.MODEL_dat = self.MODEL_dat.Init_elements(f);
    catch ME
        self.MODEL_dat.ELEMENTS = ME;
    end

    % Nodes
    try
        self.MODEL_dat = self.MODEL_dat.Init_nodes(f);
    catch ME
        self.MODEL_dat.NODES = ME;
    end

    % Nails
    try
        self.MODEL_dat = self.MODEL_dat.Init_nails(f);
    catch ME
        self.MODEL_dat.NAILS = ME;
    end

    % Piles
    try
        self.MODEL_dat = self.MODEL_dat.Init_piles(f);
    catch ME
        self.MODEL_dat.PILES = ME;
    end

    % Load function
    try
        self.MODEL_dat = self.MODEL_dat.Init_LF(f);
    catch ME
        self.MODEL_dat.LOAD_TIME_FUNCTIONS = ME;
    end

    % Load
    try
        self.MODEL_dat = self.MODEL_dat.Init_loads(f);
    catch ME
        self.MODEL_dat.LOAD_RECORDS = ME;
    end

    % Drivers
    try
        self.MODEL_dat = self.MODEL_dat.Init_drivers(f);
    catch ME
        self.MODEL_dat.DRIVERS = ME;
    end

    % Existence function
    try
        self.MODEL_dat = self.MODEL_dat.Init_EXF(f);
    catch ME
        self.MODEL_dat.EXISTENCE_FUNCTIONS = ME;
    end

    % Evolution functios
    try
        self.MODEL_dat = self.MODEL_dat.Init_EVF(f);
    catch ME
        self.MODEL_dat.EVOLUTION_FUNCTIONS = ME;
    end

    % Units
    try
        self.MODEL_dat = self.MODEL_dat.Init_units(f);
    catch ME
        self.MODEL_dat.UNITS = ME;
    end

    % Materials
    try
        self.MODEL_dat = self.MODEL_dat.Init_materials(f);
    catch ME
        self.MODEL_dat.MATERIALS = ME;
    end
    
    fclose('all');
    end
    
    function check_file_exist(self,extansion)
    %-------------------------------------------------------------------------------
    % Name:           check_file_exist
    % Purpose:        Check if a calculation file exists
    % Last Update:    08.02.2024
    %-------------------------------------------------------------------------------
    file_path = fullfile(self.JOB.PATH,[self.JOB.NAME,extansion]);
    if ~isfile(file_path)
        error(strcat("ZS+R could not find the requested file : '",file_path,"'. ","Please ensure this file exists."))
    end
    end

    function self = Init_Results(self,OPTIONS,PRINT_OPTS,wait_time)
    %-------------------------------------------------------------------------------
    % Name:           Init_Results
    % Purpose:        Parse the ZSoil results according to the user input
    % Last Update:    28.09.2023
    %-------------------------------------------------------------------------------
    self.addprop('RESULTS');
    self.RESULTS = ZS_Results;
    self.RESULTS.OPTIONS = OPTIONS.Results;
    
    if isfield(OPTIONS.Results,'Nodal')
        if PRINT_OPTS 
            fprintf(' - Reading nodal results (.s00)......................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s00(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.NODAL_s00 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Reaction')
        if PRINT_OPTS 
            fprintf(' - Reading nodal reaction results (.r00).............') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_r00(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.REACTION_r00 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Continuum')
        if PRINT_OPTS 
            fprintf(' - Reading continuum results (.s01)..................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s01(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.CONTINUUM_s01 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Shell')
        if PRINT_OPTS 
            fprintf(' - Reading shell results (.s02)......................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s02(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.SHELL_s02 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Truss')
        if PRINT_OPTS 
            fprintf(' - Reading truss results (.s03)......................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s03(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.TRUSS_s03 = ME;
        end
    end

    if isfield(OPTIONS.Results,'Beam')
        if PRINT_OPTS 
            fprintf(' - Reading beam results (.s04).......................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s04(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.BEAM_s04 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Hinge')
        if PRINT_OPTS 
            fprintf(' - Reading beam/shell hinges results (.s05)..........') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s05(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.HINGES_s05 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Contact')
        if PRINT_OPTS 
            fprintf(' - Reading contact results (.s07)....................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s07(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.CONTACT_s07 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Membrane')
        if PRINT_OPTS 
            fprintf(' - Reading membrane results (.s15)...................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_s15(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.MEMBRANE_s15 = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Pile')
        if PRINT_OPTS 
            fprintf(' - Reading pile results (.s04 + .s07)................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_nails_piles(self,'Pile');
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.PILES = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Nail')
        if PRINT_OPTS 
            fprintf(' - Reading nail results (.s04 + .s07)................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_nails_piles(self,'Nail');
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.NAILS = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    if isfield(OPTIONS.Results,'Stability')
        if PRINT_OPTS 
            fprintf(' - Reading stability results (.his)..................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_stability(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.STABILITY_his = ME;
        end
    end

    if isfield(OPTIONS.Results,'Eigenmode')
        if PRINT_OPTS 
            fprintf(' - Reading eigenmode results (.eig)..................') 
        end
        try
            tic
            self.RESULTS = self.RESULTS.Init_eigenmodes(self);
            ZS_Display_Time(toc,PRINT_OPTS,wait_time)
        catch ME
            self.RESULTS.EIGENMODE_eig = ME;
            ZS_Display_Time(toc,PRINT_OPTS,wait_time,false)
        end
    end

    fclose('all');
    end


    end
    
end