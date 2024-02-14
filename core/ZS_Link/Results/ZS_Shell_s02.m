classdef ZS_Shell_s02 < dynamicprops

    methods

    function self = get_s02(self,s03,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s02 [OK]
    % Purpose:        Parse the results from the .s02 file and return it
    % Last Update:    13.10.2023
    %-------------------------------------------------------------------------------

    % Get the total number of GP
    N_GP = LINK_OBJ.MODEL_dat.ELEMENTS.get_total_number_of_GP_group('SHELLS');

    % Get the list of GP per element
    GP_LST = LINK_OBJ.MODEL_dat.ELEMENTS.get_GP_group('SHELLS');

    % Get the total number of results from RCF
    N_RES = LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.N_RES;
    
    % Shape the 3D matrix of the results
    shell_res = reshape(s03, N_RES, N_GP, []);

    % Configure History selection
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);
    N_HIS = length(BOOLE_HIS);

    % If the length of the .his is bigger than the size of the matrix
    % return a global error
    N_Time_Res = size(shell_res);
    if N_HIS ~= N_Time_Res(3)
        error('Array dimensions between the results and the time steps are inconsistent. Please try to run the ZSoil calculation again.')
    end

    % Get the logical array for the user requested elements
    BOOLE_EL = LINK_OBJ.MODEL_dat.ELEMENTS.get_element_ID_selection('Shell',OPTS);

    % Get the logical array for the user requested QoI (to be used later below)
    BOOLE_QoI = OPTS.QoI_selection;

    % Now start creating the results structure
    field_names = fieldnames(LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS);
    field_names = {field_names{3:end}}';
    
    count = 1;
    
    for i = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.N
    
        if strcmp(field_names{i},"NINT")

            count = count + 1;
    
        elseif strcmp(field_names{i},"NLAYER")

            DYN.NLAYER = self.addprop('NLAYER');

            temp = shell_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.NLAYER = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"THICK")

            DYN.THICKNESS = self.addprop('THICKNESS');
            
            temp = shell_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
            temp = temp(BOOLE_EL,BOOLE_HIS);
            self.THICKNESS = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"SMFORCE")

            DYN.MEMBRANE_FORCES = self.addprop('MEMBRANE_FORCES');

            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SMFORCE.N
                temp = shell_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.MEMBRANE_FORCES.(sprintf(strcat('F_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SMFORCE.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"SMOMENT")

            DYN.MOMENTS = self.addprop('MOMENTS');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SMOMENT.N
                temp = shell_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.MOMENTS.(sprintf(strcat('M_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SMOMENT.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"SQFORCE")

            DYN.SHEAR_FORCES = self.addprop('SHEAR_FORCES');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SQFORCE.N
                temp = shell_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.SHEAR_FORCES.(sprintf(strcat('Q_',LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.SHELLS.SQFORCE.Axes(j)))) = temp;
                count = count + 1;
            end
    
        end
    end

    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("SHELLS");
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