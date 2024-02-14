classdef ZS_Super_Shell < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end
    
    methods
        
        function self = read_MAIN(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_MAIN
        % Purpose:        read the 'MAIN' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_ELAS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_ELAS
        % Purpose:        read the 'ELAS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("ELASTIC");

        line = fgetl(f);
        data = textscan(line,'%15.8f',2,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.E = data(1);
        self.ELASTIC.v = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_DENS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DENS
        % Purpose:        read the 'DENS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("UNIT_WEIGHTS");
        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        self.UNIT_WEIGHTS.GAMMA = data(1); 

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_FLOW(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_FLOW
        % Purpose:        read the 'FLOW' section (same as for CONTACT flow)
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

        function self = read_HEAT(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HEAT
        % Purpose:        read the 'HEAT' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HEAT");

        line = fgetl(f);
        data = textscan(line,'%15.8f',1,Delimiter='');
        data = cell2mat(data);

        self.HEAT.ALPHA = data(1);


        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_HUMID(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HUMID
        % Purpose:        read the 'HUMID' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HUMIDITY");

        line = fgetl(f);
        data = textscan(line,'%15.8f',1,Delimiter='');
        data = cell2mat(data);

        self.HUMIDITY.DILATANCY = data(1);


        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_DAMP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DAMP
        % Purpose:        read the 'DAMP' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("DAMPING");
        line = fgetl(f);
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        self.DAMPING.ALPHA_0 = data(1);
        self.DAMPING.BETA_0  = data(2);

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

    end 
end

