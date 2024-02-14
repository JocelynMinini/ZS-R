classdef ZS_Eigenmodes_eig < dynamicprops

    methods

    function self = get_eig(self,eig,LINK_OBJ,OPTS)
    %-------------------------------------------------------------------------------
    % Name:           get_s03 [OK]
    % Purpose:        Parse the results from the .s03 file and return it
    % Last Update:    13.10.2023
    %-------------------------------------------------------------------------------
    % Get the total number modes
    eigen_driver_index = LINK_OBJ.MODEL_dat.DRIVERS.get_driver_index("EIGENMODES");
    n_modes = LINK_OBJ.MODEL_dat.DRIVERS(eigen_driver_index).STANDARD_PARAMETERS(1);

    % Get the directions
    TRA = LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.N;

    % Get the mode ids according to user OPTS
    modes_index = LINK_OBJ.MODEL_dat.DRIVERS.get_modes_index(OPTS);

    % QoI selection
    BOOLE_QoI = OPTS.QoI_selection;

    % Read the first part of the .eig file
    DYN.ANG_FREQUENCY = self.addprop("ANG_FREQUENCY");
    DYN.FREQUENCY = self.addprop("FREQUENCY");
    DYN.EFF_MASS = self.addprop("EFF_MASS");
    DYN.PART_FACTOR = self.addprop("PART_FACTOR");

    start_row = 1;
    end_row = 3 + 2*TRA;
    start_column = 2;
    end_column = 1 + n_modes;

    dat = readmatrix(eig, 'FileType', 'text', 'Range', [start_row, start_column, end_row, end_column]);
    self.ANG_FREQUENCY = dat(2,modes_index);
    self.FREQUENCY = dat(3,modes_index);
    count = 4;
    for i = 1:TRA
        self.EFF_MASS.(LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.Axes(i)) = dat(count,modes_index);
        count = count + 1;
    end

    for i = 1:TRA
        self.PART_FACTOR.(LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.Axes(i)) = dat(count,modes_index);
        count = count + 1;
    end


    % Read the second part of the .eig file
    DYN.EIG_VEC = self.addprop("EIG_VEC");

    dat = readmatrix(eig, 'FileType', 'text');

    node_index = LINK_OBJ.MODEL_dat.NODES.get_node_ID_selection(OPTS);
    
    for i = 1:TRA
        index = [3+i : TRA : size(dat,2)-1];
        index = index(modes_index);
        self.EIG_VEC.([LINK_OBJ.RESULTS_CONFIG_rcf.NODES.DISP_TRA.Axes(i)]) = dat(node_index,index);
    end

    % Remove the results according to user QoI
    if ~BOOLE_QoI
    QoI = OPTS.QoI;
    All_QoI = LINK_OBJ.RESULTS.get_class_QoI("EIGENMODES");
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