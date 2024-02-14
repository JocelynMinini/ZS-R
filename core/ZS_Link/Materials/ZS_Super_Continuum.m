classdef ZS_Super_Continuum < dynamicprops

    properties(SetAccess = ?ZS_Model ,Hidden = true)
    MODEL
    MAT_ID
    end
    
    methods
        
        function self = read_MAIN(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_MAIN
        % Purpose:        read the 'MAIN' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_ELAS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_ELAS
        % Purpose:        read the 'ELAS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        %{
        not_std_ELAS = ["HARD_SOIL","DENSMO_V","CAM_CLAY","AGINGCO_V"];
        boole = arrayfun(@(x) strcmp(self.MODEL,x),not_std_ELAS);
        if any(boole)
            spec_elas = true;
            return
        else
            spec_elas = false;
        end
        %}
        self.addprop("ELASTIC");

        line = fgetl(f);
        data = textscan(line,'%15.8f',2,Delimiter='');
        data = cell2mat(data);

        self.ELASTIC.E = data(1);
        self.ELASTIC.v = data(2);
        
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip);
        end

        function self = read_DENS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DENS
        % Purpose:        read the 'DENS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("UNIT_WEIGHTS");
        line = fgetl(f);
        data = textscan(line,'%15.8f',4,Delimiter='');
        data = cell2mat(data);

        anal = ZS_Model.get_analysis(f);

        if strcmp(anal,'DEF_SWTT')
            self.UNIT_WEIGHTS.GAMMA = data(1);
        else
            self.UNIT_WEIGHTS.GAMMA_D = data(1);
        end

        self.UNIT_WEIGHTS.GAMMA_F = data(2);
        self.UNIT_WEIGHTS.E_0 = data(3);
        self.UNIT_WEIGHTS.SOLID_DENSITY = data(4);

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_GEOM(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_GEOM
        % Purpose:        read the 'GEOM' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        line = fgetl(f);
        line = fgetl(f);
        end

        function self = read_FLOW(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_FLOW
        % Purpose:        read the 'FLOW' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("FLOW");
        data = [];
        for i = 1:3
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end

        problem = ZS_Model.get_problem(f);

        if strcmp(problem,'3D')
            self.FLOW.DARCY.K_X  = data(1);
            self.FLOW.DARCY.K_Y  = data(2);
            self.FLOW.DARCY.K_Z  = data(3);
            self.FLOW.DARCY.DIR  = data(4:6);
        elseif strcmp(problem,'PLANESTRAIN')
            self.FLOW.DARCY.K_X  = data(1);
            self.FLOW.DARCY.K_Y  = data(2);
            self.FLOW.DARCY.BETA = data(4);
        elseif strcmp(problem,'AXISYMETRY')
            self.FLOW.DARCY.K_X  = data(1);
            self.FLOW.DARCY.K_Y  = data(2);
            self.FLOW.DARCY.BETA = data(4);
        end

        self.FLOW.VAN_GENUCHTEN.SR    = data(9);
        self.FLOW.VAN_GENUCHTEN.ALPHA = data(10);
        self.FLOW.VAN_GENUCHTEN.N     = data(15);

        if logical(data(12))
            self.FLOW.UNDRAINED.PENALTY_FACTOR  = data(13);
            self.FLOW.UNDRAINED.SUCTION_CUT_OFF = data(14);
        end

        self.FLOW.FLUID_COMPRESSIBILITY.KF = data(8);
        if logical(data(19))
            self.FLOW.FLUID_COMPRESSIBILITY.KA = data(20);
        end

        if logical(data(21))
            self.FLOW.BIOT_COEFF.ALPHA = data(23);
            self.FLOW.BIOT_COEFF.KS    = data(22);
        end


        n_skip = 3;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_CREEP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_CREEP
        % Purpose:        read the 'CREEP' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("CREEP");
        data = [];
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end
        if data(1) == 5
            self.CREEP.B       = data(7);
            self.CREEP.K       = data(8);
            self.CREEP.SIG_0   = data(9);
            self.CREEP.SIG_C   = data(10);
            self.CREEP.ALPHA_S = data(11);
        elseif data(1) == 7 | data(1) == 8
            self.CREEP.SIG_REF = data(3);
            self.CREEP.A1      = data(6);
            self.CREEP.N1      = data(7);
            self.CREEP.Q1      = data(8);
            if data(1) == 8
            self.CREEP.A2      = data(9);
            self.CREEP.N2      = data(10);
            self.CREEP.Q2      = data(11);
            end
        elseif data(1) == 9 | data(1) == 12
            self.CREEP.INIT_AGE  = data(4);
            self.CREEP.A1        = data(6);
            self.CREEP.B         = data(7);
            self.CREEP.REF_TEMP  = data(8);
            self.CREEP.QR        = data(9);
            self.CREEP.S         = data(10);
            self.CREEP.STIFF_EXP = data(12);
        elseif data(1) == 11
            self.CREEP.PHI_REF = data(2);
        else
            self.CREEP.AD = data(6);
            self.CREEP.AV = data(3);
            self.CREEP.BD = data(7);
            self.CREEP.BV = data(4);
            self.CREEP.A  = data(8);
            self.CREEP.B  = data(9);
        end
        end

        function self = read_HEAT(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HEAT
        % Purpose:        read the 'HEAT' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HEAT");
        data = [];
        for i = 1:2
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8,Delimiter='');
            temp = cell2mat(temp);
            data = [data,temp'];
        end
        self.HEAT.ALPHA  = data(1);
        self.HEAT.LAMBDA = data(2);
        self.HEAT.C      = data(3);
        if logical(data(4))
            self.HEAT.H_INFY          = data(5);
            self.HEAT.A               = data(6);
            self.HEAT.B               = data(11);
            self.HEAT.T_D             = data(7);
            self.HEAT.QR              = data(8);
            self.HEAT.REF_TEMP        = data(9);
            %self.HEAT.FLUID_DILATANCY = data(10);
        n_skip = 2;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end
        end

        function self = read_HUMID(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_HUMID
        % Purpose:        read the 'HUMID' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("HUMIDITY");
        line = fgetl(f);
        data = textscan(line,'%15.8f',5,Delimiter='');
        data = cell2mat(data);

        self.HUMIDITY.BETA = data(1);
        self.HUMIDITY.A    = data(2);
        self.HUMIDITY.W1   = data(3);
        self.HUMIDITY.D1   = data(4);
        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        function self = read_INIS(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_INIS
        % Purpose:        read the 'INIS' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("INITIAL_K0_STATE");
        line = fgetl(f);
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        if data(7) == 1 & data(8) == 1
            self.INITIAL_K0_STATE.K0_UP = data(1);
        end

        problem = ZS_Model.get_problem(f);

        if strcmp(problem,'3D')
            self.INITIAL_K0_STATE.K0_X1  = data(1);
            self.INITIAL_K0_STATE.K0_X3  = data(2);
            self.INITIAL_K0_STATE.AXIS   = data(4:6);
        else
            self.INITIAL_K0_STATE.K0_X = data(1);
            self.INITIAL_K0_STATE.K0_Z = data(2);
            self.INITIAL_K0_STATE.BETA = data(3);
        end

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end

        %{
        function self = read_STAB(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_STAB
        % Purpose:        read the 'STAB' section but do nothing whith it
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        line = fgetl(f);
        line = fgetl(f);
        end

        function self = read_DAMP(self,f,extra_group_flag)
        %-------------------------------------------------------------------------------
        % Name:           read_DAMP
        % Purpose:        read the 'DAMP' section
        % Last Update:    22.11.2023
        %-------------------------------------------------------------------------------
        self.addprop("DAMPING");
        line = fgetl(f);
        data = textscan(line,'%15.8f',8,Delimiter='');
        data = cell2mat(data);

        self.DAMPING.ALPHA_0 = data(1);
        self.DAMPING.BETA_0  = data(2);

        n_skip = 1;
        ZS_Model.read_extra_group(f,extra_group_flag,n_skip)
        end
        %}

    end 
end

