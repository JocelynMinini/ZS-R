classdef ZS_ELASLIN < ZS_Super_Continuum
        
    methods
        function self = ZS_ELASLIN(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ELASLIN (Margaux)
        % Purpose:        Constructor
        % Last Update:    08.02.2024
        %-------------------------------------------------------------------------------
        done = false;
        while ~done
        line = fgetl(f);
        data = textscan(line,'%s %f');
        extra_group_flag = data{2};

        group_label = line(1:5);
        group_eval = ['self.read_',strtrim(group_label),'(f,extra_group_flag)'];
        try
            self = eval(group_eval);
        catch ME
            %
        end
        done = strcmp(group_label,'     ') | strcmp(group_label,'PILES');
        end
        fseek(f,-length(line),0);
        end
        

        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('NON_LINEAR');
        data = [];
        for i = 1
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        self.NON_LINEAR.SIG_Y = data(1);
        self.NON_LINEAR.H     = data(2);
        self.NON_LINEAR.OPT   = data(3);
        end

    end
end

