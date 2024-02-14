classdef ZS_CAM_CLAY < ZS_Super_Continuum
        
    methods
        function self = ZS_CAM_CLAY(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_CAM_CLAY
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
        data = textscan(line,'%15.8f',2,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.v = data(1);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("NON_LINEAR");

        line = fgetl(f);
        data = textscan(line,'%15.8f',6,Delimiter='');
        data = cell2mat(data);

        self.NON_LINEAR.M_C    = data(1);
        self.NON_LINEAR.LAMBDA = data(3);
        self.NON_LINEAR.KAPPA  = data(4);
        self.NON_LINEAR.P_C0   = data(5);
        self.NON_LINEAR.OCR    = data(6);
        self.NON_LINEAR.K      = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
        
    end
end

