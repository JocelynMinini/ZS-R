classdef ZS_Load_DIST_FLUX    
%-------------------------------------------------------------------------------
% Purpose:        For distributed fluxes set on edges [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "DIST_FLUX"                    % Load class
    LTF                 {mustBeInteger}    % Load time function index
    DOF                 double             % DOF index
    COEFFICIENTS        (1,7)double        % Polynomial coefficients
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the distributed fluxes data from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',8);
        self.DOF = data{1}(1);

        COEFF = zeros(1,7);
        COEFF(1:6) = (data{1}(3:end))';
        line = fgetl(f);
        data = textscan(line,'%15.8f',1);
        COEFF(7) = data{1};
        self.COEFFICIENTS = COEFF;
        end
    end
    
end