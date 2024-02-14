classdef ZS_Membrane_s15 < dynamicprops

    methods

    function self = get_s15(self,s15,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s02 [OK]
    % Purpose:        Parse the results from the .s02 file and return it
    % Last Update:    13.10.2023
    %-------------------------------------------------------------------------------

    % Get the total number of GP
    N_GP = LINK_OBJ.MODEL_dat.ELEMENTS.get_total_number_of_GP_group('MEMBRANES');

    % Get the list of GP per element
    GP_LST = LINK_OBJ.MODEL_dat.ELEMENTS.get_GP_group('MEMBRANES');

    % Get the total number of results from RCF
    N_RES = LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.N_RES;
    
    % Shape the 3D matrix of the results
    membrane_res = reshape(s15, N_RES, N_GP, []);

    % Configure History selection
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);
    N_HIS = length(BOOLE_HIS);

    % If the length of the .his is bigger than the size of the matrix
    % return a global error
    N_Time_Res = size(membrane_res);
    if N_HIS ~= N_Time_Res(3)
        error('Array dimensions between the results and the time steps are inconsistent. Please try to run the ZSoil calculation again.')
    end

    % Get the logical array for the user requested elements
    BOOLE_EL = LINK_OBJ.MODEL_dat.ELEMENTS.get_element_ID_selection('Membrane',OPTS);

    % Get the logical array for the user requested QoI (to be used later below)
    BOOLE_QoI = OPTS.QoI_selection;

    % Now start creating the results structure
    field_names = fieldnames(LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE);
    field_names = {field_names{3:end}}';
    
    count = 1;
    
    for i = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.N
    
        if strcmp(field_names{i},"NINT")

            count = count + 1;
    
        elseif strcmp(field_names{i},"STRAINS")

            DYN.STRAINS = self.addprop('STRAINS');

            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.STRAINS.N
                temp = membrane_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.STRAINS.(sprintf(strcat('EPS_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.STRAINS.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"PLA_CODE")

            count = count + 1;

        elseif strcmp(field_names{i},"STR_LEVEL")

            DYN.STRESS_LEVEL = self.addprop('STRESS_LEVEL');
    
            temp = membrane_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.STRESS_LEVEL = temp;
            count = count + 1;

        elseif strcmp(field_names{i},"SMFORCE")

            DYN.FORCES = self.addprop('FORCES');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.SMFORCE.N
                temp = membrane_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.FORCES.(sprintf(strcat('F_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.MEMBRANE.SMFORCE.Axes(j)))) = temp;
                count = count + 1;
            end
    
        end
    end

    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("MEMBRANES");
    not_QoI = setdiff(All_QoI,QoI);
    n_not_QoI = length(not_QoI);
    
    for i = 1:n_not_QoI
        self = self.remove_not_QoI(self,not_QoI{i},DYN);
    end
    if length(fieldnames(self)) == 0
        self = self.empty();
    end
    end
    end


    function QoI_names = check_QoI(self,QoI_names)
    %-------------------------------------------------------------------------------
    % Name:           check_QoI
    % Purpose:        Check if the user QoI input matches with the results
    % Last Update:    10.10.2023
    %-------------------------------------------------------------------------------
    
    n_QoI = length(QoI_names);
    QoI_names = QoI_names';

    field_names = fieldnames(self);
    all_field_names = {};
    
    for i = 1:length(field_names)
        if isstruct(self.(sprintf(field_names{i})))
            all_field_names{end+1} = fieldnames(self.(sprintf(field_names{i})));
        else
            all_field_names{end+1} = field_names{i};
        end
    end

    all_field_names = vertcat(all_field_names{:});
    all_field_names = string(all_field_names);
    
    new = {"STRESS_LEVEL"};
    old = {"SL"};
    for i = 1:length(old)
        QoI_names = strrep(QoI_names,old{i},new{i});
    end

    for i = 1:n_QoI
        if ~any(contains(all_field_names,QoI_names{i}))
            error(strcat("The requested QoI : '",QoI_names{i},"' does not exist or could not be parsed."))
        end
    end

    end


    function [self,new_struct,boolean_flag] = remove_not_QoI (self,inStruct,QoI_names,DYN_VAR)
    %-------------------------------------------------------------------------------
    % Name:           remove_not_QoI
    % Purpose:        This function is complicated and unclear but works.
    %                 remove_not_QoI will search across the complete nodal result 
    %                 structure and will remove the field which do not
    %                 contain the user defined QoI
    % Last Update:    29.09.2023
    %-------------------------------------------------------------------------------
    f = fieldnames(inStruct);
    for i=1:length(f)
        if strcmp(f{i},strtrim(QoI_names))
            boolean_flag = 1;
            try
                new_struct = rmfield(inStruct,f{i});
            catch
                delete(DYN_VAR.(f{i}))
                new_struct = self;
            end
            return;
        elseif isstruct(inStruct.(f{i}))
            try
                [self,new_struct,boolean_flag] = self.remove_not_QoI(inStruct.(f{i}), QoI_names);
                if isempty(fieldnames(new_struct))
                    delete(DYN_VAR.(f{i}))
                    new_struct = self;
                end
                inStruct.(f{i}) = new_struct;
                self = inStruct;
                if boolean_flag
                return;
                end
            end
        else
            boolean_flag = 0;
            new_struct = inStruct;
        end
    end
    end
    

    


    end   
end