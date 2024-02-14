classdef ZS_Super_Beam < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end
    
    methods
        

        function self = read_DENS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DENS
        % Purpose:        read the 'DENS' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('UNIT_WEIGHTS');

        line = fgetl(f);
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        self.UNIT_WEIGHTS.GAMMA = data(1);
        
        n_skip = 1;
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

