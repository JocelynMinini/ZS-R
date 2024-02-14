classdef ZS_PLA_CAP_V < ZS_Super_Continuum
        
    methods
        function self = ZS_PLA_CAP_V(f)
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
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        self.NON_LINEAR.YIELD.PHI = data(2);
        self.NON_LINEAR.YIELD.C   = data(3);

        if logical(data(5))
            self.NON_LINEAR.YIELD.F_T = data(6);
        end

        self.NON_LINEAR.PLASITC_FLOW.PSI = data(4);

        % Cap
        self.NON_LINEAR.CAP.LAMBA = data(7);
        self.NON_LINEAR.CAP.P_C0  = data(8);
        self.NON_LINEAR.CAP.R     = data(9);
        self.NON_LINEAR.CAP.OCR   = data(11);

        n_skip = 2;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

