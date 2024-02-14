classdef ZS_Super_Membrane < dynamicprops

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
        % Purpose:        read the 'DENS' section (same as for continuum)
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("UNIT_WEIGHTS");
        temp = ZS_Super_Shell;
        temp = temp.read_DENS(f,extra_group_flag);

        self.UNIT_WEIGHTS = temp.UNIT_WEIGHTS;
        end

        function self = read_HEAT(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HEAT
        % Purpose:        read the 'HEAT' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HEAT");

        temp = ZS_Super_Shell;
        temp = temp.read_HEAT(f,extra_group_flag);

        self.HEAT = temp.HEAT;
        end

        function self = read_HUMID(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HUMID
        % Purpose:        read the 'HUMID' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HUMIDITY");

        temp = ZS_Super_Shell;
        temp = temp.read_HUMID(f,extra_group_flag);

        self.HUMIDITY = temp.HUMIDITY;
        end

        function self = read_DAMP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DAMP
        % Purpose:        read the 'DAMP' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("DAMPING");
        
        temp = ZS_Super_Continuum;
        temp = temp.read_DAMP(f,extra_group_flag);

        self.DAMPING = temp.DAMPING;
        end

    end 
end

