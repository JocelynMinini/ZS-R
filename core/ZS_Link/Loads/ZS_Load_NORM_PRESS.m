classdef ZS_Load_NORM_PRESS    
%-------------------------------------------------------------------------------
% Purpose:        For normal pressure applied on edges [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "NORM_PRESS"                     % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 {mustBeInteger}    % Existence function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    COEFFICIENTS        (1,7)double        % Coefficient of the function f(x, y, z) = a + b x + c y + d z + e x y + f x z + g y z
    end

    methods
        
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the normal pressure applied on edges from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID        = data{1};
        self.LTF       = data{2};
        self.EXF       = data{4};
        self.LOAD_MODE = data{5};

        line = fgetl(f);
        data = textscan(line,'%15.8f',7);
        self.COEFFICIENTS = data{1}';
        end

    end
    
end