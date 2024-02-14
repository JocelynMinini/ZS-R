classdef ZS_Load_PRESTRESS    
%-------------------------------------------------------------------------------
% Concern:       Prestress load [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    EXF                 {mustBeInteger}    % Existence function index
    LABEL = "PRESTRESS"                    % Load class
    LTF                 {mustBeInteger}    % Load time function index
    F                   double             % Prestressed force
    end

    methods

        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the prestress data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        self.EXF = data{4};

        line = fgetl(f);
        data = textscan(line,'%15.8f',1);
        self.F = data{1};
        end
    end
end