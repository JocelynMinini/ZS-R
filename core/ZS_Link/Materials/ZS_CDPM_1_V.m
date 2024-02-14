classdef ZS_CDPM_1_V < ZS_Super_Continuum
        
    methods
        function self = ZS_CDPM_1_V(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_CDPM_1_V
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
        self.addprop("NON_LINEAR");

        data = [];
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end
        
        % COMPRESSIVE_STRENGTH
        self.NON_LINEAR.COMPRESSIVE_STRENGTH.F_C       = data(2);
        self.NON_LINEAR.COMPRESSIVE_STRENGTH.F_C0_F_C  = data(3);
        self.NON_LINEAR.COMPRESSIVE_STRENGTH.F_CB_F_C  = data(5);

        % COMPRESSION_DAMMAGE
        self.NON_LINEAR.COMPRESSION_DAMMAGE.SIG_CD_F_C = data(4);
        self.NON_LINEAR.COMPRESSION_DAMMAGE.SIG_C_F_C  = data(7);
        self.NON_LINEAR.COMPRESSION_DAMMAGE.D_C        = data(8);
        self.NON_LINEAR.COMPRESSION_DAMMAGE.G_C        = data(6);

        % COMPRESSION_DAMMAGE
        self.NON_LINEAR.CALIBRATION.E_C1               = data(1);

        % TENSILE_STRENGTH
        self.NON_LINEAR.TENSILE_STRENGTH.F_T           = data(10);

        % TENSION_DAMMAGE
        self.NON_LINEAR.TENSION_DAMMAGE.SIG_T_F_T      = data(12);
        self.NON_LINEAR.TENSION_DAMMAGE.D_T            = data(13);
        self.NON_LINEAR.TENSION_DAMMAGE.G_T            = data(11);
        self.NON_LINEAR.TENSION_DAMMAGE.S_0            = data(14);

        % DILATANCY
        if data(15) == 1
            self.NON_LINEAR.DILATANCY.ALPHA_P          = data(4);
            self.NON_LINEAR.DILATANCY.ALPHA_D          = data(4);
        elseif data(15) == 2
            self.NON_LINEAR.DILATANCY.ALPHA_P0         = data(17);
            self.NON_LINEAR.DILATANCY.ALPHA_P          = data(18);
            self.NON_LINEAR.DILATANCY.SIG_DILC_F_C      = data(16);
            self.NON_LINEAR.DILATANCY.ALPHA_D          = data(19);
        end

        if logical(data(23))
            self.NON_LINEAR.L_RC                       = data(24);
        end

        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end
        
    end
end

