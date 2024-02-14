classdef ZS_ORTHO_E_S < ZS_Super_Shell
        
    methods
        function self = ZS_ORTHO_E_S(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ORTHO_E_S
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
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("ELASTIC");

        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.E_1 = data(1);
        self.ELASTIC.E_2 = data(2);
        self.ELASTIC.v   = data(3);
        self.ELASTIC.G   = data(4);
        
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

        line = fgetl(f);
        data = textscan(line,'%15.8f',3,Delimiter='');
        data = cell2mat(data);

        self.GEOMETRY.VECTOR = [data(1),data(2),data(3)];
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
       
    end
end

