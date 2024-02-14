classdef ZS_EPL_FIB_S < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end

    methods
        function self = ZS_EPL_FIB_S(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_EPL_FIB_S
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

        function self = read_GEOM(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_GEOM
        % Purpose:        read the 'GEOM' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('GEOMETRY');

        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);
        data = data';

        self.GEOMETRY.DIRECTION = data(1:3);
        
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

        if data(1) == 1
            self.NON_LINEAR.FIRE.F_T0_F_T = data(5);
            self.NON_LINEAR.FIRE.F_T0_F_T = data(6);
            self.NON_LINEAR.FIRE.EPS_Y    = data(7);
            self.NON_LINEAR.FIRE.EPS_U    = data(8);
            self.NON_LINEAR.FIRE.EPS_E    = data(9);
        end  
        
        n_skip = 2;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end




    end
end

