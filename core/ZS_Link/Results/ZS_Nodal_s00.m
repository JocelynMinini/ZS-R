classdef ZS_Nodal_s00 < dynamicprops

    methods

    function self = get_s00(self,s00,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s00
    % Purpose:        Parse the results from the .s00 file and return it
    % Last Update:    29.09.2023
    %-------------------------------------------------------------------------------

    % Get the total number of GP
    N_NODES = LINK_OBJ.MODEL_dat.NODES.get_total_number_of_nodes;

    % Get the total number of results from RCF
    N_RES = LINK_OBJ.RESULTS_CONFIG_rcf.NODES.N_RES;
    
    % Shape the 3D matrix of the results
    node_res = reshape(s00, N_RES, N_NODES, []);

    % Configure History selection
    BOOLE_HIS = LINK_OBJ.HISTORY_his.get_his_selection(OPTS);

    % Get the logical array for the user requested elements
    BOOLE_NODES = LINK_OBJ.MODEL_dat.NODES.get_node_ID_selection(OPTS);

    % Get the logical array for the user requested QoI (to be used later below)
    BOOLE_QoI = OPTS.QoI_selection;

    % Now start creating the results structure
    field_names = fieldnames(LINK_OBJ.RESULTS_CONFIG_rcf.NODES);
    field_names = {field_names{3:end}}';

    count = 1;
    
    for i = 1:LINK_OBJ.RESULTS_CONFIG_rcf.NODES.N
    
        if strcmp(field_names{i},"DISP_TRA")

            DYN.DISPLACEMENTS = self.addprop('DISPLACEMENTS');
        
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.N
                temp = node_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = temp(BOOLE_NODES,BOOLE_HIS);
                self.DISPLACEMENTS.(sprintf(strcat('U_',LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.Axes(j)))) = temp;
                disp_lst(:,:,j) = temp;
                count = count + 1;
            end

            disp_lst = sqrt(sum(disp_lst.^2,3));
            self.DISPLACEMENTS.ABS = disp_lst;

        elseif strcmp(field_names{i},"DISP_ROT")

            DYN.ROTATION = self.addprop('ROTATION');
    
            for j = 1:LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_ROT.N
                temp = node_res(count,:,:);
                temp = permute(temp,[2,3,1]);
                temp = temp(BOOLE_NODES,BOOLE_HIS);
                self.ROTATION.(sprintf(strcat('R_',LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_ROT.Axes(j)))) = temp;
                count = count + 1;
            end
    
        elseif strcmp(field_names{i},"PPRESS")

           DYN.PORE_PRESSURES = self.addprop('PORE_PRESSURES');
    
            temp = node_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = temp(BOOLE_NODES,BOOLE_HIS);
            self.PORE_PRESSURES = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"PRES_HEAD")

            DYN.TOTAL_HEADS = self.addprop('TOTAL_HEADS');
    
            temp = node_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = temp(BOOLE_NODES,BOOLE_HIS);
            self.TOTAL_HEADS = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"TEMP")

            DYN.TEMPERATURE = self.addprop('TEMPERATURE');
    
            temp = node_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = temp(BOOLE_NODES,BOOLE_HIS);
            self.TEMPERATURE = temp;
            count = count + 1;
    
        elseif strcmp(field_names{i},"HUMID")

            DYN.HUMIDITY = self.addprop('HUMIDITY');
    
            temp = node_res(count,:,:);
            temp = permute(temp,[2,3,1]);
            temp = temp(BOOLE_NODES,BOOLE_HIS);
            self.HUMIDITY = temp;
            count = count + 1;
    
        end
    end

    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("NODES");
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

    function node_indexes = make_node_selection (self,LINK_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           make_node_selection
    % Purpose:        According to the user input, this function will
    %                 create a boolean array for selecting the nodes
    % Last Update:    09.10.2023
    %-------------------------------------------------------------------------------

    Nodes_exist = isfield(LINK_OBJ.RESULTS.OPTIONS.Nodal,'ID');

    if Nodes_exist
        temp = LINK_OBJ.RESULTS.OPTIONS.Nodal.ID;
        if ~issorted(temp)
            error("Node IDs must be given in ascending order.")
        end
        if strcmp(temp,'All')
            is_Nodes_all = true;
        elseif isnumeric(temp)
            is_Nodes_all = false;
        else
            error("Nodes field must either be 'All' or be a integer vector ([Node_1,Node_2,...,Node_n])")
        end
    else
        is_Nodes_all = true;
    end

    if is_Nodes_all
        node_indexes = logical(1:length(LINK_OBJ.MODEL_dat.NODES));
    else
        node_indexes = LINK_OBJ.RESULTS.OPTIONS.Nodal.ID;
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