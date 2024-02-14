classdef ZS_Load_SDATA_SELE
%-----------------------------------------------------------------------------------------------------------------------------
% Purpose:        For Superelement data for cloning materials due to variable spatial distribution of selected properties [OK]
%-----------------------------------------------------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "SDATA_SELE"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    TYPE                double             % Equal to 1 for linear L2 super-element type
    X                   double             % Super-element X coordinates
    Y                   double             % Super-element Y coordinates
    Z                   double             % Super-element Z coordinates
    M                   double             % Parameter multiplier at k-th super-element vertex
    end

    methods

        function self = read(self,f,data)
        %--------------------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imultipliers to the reference material property from the .dat file.
        % Last Update:    04.10.2023
        %--------------------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f');
        self.TYPE = data{1};

        field = {"X","Y","Z","M"};
        for i = 1:length(field)
            line = fgetl(f);
            data = textscan(line,'%15.8f',8);
            self.(field{i}) = data{1};
        end
        end
        
    end
end