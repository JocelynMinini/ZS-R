classdef ZS_AGINGCO_V < ZS_Super_Continuum
        
    methods
        function self = ZS_AGINGCO_V(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_AGINGCO_V
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

        data = [];
        for i = 1:12
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        n_Maxwell = data(end-2);
        n_maturity = data(end-1);

        mat = data(3+n_Maxwell:end-3);
        mat = reshape(mat,[8,10]);
        mat = mat';

        self.ELASTIC.v      = data(2);
        self.ELASTIC.TAU    = data(3:2+n_Maxwell);

        self.ELASTIC.MATRIX    = mat;
        self.ELASTIC.N_MAXWELL = n_Maxwell;
        self.ELASTIC.N_POINTS  = n_maturity;
        
        n_skip = 12;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("NON_LINEAR");

        data = [];
        for i = 1:14
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end
        
        self.NON_LINEAR.M        = data(5:2:end);
        self.NON_LINEAR.F_T      = data(6:2:end);
        self.NON_LINEAR.N_POINTS = data(1);
        self.NON_LINEAR.QR       = data(3);
        self.NON_LINEAR.REF_TEMP = data(4);
        
        n_skip = 14;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
        
    end
end

