classdef ZS_Load_EPS0_STR
%-------------------------------------------------------------------------------
% Purpose:        For imposed strains on beam and shell elements [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "EPS0_STR"                     % Load class
    LTF                 {mustBeInteger}    % Load time function index
    FLAG                double             % Decides how and at which side of the element the imposed strain is applied
    VALUE               double             % Imposed strain or strain gradient value
    end

    methods

        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imposed strains on beam and shell from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f',2);
        self.FLAG  = data{1}(1);
        self.VALUE = data{1}(2);
        end
        
    end
end