classdef ZS_Load_GRAVITY
%-------------------------------------------------------------------------------
% Purpose:        For gravity [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "GRAVITY"                      % Load class
    LTF                 {mustBeInteger}    % Load time function index
    XYZ                 (1,3) double       % DOF index
    VALUE               double             % Nodal force or flux value
    end

    methods

        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the gravity load data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f',4);
        self.XYZ = data{1}(1:3);
        self.VALUE = data{1}(4);
        end
    end
end