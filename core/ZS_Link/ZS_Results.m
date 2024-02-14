classdef ZS_Results < dynamicprops

    properties
    OPTIONS
    end

    methods

    function self = Init_s00(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s00
    % Purpose:        Instanciate the NODAL class dynamically if Init_s00
    %                 is called and get the nodal results
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('NODAL_s00');
    self.NODAL_s00 = ZS_Nodal_s00;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s00'];
    if ~isfile(f)
        error("No nodal results file (.s00) was found.")
    end
    f = fopen(f, 'rb');
    s00 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Nodal;
    
    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);

    % Get the results
    self.NODAL_s00 = self.NODAL_s00.get_s00(s00,LINK_OBJ,OPTS);
    end

    function self = Init_r00(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_r00
    % Purpose:        Instanciate the REACTION class dynaically and get the
    %                 reaction results
    % Last Update:    10.11.2023
    %-------------------------------------------------------------------------------
    self.addprop('REACTION_r00');
    self.REACTION_r00 = ZS_Reaction_r00;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.r00'];
    if ~isfile(f)
        error("No nodal reaction file (.r00) was found.")
    end
    f = fopen(f, 'rb');
    r00 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Reaction;

    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);
    
    % Get the results
    self.REACTION_r00 = self.REACTION_r00.get_r00(r00,LINK_OBJ,OPTS);
    end

    function self = Init_s01(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s01
    % Purpose:        Instanciate the CONTINUUM class dynamically if Init_s01
    %                 is called and get the continuum results
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('CONTINUUM_s01');
    self.CONTINUUM_s01 = ZS_Continuum_s01;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s01'];
    if ~isfile(f)
        error("No continuum results file (.s01) was found.")
    end
    f = fopen(f, 'rb');
    s01 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Continuum;

    % Configure if QoI is 'All'
    self.OPTIONS.Continuum.QoI_selection = self.make_QoI_selection(OPTS);
    
    % Get the results
    self.CONTINUUM_s01 = self.CONTINUUM_s01.get_s01(s01,LINK_OBJ,OPTS);
    end

    function self = Init_s02(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s02
    % Purpose:        Instanciate the SHELL class dynamically if Init_s02
    %                 is called and get the shell results
    % Last Update:    12.10.2023
    %-------------------------------------------------------------------------------
    self.addprop('SHELL_s02');
    self.SHELL_s02 = ZS_Shell_s02;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s02'];
    if ~isfile(f)
        error("No shell results file (.s02) was found.")
    end
    f = fopen(f, 'rb');
    s02 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Shell;

    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);

    % Get the results
    self.SHELL_s02 = self.SHELL_s02.get_s02(s02,LINK_OBJ,OPTS);
    end

    function self = Init_s03(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s03
    % Purpose:        Instanciate the TRUSS class dynamically if Init_s03
    %                 is called and get the truss results
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('TRUSS_s03');
    self.TRUSS_s03 = ZS_Truss_s03;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s03'];
    if ~isfile(f)
        error("No truss results file (.s03) was found.")
    end
    f = fopen(f, 'rb');
    s03 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Truss;

    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);

    % Get the results
    self.TRUSS_s03 = self.TRUSS_s03.get_s03(s03,LINK_OBJ,OPTS);
    end

    function self = Init_s04(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s04
    % Purpose:        Instanciate the BEAM class dynamically if Init_s04
    %                 is called and get the beam results
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('BEAM_s04');
    self.BEAM_s04 = ZS_Beam_s04;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s04'];
    if ~isfile(f)
        error("No beam results file (.s04) was found.")
    end
    f = fopen(f, 'rb');
    s04 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Beam;
    
    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);
    
    % Get the results
    self.BEAM_s04 = self.BEAM_s04.get_s04(s04,LINK_OBJ,OPTS);
    end


    function self = Init_s07(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s07
    % Purpose:        Instanciate the CONTACT class dynamically if Init_s07
    %                 is called and get the truss results
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    self.addprop('CONTACT_s07');
    self.CONTACT_s07 = ZS_Contact_s07;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s07'];
    if ~isfile(f)
        error("No contact results file (.s07) was found.")
    end
    f = fopen(f, 'rb');
    s07 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Contact;

    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);
    
    % Get the results
    self.CONTACT_s07 = self.CONTACT_s07.get_s07(s07,LINK_OBJ,OPTS);
    end


    function self = Init_s15(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_s15
    % Purpose:        Instanciate the MEMBRANES class dynamically if Init_s07
    %                 is called and get the membrane results
    % Last Update:    16.10.2023
    %-------------------------------------------------------------------------------
    self.addprop('MEMBRANE_s15');
    self.MEMBRANE_s15 = ZS_Membrane_s15;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.s15'];
    if ~isfile(f)
        error("No contact results file (.s15) was found.")
    end
    f = fopen(f, 'rb');
    s15 = fread(f, 'float');
    fclose(f);

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Membrane;

    % Configure if QoI is 'All'
    OPTS.QoI_selection = self.make_QoI_selection(OPTS);

    % Get the results
    self.MEMBRANE_s15 = self.MEMBRANE_s15.get_s15(s15,LINK_OBJ,OPTS);
    end

    function self = Init_nails_piles(self,LINK_OBJ,TYPE)
    %-------------------------------------------------------------------------------
    % Name:           Init_nails_piles
    % Purpose:        Read the pile or nail results by calling the beam and
    %                 contact classes
    % Last Update:    16.10.2023
    %-------------------------------------------------------------------------------
    TYPE_UPPER = upper(TYPE);
    TYPE_UPPER_S = strcat(TYPE_UPPER,"S");
    self.addprop(TYPE_UPPER);


    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    File_extensions = ["s04","s07"];

    for i = 1:length(File_extensions)
        f = strcat(fullfile(Path,Name),'.',File_extensions(i));
        if ~isfile(f)
            error("No pile results file (.s04 or .s07) was found.")
        end
        f = fopen(f, 'rb');
        DATA.(File_extensions(i)) = fread(f, 'float');
        fclose(f);
    end

    OPTS = LINK_OBJ.RESULTS.OPTIONS.(TYPE);

    % Configure the time history for the beam and contact elements within
    % the pile
    try
        TEMP_BEAM_OPTS.TimeSteps = OPTS.TimeSteps;
        TEMP_CONTACT_OPTS.TimeSteps = OPTS.TimeSteps;
    end

    try
        TEMP_BEAM_OPTS.Drivers = OPTS.Drivers;
        TEMP_CONTACT_OPTS.Drivers = OPTS.Drivers;
    end

    try
        TEMP_BEAM_OPTS.DivergedSteps = OPTS.DivergedSteps;
        TEMP_CONTACT_OPTS.DivergedSteps = OPTS.DivergedSteps;
    end

    try
        TEMP_BEAM_OPTS.QoI = OPTS.QoI;
        TEMP_CONTACT_OPTS.QoI = OPTS.QoI;
    end

    % Configure if QoI is 'All'
    TEMP_BEAM_OPTS.QoI_selection = self.make_QoI_selection(OPTS);
    TEMP_CONTACT_OPTS.QoI_selection = TEMP_BEAM_OPTS.QoI_selection;


    % Configure the associated beam selection
    
    IDs = LINK_OBJ.MODEL_dat.(TYPE_UPPER_S).get_ID(OPTS);
    for i = 1:length(IDs)
        TEMP_BEAM_OPTS.ID = LINK_OBJ.MODEL_dat.(TYPE_UPPER_S).get_beam_ele_ID(IDs(i));
        TEMP_CONTACT_OPTS.ID = LINK_OBJ.MODEL_dat.(TYPE_UPPER_S).get_contact_ele_ID(IDs(i));
        if strcmp(TYPE,"Pile")
            TEMP_LABEL = strcat("P_",num2str(IDs(i)));
        else
            TEMP_LABEL = strcat("N_",num2str(IDs(i)));
        end
        BEAM_CLASS = ZS_Beam_s04;
        CONTACT_CLASS = ZS_Contact_s07;
        % Beam elements
        self.(TYPE_UPPER).(TEMP_LABEL).BEAMS = BEAM_CLASS.get_s04(DATA.s04,LINK_OBJ,TEMP_BEAM_OPTS);
        % Contact elements
        self.(TYPE_UPPER).(TEMP_LABEL).CONTACTS = CONTACT_CLASS.get_s07(DATA.s07,LINK_OBJ,TEMP_CONTACT_OPTS);
    end
    end

    function self = Init_stability(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_safety
    % Purpose:        Get the lajst safety factor according to the user
    %                 input.
    % Last Update:    25.10.2023
    %-------------------------------------------------------------------------------
    self.addprop('STABILITY_his');
    self.STABILITY_his = [];
    OPTS = self.OPTIONS.Stability;
    OPTS.Driver = "STABILITY";
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);
    if isfield(OPTS,"SF")
        if strcmp(OPTS.SF,'All')
            temp = LINK_OBJ.HISTORY_his.SF(BOOLE_HIS);
        elseif strcmp(OPTS.SF,'last')
            temp = LINK_OBJ.HISTORY_his.SF(BOOLE_HIS);
            temp = temp(end);
        else
            error("'SF' field must be 'All' or 'last'")
        end
    else
        temp = LINK_OBJ.HISTORY_his.SF(BOOLE_HIS);
        temp = temp(end);
    end
        
    self.STABILITY_his.SF = temp';

    end

    function self = Init_eigenmodes(self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           Init_eigenmodes
    % Purpose:        Get the list of the eigenmodes
    % Last Update:    07.11.2023
    %-------------------------------------------------------------------------------
    self.addprop('EIGENMODE_eig');
    self.EIGENMODE_eig = ZS_Eigenmodes_eig;

    Name = LINK_OBJ.JOB.NAME;
    Path = LINK_OBJ.JOB.PATH;

    f = [fullfile(Path,Name),'.eig'];
    if ~isfile(f)
        error("No eigenmode result file (.eig) was found.")
    end

    % Extract user options
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Eigenmode;

    OPTS.QoI_selection = self.make_QoI_selection(OPTS);

    self.EIGENMODE_eig = self.EIGENMODE_eig.get_eig(f,LINK_OBJ,OPTS);
    end

    function All_QoI = get_class_QoI(self,RES_GROUP)
    %-------------------------------------------------------------------------------
    % Name:           check_QoI
    % Purpose:        Check if the user QoI input matches with the results
    % Last Update:    10.10.2023
    %-------------------------------------------------------------------------------
    switch RES_GROUP
        case "NODES"
            All_QoI = ["U_X","U_Y","U_Z","ABS",...
                       "R_X","R_Y","R_Z",...
                       "PORE_PRESSURES","TOTAL_HEADS","TEMPERATURE"];
        case "REACTIONS"
            All_QoI = ["R_X","R_Y","R_Z","ABS",...
                       "M_X","M_Y","M_Z",...
                       "FLUID_FLUX","HEAT_FLUX","HUMIDITY_FLUX"];
        case "VOLUMICS"
            All_QoI = ["SIG_XX","SIG_YY","SIG_ZZ","SIG_XY","SIG_XZ","SIG_YZ",...
                       "EPS_XX","EPS_YY","EPS_ZZ","EPS_XY","EPS_XZ","EPS_YZ",...
                       "V_X","V_Y","V_Z",...
                       "G_X","G_Y","G_Z",...
                       "STRESS_LEVEL","SAT_RATIO","UNDR_PRESSURE","BIOT_COEFF","EFF_SATURATION"];
        case "SHELLS"
            All_QoI = ["F_XX","F_YY","F_XY",...
                       "M_XX","M_YY","M_XY",...
                       "Q_X","Q_Y",...
                       "NLAYER","THICKNESS"];
        case "TRUSSES"
            All_QoI = ["SIG_XX","EPS_XX","STRESS_LEVEL","N_X"];
        case "BEAMS"
            All_QoI = ["N_X";"M_X";"M_Y";"M_Z";"Q_Y";"Q_Z"];
        case "CONTACTS"
            All_QoI = ["SIG_XX","SIG_YY","SIG_ZZ","SIG_XY","SIG_XZ","SIG_YZ",...
                       "T_SIG_XX","T_SIG_YY","T_SIG_ZZ","T_SIG_XY","T_SIG_XZ","T_SIG_YZ",...
                       "EPS_XX","EPS_YY","EPS_ZZ","EPS_XY","EPS_XZ","EPS_YZ",...
                       "STRESS_LEVEL"];
        case "MEMBRANES"
            All_QoI = ["SIG_XX","SIG_YY","SIG_ZZ","SIG_XY","SIG_XZ","SIG_YZ",...
                       "F_XX","F_YY","F_XY",...
                       "STRESS_LEVEL"];
        case "EIGENMODES"
            All_QoI = ["ANG_FREQUENCY","FREQUENCY","EFF_MASS","PART_FACTOR","EIG_VEC"];
                       
    end
    end



    function is_QoI_all = make_QoI_selection(self,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           make_QoI_selection
    % Purpose:        Check if the QoI selection is all or not
    % Last Update:    29.09.2023
    %-------------------------------------------------------------------------------
    QoI_exist = isfield(OPTS,'QoI');
    if QoI_exist
        temp = OPTS.QoI;
        if strcmp(temp,'All')
            is_QoI_all = true;
        elseif isstring(temp)
            is_QoI_all = false;
        else
            error("QoI field must either be 'All' or be a string vector ([QoI_1,QoI_2,...,QoI_n])")
        end
    else
        is_QoI_all = true;
    end
    
    end


    end
    
end