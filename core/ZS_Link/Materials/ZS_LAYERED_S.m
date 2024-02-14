classdef ZS_LAYERED_S < ZS_Super_Shell
        
    methods
        function self = ZS_LAYERED_S(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_LAYERED_S
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
        % Purpose:        read the 'ELAS' section and return nothing
        %                 because of the layered section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        end

        function self = read_MAIN(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_MAIN
        % Purpose:        read the 'MAIN' section (same as for layered
        %                 beams)
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        DYN = self.addprop('MAIN');
        DYN.Hidden = true;
        
        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        n_layers = data(1);
        n_reinforcements_layers = data(4);

        self.MAIN.N_CORE_LAYERS = n_layers-n_reinforcements_layers;
        self.MAIN.N_REINFORCEMENTS_LAYERS = n_reinforcements_layers;

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_GEOM(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_GEOM
        % Purpose:        read the 'GEOM' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("GEOMETRY");

        count = 0;
        % Core material
        n_core = self.MAIN.N_CORE_LAYERS;
        for i = 1:n_core
            line = fgetl(f);
            data = textscan(line,'%15.8f',5,Delimiter='');
            data = cell2mat(data);
            self.GEOMETRY.CORE_LAYERS.(['L',num2str(i)]).Z        = data(1);
            self.GEOMETRY.CORE_LAYERS.(['L',num2str(i)]).A        = data(2);
            self.GEOMETRY.CORE_LAYERS.(['L',num2str(i)]).MODEL_ID = data(3);
            count = count + 1;
        end

        % Reinforcement material
        n_reinforcements = self.MAIN.N_REINFORCEMENTS_LAYERS;
        for i = 1:n_reinforcements
            line = fgetl(f);
            data = textscan(line,'%15.8f',6,Delimiter='');
            data = cell2mat(data);
            self.GEOMETRY.REINFORCEMENTS_LAYERS.(['L',num2str(i)]).Z         = data(1);
            self.GEOMETRY.REINFORCEMENTS_LAYERS.(['L',num2str(i)]).A         = data(2);
            self.GEOMETRY.REINFORCEMENTS_LAYERS.(['L',num2str(i)]).MODEL_ID  = data(3);
            count = count + 1;
        end
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
       
    end
end

