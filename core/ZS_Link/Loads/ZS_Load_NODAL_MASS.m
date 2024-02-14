classdef ZS_Load_NODAL_MASS    
%-------------------------------------------------------------------------------
% Concern:        Nodal masses [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    EXF                 {mustBeInteger}    % Existence function index
    LABEL = "NODAL_MASS"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    M                   double             % Added nodal mass value
    I_X                 double             % Momentum of inertia X
    I_Y                 double             % Momentum of inertia Y
    I_Z                 double             % Momentum of inertia Z
    FILTER_FLAG         double             % Equal to 0 when mass is to be applied in all 3 directions or 1 when mass filtering is set ON
    F_X                 double             % Mass multiplier in X direction (local if local base is associated with this record or global) if filter flag=1,
    F_Y                 double             % Corresponding multipliers in Y
    F_Z                 double             % Corresponding multipliers in Z
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the nodal masses from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',8);
        self.M           = data{1}(1);
        self.I_X         = data{1}(2);
        self.I_Y         = data{1}(3);
        self.I_Z         = data{1}(4);
        self.FILTER_FLAG = data{1}(5);
        self.F_X         = data{1}(6);
        self.F_Y         = data{1}(7);
        self.F_Z         = data{1}(8);
        end
    end
end