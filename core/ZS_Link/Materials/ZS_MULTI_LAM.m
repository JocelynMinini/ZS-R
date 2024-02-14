classdef ZS_MULTI_LAM < ZS_Super_Continuum
        
    methods
        function self = ZS_MULTI_LAM(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_MLT_MEN_V
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
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop('NON_LINEAR');
        data = [];
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        data = reshape(data,[7,3]);
        data = data';
        for i = 1:3
            if any(data(i,:))
                self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).ALPHA_K = data(i,1);
                self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).BETA_K  = data(i,2);
                self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).PHI_K   = data(i,3);
                self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).C_K     = data(i,5);
                self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).PSI_K   = data(i,4);
                if logical(data(i,6))
                    self.NON_LINEAR.(['WEAK_PLANE_',num2str(i)]).F_T = data(i,7);
                end
            end
        end

        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

