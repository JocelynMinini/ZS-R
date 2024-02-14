classdef ZS_MLT_MEN_V < ZS_Super_Continuum
        
    methods
        function self = ZS_MLT_MEN_V(f)
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
        for i = 1:5
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        flag = data(1);

        switch flag
        case 4 % Mohr-Coulomb
            self.NON_LINEAR.YIELD.PHI = data(4);
            self.NON_LINEAR.YIELD.C   = data(3);
            if logical(data(2))
                self.NON_LINEAR.YIELD.F_T = data(13);
            end
            if logical(data(8))
                self.NON_LINEAR.PLASTIC_FLOW.PSI = data(9);
            end
        case 6 % Hoek-Brown
            self.NON_LINEAR.YIELD.F_C   = data(6);
            self.NON_LINEAR.YIELD.F_T   = data(5);
            self.NON_LINEAR.YIELD.E     = data(7);
            if data(2) == 1 % Cut off
                self.NON_LINEAR.YIELD.I_1t = data(14);
            end
            if data(8) == 1 | data(8) == 4 % Flow
                self.NON_LINEAR.PLASTIC_FLOW.PSI = data(9);
            end
            if data(2) == 2 % Softening
                self.NON_LINEAR.SOFTENING.W_R = data(14);
                self.NON_LINEAR.SOFTENING.A   = data(15);
                self.NON_LINEAR.SOFTENING.B   = data(16);
            end
        case 3 % Rankine
            self.NON_LINEAR.YIELD.F_T = data(5);
            if data(2) == 2
                self.NON_LINEAR.SOFTENING.W_R = data(14);
                self.NON_LINEAR.SOFTENING.A   = data(15);
                self.NON_LINEAR.SOFTENING.B   = data(16);
            end
        end

        data = data(17:end);
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

        n_skip = 5;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

