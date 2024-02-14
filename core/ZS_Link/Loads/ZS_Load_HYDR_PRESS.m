classdef ZS_Load_HYDR_PRESS    
%-------------------------------------------------------------------------------
% Purpose:        For surface loading through hydrostatic pressure [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "HYDR_PRESS"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 double             % Existence function index
    GAMMA_F             double             % Fluid unit weight
    H_0                 double             % Reference pressure head value
    DIR_FLAG            double             % Equal to 1 if the loading is to be applied along direction of the edge/facet external normal or -1 otherwise
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the hydrostatic pressure from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        self.EXF = data{4};
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',3);
        self.GAMMA_F  = data{1}(1);
        self.H_0      = data{1}(2);
        self.DIR_FLAG = data{1}(3);
        end

    end
    
end