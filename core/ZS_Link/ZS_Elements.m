classdef ZS_Elements 

    properties
    BEAMS 
    CONTACTS
    HINGES
    MEMBRANES
    SHELLS
    SEEPAGES
    TRUSSES
    VOLUMICS
    end

    methods

        %{
        function self = ZS_Elements
        %-------------------------------------------------------------------------------
        % Name:           ZS_Elements
        % Purpose:        Constructor.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        % Continuum
        self.VOLUMICS.Q4    = ZS_El_Q4.empty();
        self.VOLUMICS.Q4ES  = ZS_El_Q4ES.empty();
        self.VOLUMICS.T3    = ZS_El_T3.empty();
        self.VOLUMICS.P4    = ZS_El_P4.empty();
        self.VOLUMICS.W6    = ZS_El_W6.empty();
        self.VOLUMICS.B8    = ZS_El_B8.empty();
        self.VOLUMICS.B8ES  = ZS_El_B8ES.empty();

        % Shells
        self.SHELLS.SHQ4    = ZS_El_SHQ4.empty();
        self.SHELLS.SXQ4    = ZS_El_SXQ4.empty();

        % Trusses
        self.TRUSSES.TRS2   = ZS_El_TRS2.empty();

        % Beams
        self.BEAMS.BEL2     = ZS_El_BEL2.empty();
        self.BEAMS.SBEL2    = ZS_El_SBEL2.empty();

        % Hinges
        self.HINGES.DSC2  = ZS_El_DSC2.empty();
        self.HINGES.LHIL2 = ZS_El_LHIL2.empty();
        
        % Contacts
        self.CONTACTS.C_L2   = ZS_El_C_L2.empty();
        self.CONTACTS.CB_L2  = ZS_El_CB_L2.empty();
        self.CONTACTS.CNNPL  = ZS_El_CNNPL.empty();
        self.CONTACTS.C_T3   = ZS_El_C_T3.empty();
        self.CONTACTS.C_Q4   = ZS_El_C_Q4.empty();

        % Membranes
        self.MEMBRANES.ML2   = ZS_El_M_L2.empty();
        self.MEMBRANES.MT3   = ZS_El_M_T3.empty();
        self.MEMBRANES.MQ4   = ZS_El_M_Q4.empty();
        
        end
        %}

        function EL = Init_Element(~,f)
        %-------------------------------------------------------------------------------
        % Name:           Init_Element
        % Purpose:        Read the elements from the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        data = {textscan(line(1:10),'%10u'),...
                line(11:15),...
                textscan(line(16:25),'%10u'),...
                line(26:30),...
                textscan(line(31:40),'%10u'),...
                textscan(line(41:end),'%10u',14)
                };
        % Nodes 
        NODES_ID = (data{6}{1})';
        % If list of node is bigger than 13 -> newline
        if numel(NODES_ID) == 13
            line = fgetl(f);
            NODE_ID_sup = textscan(line,'%10d',16);
            NODE_ID_sup = (cell2mat(NODE_ID_sup))';
            NODES_ID = [NODES_ID,NODE_ID_sup];
        end
        
        to_eval = ['ZS_El_',strip(data{2})];

        try
            EL = eval(to_eval);
            EL = EL.Instanciate(NODES_ID);

            % Element id
            EL.ID = data{1}{1};
    
            % Material index
            EL.MAT_INDEX = data{3}{1};
    
            % Load records
            if data{4}=='L_REC'
                line = fgetl(f);
                L_REC = textscan(line,'%10d',16);
                L_REC = cell2mat(L_REC);
                EL.L_REC_INDEX = (L_REC(1:2:end))';
                EL.L_REC_FACES = (L_REC(2:2:end))';
            end

        catch

            EL=[];

        end

        end

        function self = delete(self,group)
        %-------------------------------------------------------------------------------
        % Name:           delete
        % Purpose:        Destructor
        % Last Update:    12.10.2023
        %-------------------------------------------------------------------------------
        delete(self.(group))
        
        
        end

        function ID_FLAG = get_element_ID_selection(self,RES_GROUP,OPTS)
        %-------------------------------------------------------------------------------
        % Name:           get_element_ID_selection
        % Purpose:        According to OPTS this function will generate a
        %                 logical array for selecting the elements
        % Last Update:    12.10.2023
        %-------------------------------------------------------------------------------
    
        switch RES_GROUP
        case "Continuum"
            EL_GROUP = "VOLUMICS";
        case "Shell"
            EL_GROUP = "SHELLS";
        case "Truss"
            EL_GROUP = "TRUSSES";
        case "Beam"
            EL_GROUP = "BEAMS";
        case "Hinge"
            EL_GROUP = "HINGES";
        case "Contact"
            EL_GROUP = "CONTACTS";
        case "Membrane"
            EL_GROUP = "MEMBRANES";
        end
    
        field_names = fieldnames(self.(EL_GROUP));
        EL_ID = [];
        EL_LABEL = [];
        for i = 1:length(field_names) 
            EL_ID = [EL_ID,self.get_property_class(field_names{i},"ID")];
            EL_LABEL = [EL_LABEL,self.get_property_class(field_names{i},"LABEL")];
        end
        [EL_ID,idx] = sort(EL_ID);
        EL_LABEL = EL_LABEL(:,idx);
        
        ID_exist = isfield(OPTS,'ID');
    
        if ID_exist
            ID_is_all = strcmp(OPTS.ID,"All");
        else
            ID_is_all = true;
        end
    
        N_EL_TOT = length(EL_LABEL);
    
        if ID_exist & ~ID_is_all
    
            user_ID = OPTS.ID;
    
            if length(user_ID) > N_EL_TOT
                error(strcat("The number of requested elements exceeds the total number of ",RES_GROUP," elements."))
            end

            if max(user_ID) > max(EL_ID)
                error(strcat("One reqested element ID is out of the element IDs range."))
            end
    
            if ~(length(user_ID) == length(unique(user_ID)))
                error(strcat("There are some duplicates in the requested elements."))
            end
    
            if ~issorted(user_ID)
                error("Element IDs must be given in ascending order.")
            end
    
            flag = zeros(1,N_EL_TOT);
            for i = 1:length(user_ID)
                temp = user_ID(i) == EL_ID;
                flag = flag + temp;
            end
            ID_FLAG = logical(flag);
    
        else
            ID_FLAG = logical(ones(1,N_EL_TOT));
        end
    
        end


        function LABEL_LST = get_LABEL_GP_group(self,EL_GROUP)
        %-------------------------------------------------------------------------------
        % Name:           get_BEL2_ID
        % Purpose:        Get the index of the BEL2 elements (for moments adjustment)
        % Last Update:    12.10.2023
        %-------------------------------------------------------------------------------
        field_names = fieldnames(self.(EL_GROUP));
        
        EL_label = [];
        EL_ID = [];
        for i = 1:length(field_names)
            temp_LABEL = self.get_property_class(field_names{i},"LABEL");
            temp_ID = self.get_property_class(field_names{i},"ID");
            temp_N_GP = self.get_number_of_GP_class(field_names{i});
            for j = 1:temp_N_GP
                EL_label = [EL_label,temp_LABEL];
                EL_ID = [EL_ID,temp_ID];
            end
        end

        [~,idx] = sort(EL_ID);
        LABEL_LST = EL_label(:,idx);
        end

        function GP_LST = get_GP_group(self,EL_group)
        %-------------------------------------------------------------------------------
        % Name:           get_total_number_of_GP_group
        % Purpose:        Give the total number of GP according to an
        %                 element group
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        field_names = fieldnames(self.(EL_group));
        GP_LST = [];
        EL_ID = [];
        for i = 1:length(field_names)
            GP = [self.(EL_group).(field_names{i}).GP];
            EL_ID = [EL_ID,self.get_property_class(field_names{i},"ID")];
            try 
                GP = [GP.N];
            catch
                GP = [];
            end
            GP_LST = [GP_LST,GP];
        end
        [~,idx] = sort(EL_ID);
        GP_LST = GP_LST(:,idx);
        end

        function N_GP = get_total_number_of_GP_group(self,EL_group)
        %-------------------------------------------------------------------------------
        % Name:           get_total_number_of_GP_group
        % Purpose:        Give the total number of GP according to an
        %                 element group
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        N = get_GP_group(self,EL_group);
        N_GP = sum(N);
        end

        function N_GP = get_total_number_of_GP_class(self,EL_class)
        %-------------------------------------------------------------------------------
        % Name:           get_total_number_of_GP_class
        % Purpose:        Give the total number of GP according to an
        %                 element class
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        field_names = fieldnames(self);
        for i = 1:length(field_names)
            el_class_lst = fieldnames(self.(field_names{i}));
            el_class_lst = string(el_class_lst);
            test = any(contains(el_class_lst,EL_class));
            if test
                group = field_names{i};
                break
            end
        end

        N_GP = [self.(group).(EL_class)(:).GP];
        try
            N_GP = [N_GP.N];
            N_GP = sum(N_GP);
        catch
            N_GP = [];
        end
        
        end

        function N_GP = get_number_of_GP_class(self,EL_class)
        %-------------------------------------------------------------------------------
        % Name:           get_number_of_GP_class
        % Purpose:        According to its class the function will return
        %                 the number of GP
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        EL = eval(strcat('ZS_El_',EL_class));
        EL = EL.Instanciate([]);
        N_GP = EL.GP.N;
        end

        function C_ID = get_property_class(self,EL_class,ITEM)
        %-------------------------------------------------------------------------------
        % Name:           get_property_class
        % Purpose:        Give a list of the propriety 'ITEM' in the element class
        %                 EL_class
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        field_names = fieldnames(self);
        for i = 1:length(field_names)
            try
                el_class_lst = fieldnames(self.(field_names{i}));
                el_class_lst = string(el_class_lst);
                test = any(contains(el_class_lst,EL_class));
                if test
                    group = field_names{i};
                    break
                end
            end
        end

        C_ID = [self.(group).(EL_class)(:).(ITEM)];
        end


        function group = get_el_group(self,EL_group)
        %-------------------------------------------------------------------------------
        % Name:           get_el_group
        % Purpose:        Return the element group according to the element
        %                 label
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        
        continuum  = ["Q4","T3","Q8","Q9","T6","T15","B8","B20","W6","W15","P4","P10","Q4ES","B8ES"];
        axis_ring  = "RING1";
        truss      = ["TRS2","TRS3"];
        beam       = ["BEL2","BEL3","SBEL2"];
        membrane   = ["M_L2","M_L3","M_T3","M_T6","M_Q4","M_Q8"];
        contact    = ["C_L2","C_L3","C_T3","C_T6","C_Q4","C_Q8","CB_L2","CNNPL","DSC2","LHIL2","NSC2D","NSC3D"];
        shell      = ["SHQ4","SHQ8","SXQ4","SXQ8"];
        seepage    = ["SPL2","SPL3","SPT3","SPT6","SPQ4","SPQ8"];
        convection = ["CSL2","CSL3","CST3","CST6","CSQ4","CSQ8"];
        infinite   = ["INFQ4","CNFQ4","INFQ9","INFB8","INFW6","CNFB8"];
        various    = ["FB8","PVO","MASS1","MTMM","HEXL2"];
        viscous    = ["VS_L2","VS_T3","VS_Q4"];


        if any(ismember(continuum,EL_group))
            group = 'VOLUMICS';
        elseif any(ismember(axis_ring,EL_group))
            group = 'AXIS_RINGS';
        elseif any(ismember(truss,EL_group))
            group = 'TRUSSES';
        elseif any(ismember(beam,EL_group))
            group = 'BEAMS';
        elseif any(ismember(membrane,EL_group))
            group = 'MEMBRANES';
        elseif any(ismember(contact,EL_group))
            group = 'CONTACTS';
        elseif any(ismember(shell,EL_group))
            group = 'SHELLS';
        elseif any(ismember(seepage,EL_group))
            group = 'SEEPAGES';
        elseif any(ismember(convection,EL_group))
            group = 'CONVECTION';
        elseif any(ismember(infinite,EL_group))
            group = 'INFINITE_EL';
        elseif any(ismember(various,EL_group))
            group = 'VARIOUS';
        elseif any(ismember(viscous,EL_group))
            group = 'VISCOUS';
        else
            group = 'UNKOWN';
        end



        end
   end
    
end