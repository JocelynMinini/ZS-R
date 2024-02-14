classdef ZS_Load_INIT_COND    
%-------------------------------------------------------------------------------
% Purpose:        For nodal initial conditions on Q4/B8 super-element [OK]
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "INIT_COND "                   % Element class
    LTF                 {mustBeInteger}    % Load time function index
    EXF                 {mustBeInteger}    % Existence function index
    TIME_DERIV_ORDER    double             % 0 for the initial displacement, pressure, temperature or humidity and 1 for the velocity
    DOF                 double             % the index of the global degree of freedom for which the initial condition
    X                   double        % the x-coordinate of the k-th vertex of Q4 or B8 super-element
    Y                   double        % the y-coordinate of the k-th vertex of Q4 or B8 super-element
    Z                   double        % the z-coordinate of the k-th vertex of Q4 or B8 super-element
    V                   double        % the given initial nodal value at k-th vertex of Q4 or B8 super-element
    end

    methods
        function self = read(self,f,data)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the initial conditions data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        self.ID  = data{1};
        self.LTF = data{2};
        self.EXF = data{4};

        line = fgetl(f);
        data = textscan(line,'%15.8f',2);
        self.TIME_DERIV_ORDER = data{1}(1);
        self.DOF              = data{1}(2);
        
        field = {"X","Y","Z","V"};

        for i = 1:4
            line = fgetl(f);
            data = textscan(line,'%15.8f',8);
            self.(field{i}) = data{1}';
        end
        end
    end
    
end