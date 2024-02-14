classdef ZS_SEEPAGE_S

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end
        
    methods
        function self = ZS_SEEPAGE_S(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_SEEPAGE_S
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

        function self = read_FLOW(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_FLOW
        % Purpose:        read the 'FLOW' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("FLOW");

        line = fgetl(f);
        data = textscan(line,'%15.8f',2,Delimiter='');
        data = cell2mat(data);

        if data(2) == 0
            self.FLOW.EPS = data(1);
        elseif data(2) == 1
            self.FLOW.K_V = data(1);
        elseif data(2) == 2
            %
        end

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

       
    end
end

