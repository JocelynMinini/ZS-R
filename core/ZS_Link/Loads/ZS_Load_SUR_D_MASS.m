classdef ZS_Load_SUR_D_MASS    
%-------------------------------------------------------------------------------
% Purpose:        For distributed added masses [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Element number
    EXF                 {mustBeInteger}    % Existence function index
    LABEL = "SUR_D_MASS "                  % Element class
    LTF                 {mustBeInteger}    % Load time function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    RHO                 double             % Added mass density
    RHO_S               double             % Mass density to be used to form equivalent forces
    FLAG                double             % Equal to 2 for the distributed mass set on edge and 3 on the facet
    FILTER_FLAG         double             % Equal to 0 when mass is to be applied in all 3 directions or 1 when mass filtering is set ON
    F_X                 double             % Mass multiplier in x direction
    F_Y                 double             % Corresponding multipliers in Y
    F_Z                 double             % Corresponding multipliers in Z
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the distributed added masses from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};

        line = fgetl(f);
        data = textscan(line,'%15.8f',7);
        self.RHO         = data{1}(1);
        self.RHO_S       = data{1}(2);
        self.FLAG        = data{1}(3);
        self.FILTER_FLAG = data{1}(4);
        self.F_X         = data{1}(5);
        self.F_Y         = data{1}(6);
        self.F_Z         = data{1}(7);
        end
    end
    
end