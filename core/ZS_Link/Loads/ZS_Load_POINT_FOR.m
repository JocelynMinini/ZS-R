classdef ZS_Load_POINT_FOR  
%--------------------------------------------------------(1,8)double -----------------------
% Purpose:        For nodal force/flux [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "POINT_FOR"                    % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 {mustBeInteger}    % Existence function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    DOF                 double             % DOF index
    VALUE               double             % Nodal force or flux value
    end

    methods

        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the Nodal load/flux load data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID        = data{1};
        self.LTF       = data{2};
        self.EXF       = data{4};
        self.LOAD_MODE = data{5};

        line = fgetl(f);
        data = textscan(line,'%15.8f',2);
        self.DOF   = data{1}(1);
        self.VALUE = data{1}(2);
        end

    end
    
end