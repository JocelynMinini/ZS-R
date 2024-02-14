classdef ZS_Load_C_SIG0_VOL    
%-------------------------------------------------------------------------------
% Purpose:        For imposed stresses set on element [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Load number
    LABEL = "C_SIG0_VOL"                   % Load class
    LTF                 {mustBeInteger}    % Load time function index
    SIG_XX              double 
    SIG_YY              double 
    TAU_XY              double  
    SIG_ZZ              double 
    TAU_XZ              double 
    TAU_YZ              double 
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the imposed stresses set on el data from the .dat file.
        % Last Update:    06.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        
        field = {"SIG_XX","SIG_YY","TAU_XY","SIG_ZZ","TAU_XZ","TAU_YZ"};

        line = fgetl(f);
        data = textscan(line,'%15.8f',6);
        
        for i = 1:length(field)
            self.(field{i}) = data{1}(i);
        end

        fgetl(f);
        end

    end
    
end