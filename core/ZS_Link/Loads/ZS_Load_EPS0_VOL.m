classdef ZS_Load_EPS0_VOL    
%-------------------------------------------------------------------------------
% Purpose:        For imposed strains on Q4/B8 super-element [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "EPS0_VOL"                     % Load class
    LTF                 {mustBeInteger}    % Load time function index
    X                   (1,8)double        % the x-coordinate of the k-th vertex of Q4 or B8 super-element
    Y                   (1,8)double        % the y-coordinate of the k-th vertex of Q4 or B8 super-element
    Z                   (1,8)double        % the z-coordinate of the k-th vertex of Q4 or B8 super-element
    EPS_XX              (1,8)double 
    EPS_YY              (1,8)double 
    GAM_XY              (1,8)double  
    EPS_ZZ              (1,8)double 
    GAM_XZ              (1,8)double 
    GAM_YZ              (1,8)double 
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imposed strains data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        
        field = {"X","Y","Z","EPS_XX","EPS_YY","GAM_XY","EPS_ZZ","GAM_XZ","GAM_YZ"};

        for i = 1:length(field)
            line = fgetl(f);
            data = textscan(line,'%15.8f',8);
            self.(field{i}) = data{1}';
        end
        end
    end
    
end