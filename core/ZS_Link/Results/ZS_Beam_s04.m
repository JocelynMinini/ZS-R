classdef ZS_Beam_s04 < dynamicprops

    methods

    function self = get_s04(self,s04,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s04 [OK]
    % Purpose:        Parse the results from the .s04 file and return them
    %                 as a structure
    % Last Update:    29.09.2023
    %-------------------------------------------------------------------------------
    
    % Get the total number of GP
    N_GP = LINK_OBJ.MODEL_dat.ELEMENTS.get_total_number_of_GP_group('BEAMS');

    % Get the list of GP per element
    GP_LST = LINK_OBJ.MODEL_dat.ELEMENTS.get_GP_group('BEAMS');

    % In the specific case of the beams, BEL2 elements must be identified
    BOOLE_BEL2 = LINK_OBJ.MODEL_dat.ELEMENTS.get_LABEL_GP_group("BEAMS") == "BEL2";

    % Get the total number of results from RCF
    N_RES = LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.N_RES;
    
    % Shape the 3D matrix of the results
    beam_res = reshape(s04, N_RES, N_GP, []);

    % Configure History selection
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);
    N_HIS = length(BOOLE_HIS);

    % If the length of the .his is bigger than the size of the matrix
    % return a global error
    N_Time_Res = size(beam_res);

    if length(N_Time_Res) == 3

        if N_HIS ~= N_Time_Res(3) & length(N_Time_Res) ~= 3
            error('Array dimensions between the results and the time steps are inconsistent. Please try to run the ZSoil calculation again.')
        end

    end


    % Get the logical array for the user requested elements
    BOOLE_EL = LINK_OBJ.MODEL_dat.ELEMENTS.get_element_ID_selection('Beam',OPTS);

    % Get the logical array for the user requested QoI (to be used later below)
    BOOLE_QoI = OPTS.QoI_selection;

    % Now start creating the results structure
    field_names = fieldnames(LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS);
    field_names = {field_names{3:end}}';
    
    count = 1;
    
    for i = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.N
    
        if strcmp(field_names{i},"NINT")

            count = count + 1;

        elseif strcmp(field_names{i},"NLAYER")

            count = count + 1;

        elseif strcmp(field_names{i},"FORCE")
            
            DYN.FORCES = self.addprop('FORCES');

            FORCES = {};
            forces_names = {"N_","Q_","Q_"}; %{normal force, shear y, shear z}
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.FORCE.N
                temp = beam_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                FORCES.(sprintf(LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.FORCE.Axes(j))) = temp;
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                self.FORCES.(sprintf(strcat(forces_names{j},LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.FORCE.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"MOMENT")

            DYN.MOMENTS = self.addprop('MOMENTS');
            
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.MOMENT.N
                temp = beam_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                % Current axis treated
                current_axe = LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.MOMENT.Axes(j);

                if current_axe == "X"

                    temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                    temp = temp(BOOLE_EL,BOOLE_HIS);

                else

                    try
                        % Extract beam length
                        BEL2 = LINK_OBJ.MODEL_dat.ELEMENTS.BEAMS.BEL2;
                        beam_length = zeros(length(BEL2),length(BOOLE_HIS));
                        for k = 1:length(BEL2)
                            beam_length(k,:) = LINK_OBJ.MODEL_dat.ELEMENTS.BEAMS.BEL2.get_beam_length(BEL2(k,:),LINK_OBJ.MODEL_dat.NODES);
                        end
    
                        % Select the corresponding shear force
                        if current_axe == "Y"
                            shear = FORCES.Z(BOOLE_BEL2,:);
                        elseif current_axe == "Z"
                            shear = FORCES.Y(BOOLE_BEL2,:);
                        end
    
                        % Adjust the moment value by M = M0 + Q*L/2
                        try 
                            moments_adjusted = temp(BOOLE_BEL2,:);
                            moments_adjusted = moments_adjusted + (shear.*beam_length)/2;
                            temp(BOOLE_BEL2,:) = moments_adjusted;
                        end
                    end

                    temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                    temp = temp(BOOLE_EL,BOOLE_HIS);
                    
                end

                self.MOMENTS.(sprintf(strcat("M_",LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.MOMENT.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"EDISP_TRA")

            %DYN.LOCAL_DEFORMATIONS = self.addprop('LOCAL_DEFORMATIONS');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.EDISP_TRA.N
                temp = beam_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                %self.LOCAL_DEFORMATIONS.(sprintf(strcat("U",LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.EDISP_TRA.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"EDISP_ROT")

            %DYN.LOCAL_ROTATIONS = self.addprop('LOCAL_ROTATIONS');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.EDISP_ROT.N
                temp = beam_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = mat2cell(temp,GP_LST,ones(1,N_HIS));
                temp = temp(BOOLE_EL,BOOLE_HIS);
                %self.LOCAL_ROTATIONS.(sprintf(strcat("R",LINK_OBJ.RESULTS_CONFIG_rcf.ELEMENTS.BEAMS.EDISP_ROT.Axes(j)))) = temp;
                count = count + 1;
            end
        end
    end


    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("BEAMS");
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