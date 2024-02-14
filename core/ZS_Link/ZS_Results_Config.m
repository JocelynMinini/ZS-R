classdef ZS_Results_Config    

    properties
    ELEMENTS          % Elements
    NODES             % Nodes
    NODES_VEL         % Nodal velocities
    NODES_ACC         % Nodal acceleration
    NODES_MODES       % Nodal modes
    end

    methods
        function self = Instanciate(self,file)
        lines = readlines(file);

        % Elements group
        n_ele_groups = lines(1);
        n_ele_groups = strtrim(n_ele_groups);
        n_ele_groups = str2double(n_ele_groups);
        self.ELEMENTS.N = n_ele_groups;
        
        count = 2;
        
        for i = 1:n_ele_groups
        
            temp = lines(count);
            temp = strtrim(temp);
            temp = strsplit(temp);
        
            group_id = temp(1);
            group_id = ZS_check_name_for_struct(group_id);
        
            n_sub = temp(2);
            n_sub = str2double(n_sub);
        
            self.ELEMENTS.(sprintf(group_id)).N = n_sub;
        
            n_res = 0;
        
            for j = 1:n_sub
        
                count = count + 1;
                
                temp = lines(count);
                temp = strtrim(temp);
                temp = strsplit(temp);
        
                sub_id = temp(1);
                sub_id = ZS_check_name_for_struct(sub_id);
                
                sub_value = temp(2);
                sub_value = str2double(sub_value);
        
                n_res = n_res + sub_value;

                self.ELEMENTS.(sprintf(group_id)).N_RES = n_res;
                self.ELEMENTS.(sprintf(group_id)).(sprintf(sub_id)).N = sub_value;
        
                if length(temp) > 2
                    sub_axes = temp(3:end);
                    self.ELEMENTS.(sprintf(group_id)).(sprintf(sub_id)).Axes = sub_axes;
                end
        
            end
        
            count = count + 1;
           
        end
        
        % Nodal group
        n_node_group = lines(count);
        n_node_group = strtrim(n_node_group);
        n_node_group = str2double(n_node_group);
        
        self.NODES.N = n_node_group;
        
        n_res = 0;
        
        for i = 1:n_node_group
        
            count = count + 1;
            
            temp = lines(count);
            temp = strtrim(temp);
            temp = strsplit(temp);
        
            sub_id = temp(1);
            sub_id = ZS_check_name_for_struct(sub_id);
        
            sub_value = temp(2);
            sub_value = str2double(sub_value);
        
            n_res = n_res + sub_value;
        
            self.NODES.N_RES = n_res;
            self.NODES.(sprintf(sub_id)).N = sub_value;
            
        
            if length(temp) > 2
                sub_axes = temp(3:end);
                self.NODES.(sprintf(sub_id)).Axes = sub_axes;
            end
            
        end
        
        % Nodal group (Velocities)
        count = count + 1;
        
        n_node_vel_group = lines(count);
        n_node_vel_group = strtrim(n_node_vel_group);
        n_node_vel_group = str2double(n_node_vel_group);
        
        self.NODES_VEL.N = n_node_vel_group;
        
        n_res = 0;
        
        for i = 1:n_node_vel_group
        
            count = count + 1;
            
            temp = lines(count);
            temp = strtrim(temp);
            temp = strsplit(temp);
        
            sub_id = temp(1);
            sub_id = ZS_check_name_for_struct(sub_id);
        
            sub_value = temp(2);
            sub_value = str2double(sub_value);
        
            n_res = n_res + sub_value;
        
            self.NODES_VEL.N_RES = n_res;
            self.NODES_VEL.(sprintf(sub_id)).N = sub_value;
        
            if length(temp) > 2
                sub_axes = temp(3:end);
                self.NODES_VEL.(sprintf(sub_id)).Axes = sub_axes;
            end
            
        end
        
        % Nodal group (Acceleration)
        count = count + 1;
        
        n_node_acc_group = lines(count);
        n_node_acc_group = strtrim(n_node_acc_group);
        n_node_acc_group = str2double(n_node_acc_group);
        
        self.NODES_ACC.N = n_node_acc_group;
        
        n_res = 0;
        
        for i = 1:n_node_acc_group
        
            count = count + 1;
            
            temp = lines(count);
            temp = strtrim(temp);
            temp = strsplit(temp);
        
            sub_id = temp(1);
            sub_id = ZS_check_name_for_struct(sub_id);
        
            sub_value = temp(2);
            sub_value = str2double(sub_value);
        
            n_res = n_res + sub_value;
        
            self.NODES_ACC.N_RES = n_res;
            self.NODES_ACC.(sprintf(sub_id)).N = sub_value;
        
            if length(temp) > 2
                sub_axes = temp(3:end);
                self.NODES_ACC.(sprintf(sub_id)).Axes = sub_axes;
            end
            
        end
        
        % Nodal group (Modes)
        count = count + 1;
        
        n_node_mod_group = lines(count);
        n_node_mod_group = strtrim(n_node_mod_group);
        n_node_mod_group = str2double(n_node_mod_group);
        
        self.NODES_MODES.N = n_node_mod_group;
        
        n_res = 0;
        
        for i = 1:n_node_mod_group
        
            count = count + 1;
            
            temp = lines(count);
            temp = strtrim(temp);
            temp = strsplit(temp);
        
            sub_id = temp(1);
            sub_id = ZS_check_name_for_struct(sub_id);
            
            sub_value = temp(2);
            sub_value = str2double(sub_value);
        
            n_res = n_res + sub_value;
        
            self.NODES_MODES.N_RES = n_res;
            self.NODES_MODES.(sprintf(sub_id)).N = sub_value;
        
            if length(temp) > 2
                sub_axes = temp(3:end);
                self.NODES_MODES.(sprintf(sub_id)).Axes = sub_axes;
            end
    
        end  

        end

    end
    
end