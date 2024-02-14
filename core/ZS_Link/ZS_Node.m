classdef ZS_Node    

    properties
    ID     {mustBeInteger}          % Node number
    XYZ    (1,:) double             % Node coordinates
    L_REC  (1,:) {mustBeInteger}    % Load records
    end

    methods

        function self = ZS_Node(f_dat,DOF)
        %-------------------------------------------------------------------------------
        % Name:           Instanciate (Constructor)
        % Purpose:        Read the nodes data from the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f_dat);

        if DOF == 2
            data = textscan(line,'%10d%20.13f%20.13f  %5s%10d');
            self.ID = data{1};
            self.XYZ = [data{2:3}];
            if ~isempty(data{4})
                line = fgetl(f_dat);
                data = textscan(line,'%10d',16);
                self.L_REC = data{1}';
            end
        else
            data = textscan(line,'%10d%20.13f%20.13f%20.13f  %5s%10d');
            self.ID = data{1};
            self.XYZ = [data{2:4}];
            if ~isempty(data{5})
                line = fgetl(f_dat);
                data = textscan(line,'%10d',16);
                self.L_REC = data{1}';
            end
        end
        end

        function N_Nodes = get_total_number_of_nodes(self)
        %-------------------------------------------------------------------------------
        % Name:           get_total_number_of_nodes
        % Purpose:        Give the total number of nodes in the model.
        % Last Update:    15.10.2023
        %-------------------------------------------------------------------------------
        N_Nodes = length(self);
        end

        function Nodes_lst = get_node_ID(self)
        %-------------------------------------------------------------------------------
        % Name:           get_node_ID
        % Purpose:        Return the IDs of all nodes contained.
        % Last Update:    15.10.2023
        %-------------------------------------------------------------------------------
        Nodes_lst = [self.ID];
        end


        function ID_FLAG = get_node_ID_selection(self,OPTS)
        %-------------------------------------------------------------------------------
        % Name:           get_node_selection
        % Purpose:        Create a logical array for selecting the nodes
        %                 according to the user input
        % Last Update:    15.10.2023
        %-------------------------------------------------------------------------------
        ID_exist = isfield(OPTS,'ID');

        if ID_exist
            ID_is_all = strcmp(OPTS.ID,"All");
        else
            ID_is_all = true;
        end
    
        N_NODES = self.get_total_number_of_nodes;

        NODES_ID = self.get_node_ID;

        if ID_exist & ~ID_is_all
    
            user_ID = OPTS.ID;
    
            if length(user_ID) > N_NODES
                error(strcat("The number of requested nodes exceeds the total number of nodes."))
            end
    
            if ~(length(user_ID) == length(unique(user_ID)))
                error(strcat("There are some duplicates in the requested nodes."))
            end
    
            if ~issorted(user_ID)
                error("Node IDs must be given in ascending order.")
            end
    
            flag = zeros(1,N_NODES);
            for i = 1:length(user_ID)
                temp = user_ID(i) == NODES_ID;
                flag = flag + temp;
            end
            ID_FLAG = logical(flag);
    
        else
            ID_FLAG = logical(ones(1,N_NODES));
        end
        end

   end
    
end