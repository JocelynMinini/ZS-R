classdef ZS_Load_IMPOSED_BC    
%-------------------------------------------------------------------------------
% Purpose:        For imposed nodal boundary condition [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "IMPOSED_BC"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 {mustBeInteger}    % Existence function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    ULF                 double             % Unloading function index
    DOF                 double             % DOF
    VALUE               double             % Value of the imposed BC
    TIME_DERIV_ORDER    double             % Time derivative order for given BC
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imposed BC load data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};
        self.ULF        = data{7};

        line = fgetl(f);
        data = textscan(line,'%15.8f',3);
        self.DOF              = data{1}(1);
        self.VALUE            = data{1}(2);
        self.TIME_DERIV_ORDER = data{1}(3);
        end
    end
    
end