classdef ZS_EPL_TRUSS < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end

    methods
        function self = ZS_EPL_TRUSS(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_EPL_TRUSS
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

        self.UNIT_WEIGHTS.GAMMA = data(1);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_GEOM(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_GEOM
        % Purpose:        read the 'GEOM' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('CROSS_SECTION');

        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        problem = ZS_Model.get_problem(f);

        self.CROSS_SECTION.A              = data(1);
        if strcmp(problem,'PLANESTRAIN')
            self.CROSS_SECTION.B          = data(4);
        end
        
        n_skip = 2;
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

        data = [];
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        self.NON_LINEAR.F_C = data(2);
        self.NON_LINEAR.F_T = data(3);

        if logical(data(1))
            self.NON_LINEAR.FIRE.F_T0_F_T = data(5);
            self.NON_LINEAR.FIRE.F_C0_F_C = data(6);
            self.NON_LINEAR.FIRE.EPS_Y    = data(7);
            self.NON_LINEAR.FIRE.EPS_E    = data(8);
            self.NON_LINEAR.FIRE.EPS_U    = data(9);
        end
        
        n_skip = 2;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_HEAT(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HEAT
        % Purpose:        read the 'HEAT' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('HEAT');

        line = fgetl(f);
        data = textscan(line,'%15.8f',1,Delimiter='');
        data = cell2mat(data);

        self.HEAT.ALPHA = data(1);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_STAB(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_STAB
        % Purpose:        read the 'STAB' section but do nothing
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        %self.addprop('STABILITY');

        fgetl(f); % Do nothing
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_DAMP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DAMP
        % Purpose:        read the 'DAMP' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('DAMPING');

        line = fgetl(f);
        data = textscan(line,'%15.8f',2,Delimiter='');
        data = cell2mat(data);

        self.DAMPING.ALPHA_0 = data(1);
        self.DAMPING.BETA_0  = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

