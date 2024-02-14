classdef ZS_PLAS_HB_V < ZS_Super_Continuum
        
    methods
        function self = ZS_PLAS_HB_V(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_PLAS_HB_V
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
        for i = 1:6
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        % HB
        self.NON_LINEAR.HB.SIG_CI = data(1);
        if data(17) ~= 1
            self.NON_LINEAR.HB.M_B = data(2);
            self.NON_LINEAR.HB.S   = data(3);
            self.NON_LINEAR.HB.A   = data(4);
        end
        % Hardening
        if data(17) == 1
            self.NON_LINEAR.HARDENING.MB_0     = data(18);
            self.NON_LINEAR.HARDENING.S_0      = data(19);
            self.NON_LINEAR.HARDENING.A_0      = data(20);
            self.NON_LINEAR.HARDENING.GAMMA_R  = data(10);
        elseif data(17) == 2
            self.NON_LINEAR.HARDENING.R_0      = data(21);
            self.NON_LINEAR.HARDENING.GAMMA_R  = data(10);
        elseif data(17) == 3
            self.NON_LINEAR.HARDENING.ZETA_1   = data(22);
            self.NON_LINEAR.HARDENING.ZETA_2   = data(24);
            self.NON_LINEAR.HARDENING.R_1      = data(23);
            self.NON_LINEAR.HARDENING.R_2      = data(25);
            self.NON_LINEAR.HARDENING.GAMMA_R  = data(10);
        end

        % Softening
       if logical(data(26))
            self.NON_LINEAR.SOFTENING.M_BRES    = data(27);
            self.NON_LINEAR.SOFTENING.S_RES     = data(28);
            self.NON_LINEAR.SOFTENING.A_RES     = data(29);
            self.NON_LINEAR.SOFTENING.ALPHA_R   = data(31);
            self.NON_LINEAR.SOFTENING.GAMMA_RES = data(27);
            self.NON_LINEAR.SOFTENING.SIG_3     = data(30);
        end

        % Rankine cut-off
        if logical(data(5))
            self.NON_LINEAR.RANKINE_CRITERION.F_T = data(6);
        end

        % Dilatancy
        self.NON_LINEAR.DILATANCY.PSI = data(8);
        if data(7) == 1 % Contant
            %
        else data(7) == 2 % Stress dpdnt
            self.NON_LINEAR.DILATANCY.SIG_PSI = data(15);
        end

        if logical(data(9)) % Contant
            self.NON_LINEAR.DILATANCY.GAMMA_0   = [data(12)];
            self.NON_LINEAR.DILATANCY.GAMMA_R   = [data(10),data(13)];
            self.NON_LINEAR.DILATANCY.GAMMA_RES = [data(11),data(14)];
        end

        n_skip = 6;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

    end
end

