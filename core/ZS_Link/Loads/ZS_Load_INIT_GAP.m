classdef ZS_Load_INIT_GAP
%----------------------------------------------------------------
% Purpose:        For initial gap in interfaces [OK]
%----------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "INIT_GAP"                     % Load class
    LTF                 {mustBeInteger}    % Load time function index
    G_0                 (1,1)double        % Initial gap value
    end

    methods

        function self = read(self,f,data)
        %--------------------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the initial gap in interfaces from the .dat file.
        % Last Update:    04.10.2023
        %--------------------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f',1);
        self.G_0 = data{1};
        end
        
    end
end