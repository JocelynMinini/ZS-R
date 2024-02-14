classdef ZS_CONTACT_S < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end

    methods
        function self = ZS_CONTACT_S(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_CONTACT_S
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
        data = textscan(line,'%15.8f',3,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.K_N     = data(1);
        self.ELASTIC.K_T_K_N = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_DENS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DENS
        % Purpose:        read the 'DENS' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('UNIT_WEIGHTS');

        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        self.UNIT_WEIGHTS.GAMMA_F = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_FLOW(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_FLOW
        % Purpose:        read the 'FLOW' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('FLOW');

        data = [];
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        problem = ZS_Model.get_problem(f);

        if data(4) ~= 0
            self.FLOW.PERMEABILITIES.K_X = data(1);
            self.FLOW.PERMEABILITIES.K_Z = data(3);
            if strcmp(problem,'3D') & data(4) == 2
                self.FLOW.PERMEABILITIES.K_Y = data(2);
            end
        end

        if data(4) == 2
            self.FLOW.ORIENTATION = [data(5),data(6),data(7)];
        end
        
        self.FLOW.VAN_GENUCHTEN.S_R   = data(9);
        self.FLOW.VAN_GENUCHTEN.ALPHA = data(10);
        self.FLOW.VAN_GENUCHTEN.N     = data(15);

        if logical(data(21))
            self.FLOW.BIOT_COEFF = data(23);
        end
        
        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        DYN = self.addprop('NON_LINEAR');

        line = fgetl(f);
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        if data(4) ~= 1 & data(6) == 0
            self.NON_LINEAR.PHI = data(1);
            self.NON_LINEAR.PSI = data(2);
            self.NON_LINEAR.C   = data(3);
        end

        if data(4) == 2
            self.NON_LINEAR.F_T = data(7);
            self.NON_LINEAR.F_C = data(8);
        elseif data(4) == 1
            self.NON_LINEAR.DIAMETER = data(7);
        end

        if isempty(self.NON_LINEAR)
            delete(DYN)
        end
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end





    end
end

