classdef ZS_Load_AMBIENT_TW
%----------------------------------------------------------------
% Purpose:        For ambient temperature or humidity [OK]
%----------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "AMBIENT_TW"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    T_A                 (1,1)double        % Ambient temperature for the heat project or ambient humidity for the humidity project
    end

    methods

        function self = read(self,f,data)
        %--------------------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the ambient temperature or humidity from the .dat file.
        % Last Update:    04.10.2023
        %--------------------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f',1);
        self.T_A = data{1};
        end
        
    end
end