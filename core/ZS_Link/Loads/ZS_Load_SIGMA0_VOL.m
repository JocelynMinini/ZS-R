classdef ZS_Load_SIGMA0_VOL    
%-------------------------------------------------------------------------------
% Purpose:        For initial effective stresses [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "SIGMA0_VOL"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    X                   (1,8)double        % the x-coordinate of the k-th vertex of Q4 or B8 super-element
    Y                   (1,8)double        % the y-coordinate of the k-th vertex of Q4 or B8 super-element
    Z                   (1,8)double        % the z-coordinate of the k-th vertex of Q4 or B8 super-element
    SIG_XX              (1,8)double 
    SIG_YY              (1,8)double 
    TAU_XY              (1,8)double  
    SIG_ZZ              (1,8)double 
    TAU_XZ              (1,8)double 
    TAU_YZ              (1,8)double 
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the initial effective stresses data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        
        field = {"X","Y","Z","SIG_XX","SIG_YY","TAU_XY","SIG_ZZ","TAU_XZ","TAU_YZ"};

        for i = 1:length(field)
            line = fgetl(f);
            data = textscan(line,'%15.8f',8);
            self.(field{i}) = data{1}';
        end
        end
    end
    
end