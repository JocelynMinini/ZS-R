classdef ZS_ANISOTR_M < ZS_Super_Membrane
        
    methods
        function self = ZS_ANISOTR_M(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ANISOTR_M
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

        function self = read_GEOM(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_GEOM
        % Purpose:        read the 'GEOM' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('GEOMETRY');

        line = fgetl(f);
        data = textscan(line,'%15.8f',3,Delimiter='');
        data = cell2mat(data);

        self.GEOMETRY.DIRECTION = data';
        
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

        line = fgetl(f);
        data = textscan(line,'%15.8f',5,Delimiter='');
        data = cell2mat(data);

        self.NON_LINEAR.F_TX = data(2);
        self.NON_LINEAR.F_TY = data(4);
        self.NON_LINEAR.F_CX = data(3);
        self.NON_LINEAR.F_CY = data(5);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

