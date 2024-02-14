classdef ZS_CONCRA_1D < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAIN
    MAT_ID
    end

    methods
        function self = ZS_CONCRA_1D(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_EPL_FIB_B
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

        function self = read_ELAS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_ELAS
        % Purpose:        read the 'ELAS' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('ELASTIC');

        line = fgetl(f);
        data = textscan(line,'%15.8f',1,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.E = data(1);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_MAIN(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_MAIN
        % Purpose:        read the 'MAIN' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        data = textscan(line,'%15.8f',5,Delimiter='');
        data = cell2mat(data);

        self.MAIN.N_EPS_T = data(1);
        self.MAIN.N_EPS_C = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_CREEP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_CREEP
        % Purpose:        read the 'CREEP' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('CREEP');

        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        self.CREEP.A = data(3);
        self.CREEP.B = data(4);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('NON_LINEAR');


        n_eps_t = self.MAIN.N_EPS_T;
        n_eps_c = self.MAIN.N_EPS_C;

        data = [];
        count = 0;
        for i = 1:n_eps_t
            line = fgetl(f);
            temp = textscan(line,'%15.8f',2,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
            count = count + 1;
        end

        data = reshape(data,[2,n_eps_t]);
        data = data';
        self.NON_LINEAR.SIG_EPS_T = data;

        data = [];
        for i = 1:n_eps_c
            line = fgetl(f);
            temp = textscan(line,'%15.8f',2,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
            count = count + 1;
        end

        data = reshape(data,[2,n_eps_c]);
        data = data';
        self.NON_LINEAR.SIG_EPS_C = data;
        
        
        n_skip = count;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

