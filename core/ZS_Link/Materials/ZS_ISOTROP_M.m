classdef ZS_ISOTROP_M < ZS_Super_Membrane
        
    methods
        function self = ZS_ISOTROP_M(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ISOTROP_M
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

       
        function self = read_NONL(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_NONL
        % Purpose:        read the 'NONL' section
        % Last Update:    24.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('NON_LINEAR');

        line = fgetl(f);
        data = textscan(line,'%15.8f',3,Delimiter='');
        data = cell2mat(data);

        self.NON_LINEAR.F_C = data(2);
        self.NON_LINEAR.F_T = data(3);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

