classdef ZS_Load_PRSHEAD_BC    
%-------------------------------------------------------------------------------
% Purpose:        For fluid head BC [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    EXF                 {mustBeInteger}    % Load function index
    LABEL = "PRSHEAD_BC"                   % Element class
    LTF                 {mustBeInteger}    % Load time function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    ULF                 double             % Unloading function index
    GAMMA_F             double             % The fluid unit weight
    H_0                 double             % the reference pressure head value
    end

    methods
        
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the fluid head BC data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};
        self.ULF        = data{7};
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',2);
        self.GAMMA_F = data{1}(1);
        self.H_0     = data{1}(2);  
        end

    end
    
end