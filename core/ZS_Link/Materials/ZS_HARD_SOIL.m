classdef ZS_HARD_SOIL < ZS_Super_Continuum
        
    methods
        function self = ZS_HARD_SOIL(f)
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

        data = [];
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end


        self.ELASTIC.STANDARD_HS.E_UR    = data(1);
        self.ELASTIC.STANDARD_HS.v_UR    = data(2);
        self.ELASTIC.STANDARD_HS.M       = data(3);
        self.ELASTIC.STANDARD_HS.SIG_REF = data(4);
        self.ELASTIC.STANDARD_HS.SIG_L   = data(5);
        if data(10) ~= 0
            self.ELASTIC.SMALL_STRAIN.E_0      = data(8);
            self.ELASTIC.SMALL_STRAIN.GAMMA_07 = data(9);
        end
        
        n_skip = 2;
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
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        % Stiffness
        self.NON_LINEAR.STIFFNESS.E_50        = data(1);

        % Shear
        self.NON_LINEAR.SHEAR_MECHANISM.PHI   = data(7);
        self.NON_LINEAR.SHEAR_MECHANISM.PSI   = data(8);
        self.NON_LINEAR.SHEAR_MECHANISM.C     = data(5);
        self.NON_LINEAR.SHEAR_MECHANISM.R_F   = data(4);
        if logical(data(16))
        self.NON_LINEAR.SHEAR_MECHANISM.F_T   = data(6);
        end
        if logical(data(17))
        self.NON_LINEAR.SHEAR_MECHANISM.E_MAX = data(9);
        end
        self.NON_LINEAR.SHEAR_MECHANISM.D     = data(11);

        % Cap
        self.NON_LINEAR.CAP_MECHANISM.E_OED   = data(2);
        self.NON_LINEAR.CAP_MECHANISM.SIG_OED = data(3);
        self.NON_LINEAR.CAP_MECHANISM.K_0_NC  = data(12);
 
        % Initial
        if data(18) == 1
            self.NON_LINEAR.INITIAL_STATE.OCR   = data(14);
        elseif data(18) == 2
            self.NON_LINEAR.INITIAL_STATE.Q_POP = data(15);
        end
        self.NON_LINEAR.INITIAL_STATE.K0_SR = data(13);
        self.NON_LINEAR.INITIAL_STATE.P_C0_MIN = data(10);
        
        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
        
    end
end

