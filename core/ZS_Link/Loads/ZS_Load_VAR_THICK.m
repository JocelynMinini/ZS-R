classdef ZS_Load_VAR_THICK    
%-------------------------------------------------------------------------------
% Concern:        Constant/variable shell thickness for shell elements [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "VAR_THICK"                    % Load class
    LTF                 {mustBeInteger}    % Load time function index
    NP                  double             % Number of points used to interpolate thickness
    X                   (1,4)double        % x coordinates of k-th point
    Y                   (1,4)double        % y coordinates of k-th point 
    Z                   (1,4)double        % z coordinates of k-th point
    H                   (1,4)double        % the thickness at k-th point
    end
    
    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the thickness for shell elements from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};

        line = fgetl(f);
        data = textscan(line,'%15.8f',4);
        self.NP = data{1};

        field = {"X","Y","Z","H"};

        for i = 1:length(field)
            line = fgetl(f);
            data = textscan(line,'%15.8f',4);
            self.X(i) = data{1}(1);
            self.Y(i) = data{1}(2);
            self.Z(i) = data{1}(3);
            self.H(i) = data{1}(4);
        end

        for i = 1:4
            fgetl(f);
        end
        end
    end
end