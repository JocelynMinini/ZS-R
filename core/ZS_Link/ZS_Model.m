classdef ZS_Model

    properties(SetAccess = ?ZS_Link)
    ANALYSIS
    end

    properties(SetAccess = protected)
    DRIVERS = ZS_Drivers.empty()
    end

    properties(SetAccess = ?ZS_Link)
    ELEMENTS
    end

    properties(SetAccess = public)
    EVOLUTION_FUNCTIONS = ZS_EvolutionFunction.empty()
    EXISTENCE_FUNCTIONS = ZS_ExistenceFunction.empty()
    LOAD_TIME_FUNCTIONS = ZS_LoadFunction.empty()
    end

    properties(SetAccess = ?ZS_Link)
    LOAD_RECORDS = ZS_Loads.empty()
    end

    properties(SetAccess = ?ZS_Link)
    MATERIALS
    end

    properties(SetAccess = ?ZS_Link)
    NAILS = ZS_Nail.empty()
    NODES = ZS_Node.empty()
    PILES = ZS_Pile.empty()
    PROBLEM_TYPE
    UNITS
    VERSION
    end

    methods

        function self = Init_version(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_version
        % Purpose:        Read the version in .dat file
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"DATFILE_VERSION");
        end
        version = textscan(line,'%s %s');
        self.VERSION = version{2}{1};
        fclose(f);
        end

        function self = Init_problem(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_problem
        % Purpose:        Read the problem type in .dat file
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"JOB_TYPE");
        end
        self.PROBLEM_TYPE = self.get_problem(f);
        fclose(f);
        end

        function self = Init_elements(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_elements
        % Purpose:        Call the ZS_Elements class and read the elements in .dat file
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"ELEM");
        end

        n_el = textscan(line,'%s %f');
        n_el = n_el{2};
        elements = ZS_Elements;

        for i = 1:n_el

            temp = elements.Init_Element(f);
            if ~isempty(temp)
                label = temp.LABEL;
                group = elements.get_el_group(label);

                try
                    elements.(group).(label)(end+1,:) = temp;
                catch % Just for the first elements
                    elements.(group).(label) = temp;
                end

            end
            
        end
       
        self.ELEMENTS = elements;

        fclose(f);
        end

        function self = Init_nodes(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_nodes
        % Purpose:        Call the ZS_Node class and read the nodes in .dat file
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"NODE");
        end

        n_nodes = textscan(line,'%s %f');
        n_nodes = n_nodes{2};

        if strcmp(self.get_problem(f),'3D')
            DOF = 3;
        else
            DOF = 2;
        end

        self.NODES = repmat(ZS_Node(f,DOF),n_nodes,1);
        for i = 2:n_nodes
            self.NODES(i,:) = ZS_Node(f,DOF);
        end
        fclose(f);
        end

        function self = Init_nails(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_nails
        % Purpose:        Call the ZS_Nails class and read the nails in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"NAILS");
        end

        data = textscan(line,'%s %u');
        n_Nails = data{2};
        
        for i = 1:n_Nails
            Nails = ZS_Nail;
            Nails = Nails.read(f);
            self.NAILS(end+1,:) = Nails;
        end
        
        fclose(f);
        end

        function self = Init_piles(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_piles
        % Purpose:        Call the ZS_Pile class and read the piles in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"PILES");
        end

        data = textscan(line,'%s %f');
        n_Piles = data{2};
        
        for i = 1:n_Piles
            Piles = ZS_Pile;
            Piles = Piles.read(f);
            self.PILES(end+1,:) = Piles;
        end
        
        fclose(f);
        end

        function self = Init_LF(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_LF
        % Purpose:        Call the ZS_LoadFunction class and read the LF in .dat file
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"LOADTIME");
        end

        data = textscan(line,'%s %u');
        n_LF = data{2};

        for i = 1:n_LF
            LF = ZS_LoadFunction;
            LF = LF.read(f);
            self.LOAD_TIME_FUNCTIONS(end+1,:) = LF;            
        end
        
        fclose(f);
        end

        function self = Init_drivers(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_drivers
        % Purpose:        Call the ZS_Driver class and read the drivers in .dat file
        %                 read the anylsis ID as well
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"ANAL");
        end

        data = textscan(line,'%s %u %s');

        % Analysis type
        self.ANALYSIS = data{3}{1};

        % Drivers
        n_drivers = data{2};
        
        for i = 1:n_drivers
            Driver = ZS_Drivers;
            Driver = Driver.read(f);
            self.DRIVERS(end+1,:) = Driver;
        end

        fclose(f);
        end

        function self = Init_EXF(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_EXF
        % Purpose:        Call the ZS_ExistenceFunction class and read the EF in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"EXISTFUN");
        end

        data = textscan(line,'%s %f');
        n_EF = data{2};
        
        for i = 1:n_EF
            EF = ZS_ExistenceFunction;
            EF = EF.read(f);
            self.EXISTENCE_FUNCTIONS(end+1,:) = EF;
        end
        
        fclose(f);
        end

        function self = Init_EVF(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_EVF
        % Purpose:        Call the ZS_EvolutionFunction class and read the EF in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"EVOLUTION_FUN");
        end

        data = textscan(line,'%s %u');
        n_EVF = data{2};
        
        for i = 1:n_EVF
            EVF = ZS_EvolutionFunction;
            EVF = EVF.read(f);
            self.EVOLUTION_FUNCTIONS(end+1,:) = EVF;
        end
        
        fclose(f);
        end

        function self = Init_loads(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_loads
        % Purpose:        Read the loads in .dat file
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"LOAD ");
        end

        data = textscan(line,'%s %u');
        n_L = data{2};
        
        L = ZS_Loads;
        L = L.read(f,n_L);

        self.LOAD_RECORDS = L;
        
        fclose(f);
        end

        function self = Init_units(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_units
        % Purpose:        Read the units in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"UNITS");
        end

        line = fgetl(f);
        temp = textscan(line,'%s');
        self.UNITS.COMPUTATION = string(temp{1}');
        line = fgetl(f);
        temp = textscan(line,'%s');
        self.UNITS.POSTPRO = string(temp{1}');
        
        fclose(f);
        end

        function self = Init_materials(self,file)
        %-------------------------------------------------------------------------------
        % Name:           Init_materials
        % Purpose:        Read the materials in .dat file
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        f = fopen(file);
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"PROP");
        end

        data = textscan(line,'%s %f');

        N_mat = data{2};

        done = false;
        while ~done
            line = fgetl(f);
            try
                data = textscan(line,'%10f%10s%10f%10f%10f%10f%10f%10f%10f%256s','Delimiter','');
            catch ME
                break % if the above format is no more supported -> End of the materials section
            end


            model = char(data{2});
            model = strtrim(model);
            model_eval = ['ZS_',model,'(f)'];

            % Mat user label and user number
            mat_label = char(data{10});
            mat_number = num2str(data{5});

            dat_mat_number = data{1};

            % Extract the class of the material
            class_name = self.get_class_name(model,mat_number);

            % Configure the field name of the material
            try
                actual_names = string(fieldnames(self.MATERIALS.(class_name)));
            catch
                actual_names = [];
            end
            field_name = self.get_field_name(mat_number,mat_label,actual_names);

            try
                temp_mat = eval(model_eval);
                temp_mat.MAT_ID = dat_mat_number;
                temp_mat.MODEL  = model;
                self.MATERIALS.(class_name).(field_name) = temp_mat;
            end
            done = line(1:3) == 'LES';

        end

        self.MATERIALS = self.sort_struct(self.MATERIALS);
        fclose(f);
        end
    end


    methods (Static = true)

    function PROBLEM_TYPE = get_problem(f)
    %-------------------------------------------------------------------------------
    % Name:           get_problem
    % Purpose:        Read the problem type in .dat file
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    filename = fopen(f);
    new_f = fopen(filename);

    done = false;
    while ~done
        line = fgetl(new_f);
        done  = contains(line,"JOB_TYPE");
    end

    job = textscan(line,'%s %s');
    PROBLEM_TYPE = job{2}{1};

    fclose(new_f);
    end

    function ANAL = get_analysis(f)
    %-------------------------------------------------------------------------------
    % Name:           get_analysis
    % Purpose:        Read the anylsis in .dat file
    % Last Update:    27.08.2023
    %-------------------------------------------------------------------------------
    filename = fopen(f);
    new_f = fopen(filename);
    done = false;
    while ~done
        line = fgetl(new_f);
        done  = contains(line,"ANAL");
    end

    data = textscan(line,'%s %s %s');

    ANAL = char(data{3});

    fclose(new_f);
    end

    function read_extra_group(f,extra_group_flag,n_skip)
    %-------------------------------------------------------------------------------
    % Name:           read_extra_group
    % Purpose:        As ltf numbers, super element numbers and evf numbers
    %                 are not currently supported for any classes of 'Materials'
    %                 this function just skips the corresponding lines in
    %                 the .dat file
    % Last Update:    22.11.2023
    %-------------------------------------------------------------------------------
    to_compare = [1,2,4];
    for j = 1:length(to_compare)
        if bitand(extra_group_flag,to_compare(j)) ~= 0
            for i = 1:n_skip
                fgetl(f);
            end
        end
    end
    end



    function mat_class = get_class_name(model_name,mat_number)
    %-------------------------------------------------------------------------------
    % Name:           get_class_name (nested)
    % Purpose:        Return the class for a given 'model_name'. If
    %                 mat_number is 0 -> belongs to layered materials.
    % Last Update:    24.11.2023
    %-------------------------------------------------------------------------------
    try
        mat_number = str2double(mat_number);
    end

    continuum   = ["ELASTIC_V","PLAS_MC_V","HARD_SOIL","DENSMO_V","PLAS_DP_V","PLA_CAP_V",...
                   "CAM_CLAY","AGINGCO_V","PLAS_ME_V","MLT_MEN_V","MULTI_LAM","PLAS_HB_V",...
                   "CDPM_1_V","ORT10ELAS","ELASLIN"];

    beam        = ["ELASTIC_B","LAYERED_B"];

    beam_layer  = ["EPL_FIB_B","CONCRA_1D"];

    membranes   = ["ISOTROP_M","ANISOTR_M"];

    shell       = ["ELASTIC_S","ORTHO_E_S","LAYERED_S","EPL_FIB_S","PLAS_ME_S"];

    shell_layer = ["ELASTIC_S","ORTHO_E_S","PLAS_ME_S","AGINGCO_S","CDPM_1_V","EPL_FIB_S",...
                   "ISOTROP_M"];

    truss       = ["EPL_TRUSS"];

    seepage     = ["SEEPAGE_S"];

    contacts    = ["CONTACT_S"];


    if ismember(model_name,continuum) & mat_number ~= 0
        mat_class = 'CONTINUUM';
    elseif ismember(model_name,truss)
        mat_class = 'TRUSS';
    elseif ismember(model_name,beam)
        mat_class = 'BEAM';
    elseif ismember(model_name,beam_layer) & mat_number == 0
        mat_class = 'BEAM_LAYER';
    elseif ismember(model_name,shell) & mat_number ~= 0
        mat_class = 'SHELL';
    elseif ismember(model_name,shell_layer) & mat_number == 0
        mat_class = 'SHELL_LAYER';
    elseif ismember(model_name,contacts)
        mat_class = 'CONTACT';
    elseif ismember(model_name,membranes)
        mat_class = 'MEMBRANE';
    elseif ismember(model_name,seepage)
        mat_class = 'SEEPAGE';
    else
        mat_class = 'UNSORTED';
    end
    
    end

    function [sorted_struct,level_done] = sort_struct(obj)
    %-------------------------------------------------------------------------------
    % Name:           sort_struct (TO DO : Generalize this function to multilevel obj)
    % Purpose:        Sort the fields of a structure with natural order
    % Last Update:    24.11.2023
    %-------------------------------------------------------------------------------
    field_name = fieldnames(obj);
    sorted_field_name = ZS_natsort(field_name);

    sorted_struct = orderfields(obj,sorted_field_name);

    for i = 1:length(field_name)
        sub_field_name = fieldnames(sorted_struct.(field_name{i}));
        sorted_sub_field_name = ZS_natsort(sub_field_name);
        sorted_struct.(field_name{i}) = orderfields(sorted_struct.(field_name{i}),sorted_sub_field_name);
    end
    end

    function field_name = get_field_name(mat_num,mat_label,actual_names)
    %-------------------------------------------------------------------------------
    % Name:           get_field_name
    % Purpose:        Returns a valid field name according to the number of
    %                 the user material number and the user material label
    % Last Update:    24.11.2023
    %-------------------------------------------------------------------------------

    if isempty(actual_names)
        add_mat_num = 0;
    else
        add_mat_num = [];
        for i = 1:length(actual_names)
            temp = strsplit(actual_names(i,end),'_');
            temp = temp{end};
            temp = str2double(temp);
            add_mat_num = [add_mat_num,temp];
        end
    end

    if ~strcmp(mat_num,'0')
        field_name = [mat_label,'_',mat_num];
    else
        if strcmp(mat_label,'')
            field_name = ['No_name_',num2str(max(add_mat_num)+1)];
        else
            field_name = [mat_label,'_',num2str(max(add_mat_num)+1)];
        end
    end



    field_name = regexprep(field_name,{' ','-','@','^'},'_');
    end

    function dat_class_name = get_dat_class_name(zs_link_class)
    %-------------------------------------------------------------------------------
    % Name:           get_dat_class_name
    % Purpose:        Returns the name of the .dat class object according
    %                 to the name of the link obj class name
    % Last Update:    24.11.2023
    %-------------------------------------------------------------------------------
    
    if strcmp(zs_link_class,'ANALYSIS')

        dat_class_name = 'ANAL';

    elseif strcmp(zs_link_class,'DRIVERS')

        dat_class_name = 'ANAL';

    elseif strcmp(zs_link_class,'ELEMENTS')

        dat_class_name = 'ELEM';

    elseif strcmp(zs_link_class,'EVOLUTION_FUNCTIONS')

        dat_class_name = 'EVOLUTION_FUN';

    elseif strcmp(zs_link_class,'EXISTENCE_FUNCTIONS')

        dat_class_name = 'EXISTFUN';

    elseif strcmp(zs_link_class,'LOAD_TIME_FUNCTIONS')

        dat_class_name = 'LOADTIME';

    elseif strcmp(zs_link_class,'LOAD_RECORDS')

        dat_class_name = 'LOADS';

    elseif strcmp(zs_link_class,'MATERIALS')

        dat_class_name = 'PROP';

    elseif strcmp(zs_link_class,'NAILS')

        dat_class_name = 'NAILS';

    elseif strcmp(zs_link_class,'NODES')

        dat_class_name = 'NODES';

    elseif strcmp(zs_link_class,'PILES')

        dat_class_name = 'PILES';

    elseif strcmp(zs_link_class,'PROBLEM_TYPE')

        dat_class_name = 'JOB_TYPE';

    elseif strcmp(zs_link_class,'UNITS')

        dat_class_name = 'UNITS';

    elseif strcmp(zs_link_class,'VERSION')


    end 
    end

    end
    
end