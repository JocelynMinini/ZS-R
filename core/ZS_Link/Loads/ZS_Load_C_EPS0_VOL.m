classdef ZS_Load_C_EPS0_VOL    
%-------------------------------------------------------------------------------
% Purpose:        For imposed strains set on element [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "C_EPS0_VOL"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    EPS_XX              double 
    EPS_YY              double 
    GAM_XY              double  
    EPS_ZZ              double 
    GAM_XZ              double 
    GAM_YZ              double 
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imposed strains set on el data from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        
        field = {"EPS_XX","EPS_YY","GAM_XY","EPS_ZZ","GAM_XZ","GAM_YZ"};

        line = fgetl(f);
        data = textscan(line,'%15.8f',6);

        for i = 1:length(field)
            self.(field{i}) = data{1}(i);
        end
        end

    end
    
end