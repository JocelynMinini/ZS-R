classdef ZS_PLAS_MC_V < ZS_Super_Continuum
        
    methods
        function self = ZS_PLAS_MC_V(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_PLAS_MC_V
        % Purpose:        Constructor
        % Last Update:    22.11.2023
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
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        self.NON_LINEAR.YIELD.PHI = data(3);
        self.NON_LINEAR.YIELD.C   = data(2);

        if logical(data(5))
            self.NON_LINEAR.YIELD.F_T = data(6);
        end

        self.NON_LINEAR.PLASITC_FLOW.PSI = data(4);

        if logical(data(7))
            self.NON_LINEAR.PLASITC_FLOW.E_MAX = data(8);
        end
        
        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

