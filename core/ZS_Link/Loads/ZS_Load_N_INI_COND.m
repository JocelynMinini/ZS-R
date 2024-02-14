classdef ZS_Load_N_INI_COND    
%-------------------------------------------------------------------------------
% Concern:        Initial nodal condition [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    EXF                 {mustBeInteger}    % Existence function index
    LABEL = "N_INI_COND"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    DOF                 double             % DOF index
    VALUE               double             % Initial value of the pressure, displacement, rotation, temperature or humidity value
    TIME_DERIV_ORDER    double             % time derivative order for given initial condition
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the Initial nodal condition from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',3);
        self.DOF              = data{1}(1);
        self.VALUE            = data{1}(2);
        self.TIME_DERIV_ORDER = data{1}(3);
        end
    end
end