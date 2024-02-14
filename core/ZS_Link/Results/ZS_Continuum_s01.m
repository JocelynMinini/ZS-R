classdef ZS_Continuum_s01 < dynamicprops

    methods

    function self = get_s01(self,s01,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s01 [OK]
    % Purpose:        Parse the results from the .s01 file and return it
    % Last Update:    13.10.2023
    %-------------------------------------------------------------------------------

    % Get the total number of GP
    N_GP = LINK_OBJ.MODEL_dat.ELEMENTS.get_total_number_of_GP_group('VOLUMICS');

    % Get the list of GP per element
    GP_LST = LINK_OBJ.MODEL_dat.ELEMENTS.get_GP_group('VOLUMICS');

    % Get the total number of results from RCF
    N_RES = LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.N_RES;
    
    % Shape the 3D matrix of the results
    continuum_res = reshape(s01, N_RES, N_GP, []);

    % Configure History selection
    OPTS = LINK_OBJ.RESULTS.OPTIONS.Continuum;
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);
    N_HIS = length(BOOLE_HIS);

    % If the length of the .his is bigger than the size of the matrix
    % return a global error
    N_Time_Res = size(continuum_res);
    if N_HIS ~= N_Time_Res(3)
        error('Array dimensions between the results and the time steps are inconsistent. Please try to run the ZSoil calculation again.')
    end

    % Get the logical array for the user requested elements
    BOOLE_EL = LINK_OBJ.MODEL_dat.ELEMENTS.get_element_ID_selection('Continuum',OPTS);

    % Get the logical array for the user requested QoI (to be used later below)
    BOOLE_QoI = OPTS.QoI_selection;

    % Now start creating the results structure
    field_names = fieldnames(LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS);
    field_names = {field_names{3:end}}';
    
    count = 1;
    
    for i = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.N
    
        if strcmp(field_names{i},"NINT")

            count = count + 1;
    
        elseif strcmp(field_names{i},"STRESSES")

            DYN.STRESSES = self.addprop('STRESSES');

            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.STRESSES.N
                temp = continuum_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.STRESSES.(sprintf(strcat('SIG_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.STRESSES.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"STRAINS")

            DYN.STRAINS = self.addprop('STRAINS');
            
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.STRAINS.N
                temp = continuum_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.STRAINS.(sprintf(strcat('EPS_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.STRAINS.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"PLA_CODE")

            count = count + 1;
    
        elseif strcmp(field_names{i},"STR_LEVEL")

            DYN.STRESS_LEVEL = self.addprop('STRESS_LEVEL');

            temp = continuum_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.STRESS_LEVEL = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"SATUR")

            DYN.SAT_RATIO = self.addprop('SAT_RATIO');
    
            temp = continuum_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.SAT_RATIO = temp;
            count = count + 1;

         elseif strcmp(field_names{i},"FLU_VELOC")

            DYN.FLUID_VELOCITIES = self.addprop('FLUID_VELOCITIES');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.FLU_VELOC.N
                temp = continuum_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.FLUID_VELOCITIES.(sprintf(strcat('V_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.FLU_VELOC.Axes(j)))) = temp;
                count = count + 1;
            end

         elseif strcmp(field_names{i},"UNDR_PRESS")

            DYN.UNDR_PRESSURE = self.addprop('UNDR_PRESSURE');
    
            temp = continuum_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.UNDR_PRESSURE = temp;
            count = count + 1;

         elseif strcmp(field_names{i},"GRAD_H")

            DYN.GRAD_H = self.addprop('GRAD_H');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.GRAD_H.N
                temp = continuum_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.GRAD_H.(sprintf(strcat('G_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.VOLUMICS.GRAD_H.Axes(j)))) = temp;
                count = count + 1;
            end

         elseif strcmp(field_names{i},"BIOT_COEFF")

            DYN.BIOT_COEFF = self.addprop('BIOT_COEFF');
    
            temp = continuum_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.BIOT_COEFF = temp;
            count = count + 1;

         elseif strcmp(field_names{i},"SAT_EFF")

            DYN.EFF_SATURATION = self.addprop('EFF_SATURATION');
    
            temp = continuum_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.EFF_SATURATION = temp;
            count = count + 1;
    
        end
    end

    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("VOLUMICS");
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
    
    new = {"STRESS_LEVEL";"SATURATION_RATIO";"UNDR_PRESSURE";"BIOT_COEFFICIENT";"EFFECTIVE_SATURATION"};
    old = {"SL";"SR";"UP";"BIOT";"ES"};
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