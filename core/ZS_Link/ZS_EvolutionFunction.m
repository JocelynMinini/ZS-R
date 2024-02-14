classdef ZS_EvolutionFunction

    properties(SetAccess = protected)
    ID                 % EVF Number
    end

    properties
    %NR                 % Number of points in the EVF
    EXPRESSION         % String of the expression
    EVF          (:,2) % Matrix of the evolution function
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the EVF data from the .dat file.
        % Last Update:    06.09.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);

        data = textscan(line,'%u %s %u %u %s');

        self.ID         = data{1};
        NR              = data{3};
        self.EXPRESSION = data{5}{1};

        data = [];
        for i = 1:NR
            line = fgetl(f);
            temp = textscan(line,'%u %f %f');
            data = [data;temp{2:end}];
        end
        self.EVF = data;  
        end
   end
    
end