classdef ZS_ORT10ELAS < ZS_Super_Continuum
        
    methods
        function self = ZS_ORT10ELAS(f)
        %-------------------------------------------------------------------------------
        % Name:           ZS_ORT10ELAS (Margaux)
        % Purpose:        Constructor
        % Last Update:    08.02.2024
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
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end


        self.ELASTIC.EL    = data(1);
        self.ELASTIC.ER    = data(2);
        self.ELASTIC.ET    = data(3);

        self.ELASTIC.GRT   = data(4);
        self.ELASTIC.GTL   = data(5);
        self.ELASTIC.GLR   = data(6);

        self.ELASTIC.NRL   = data(7); 
        self.ELASTIC.NLR   = data(8);
        self.ELASTIC.NTL   = data(9);
        self.ELASTIC.NLT   = data(10);
        self.ELASTIC.NTR   = data(11);
        self.ELASTIC.NRT   = data(12);

        self.ELASTIC.vLx   = data(13);
        self.ELASTIC.vLy   = data(14);
        self.ELASTIC.vLz   = data(15);

        self.ELASTIC.vRx   = data(16);
        self.ELASTIC.vRy   = data(17);
        self.ELASTIC.vRz   = data(18);

        self.ELASTIC.R_T   = data(19);

        self.ELASTIC.PLAS  = data(20);
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
        self.NON_LINEAR.F_TL   = data(1);
        self.NON_LINEAR.F_TR   = data(2);
        self.NON_LINEAR.F_TT   = data(3);
        self.NON_LINEAR.F_CL   = data(4);
        self.NON_LINEAR.F_CR   = data(5);
        self.NON_LINEAR.F_CT   = data(6);
        self.NON_LINEAR.F_SLR  = data(7);
        self.NON_LINEAR.F_SRT  = data(8);
        self.NON_LINEAR.F_STL  = data(9);

        self.NON_LINEAR.BETA   = data(10);
        self.NON_LINEAR.M      = data(11);

        self.NON_LINEAR.G_FL   = data(12);
        self.NON_LINEAR.G_FR   = data(13);
        self.NON_LINEAR.G_FT   = data(14);

        self.NON_LINEAR.N      = data(15);

        self.NON_LINEAR.ALPHA  = data(16);

        self.NON_LINEAR.H      = data(17);

        self.NON_LINEAR.Q_PLAS = data(18);
        self.NON_LINEAR.B_PLAS = data(19);

        self.NON_LINEAR.A      = data(20);
        self.NON_LINEAR.B      = data(21);
        
        self.NON_LINEAR.OPT1   = data(22);
        self.NON_LINEAR.OPT2   = data(23);
        self.NON_LINEAR.OPT3   = data(24);
        end
        
    end
end

