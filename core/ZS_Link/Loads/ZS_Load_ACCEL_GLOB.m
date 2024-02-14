classdef ZS_Load_ACCEL_GLOB
%----------------------------------------------------------------
% Purpose:        For global acceleration records [OK]
%----------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "ACCEL_GLOB"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    A_X                 double             % X acceleration reference values
    A_Y                 double             % Y acceleration reference values
    A_Z                 double             % Z acceleration reference values
    TYPE                double             % Equal to 0 for the rigid base model or 1 for the compliant base one
    end

    methods

        function self = read(self,f,data)
        %--------------------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the global acceleration records from the .dat file.
        % Last Update:    04.10.2023
        %--------------------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        field = {"A_X","A_Y","A_Z","TYPE"};
        line = fgetl(f);
        data = textscan(line,'%15.8f',4);
        
        for i = 1:length(field)
            self.(field{i}) = data{1}(i);
        end
        end
        
    end
end