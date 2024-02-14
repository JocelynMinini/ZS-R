classdef ZS_ELASTIC_B < ZS_Super_Beam
        
    methods
        function self = ZS_ELASTIC_B(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ELASTIC_B
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
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.E = data(1);
        self.ELASTIC.v = data(2);
        
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

        data = [];
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',4,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        problem = ZS_Model.get_problem(f);

        self.CROSS_SECTION.A_X            = data(1);
        self.CROSS_SECTION.A_Y            = data(2);
        if strcmp(problem,'3D')
            self.CROSS_SECTION.A_Z        = data(3);
            self.CROSS_SECTION.I_X        = data(5);
            self.CROSS_SECTION.I_Y        = data(6);
        end
        self.CROSS_SECTION.I_Z            = data(7);
        if strcmp(problem,'PLANESTRAIN')
            self.CROSS_SECTION.B          = data(4);
        end
        self.CROSS_SECTION.H              = data(8);
        
        n_skip = 2;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end


    end
end

