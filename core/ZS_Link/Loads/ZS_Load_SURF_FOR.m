classdef ZS_Load_SURF_FOR    
%-------------------------------------------------------------------------------
% Purpose:        For surface loads [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "SURF_FOR"                     % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 {mustBeInteger}    % Existence function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    ULF                 double             % Unloading function index
    DIRECTION           double             % Direction of the load (1,2,3)
    GLOBAL_FLAG         double             % global coordinate system flag
    COEFFICIENTS        (1,7)double        % Coefficient of the function f(x, y, z) = a + b x + c y + d z + e x y + f x z + g y z
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the surface load data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID         = data{1};
        self.LTF        = data{2};
        self.EXF        = data{4};
        self.LOAD_MODE  = data{5};
        self.LOCAL_BASE = data{6};
        self.ULF        = data{7};

        line = fgetl(f);
        data = textscan(line,'%15.8f',8);
        self.DIRECTION   = data{1}(1);
        self.GLOBAL_FLAG = data{1}(2);

        coeff = (data{1}(3:end))';
        line = fgetl(f);
        data = textscan(line,'%15.8f',1);
        coeff = [coeff,data{1}];
        self.COEFFICIENTS = coeff;
        end
    end
    
end