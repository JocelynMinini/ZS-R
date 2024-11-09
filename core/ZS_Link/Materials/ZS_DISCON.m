classdef ZS_DISCON < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end
        
    methods
        function self = ZS_DISCON(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_DISCON
        % Purpose:        Constructor
        % Last Update:    06.10.2024
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
        done = strcmp(group_label,'     ') | strcmp(group_label,'ELASTIC_B');
        end
        fseek(f,-length(line),0);
        end

        function self = read_ELAS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_ELAS
        % Purpose:        read the 'ELAS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("ELAS");
        dof = 5;

        self.ELAS = zeros(dof,6);
        for i = 1:dof
            line = fgetl(f);
            data = textscan(line,'%15.8f',6,Delimiter='');
            data = cell2mat(data);
            self.ELAS(i,:) = data;
        end


        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

       
    end
end

