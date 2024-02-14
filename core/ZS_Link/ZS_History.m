classdef ZS_History    

    properties
    DRIVER_TYPE         {mustBeInteger} % Driver number
    N_ITERATIONS        {mustBeInteger} % Number of interations
    CONV_STATUS         {mustBeInteger} % Convergence status (-1/0)
    SF                  double          % Safety factor 
    PLOT_FLAG           {mustBeInteger} % Plot flag (0/1)
    TIME                double          % Time
    STEP_COUNT          {mustBeInteger} % Step counter
    PUSH_FLAG                           % Push over flag
    NR_EIGEN_MODES                      % No Eigen modes
    PUSH_LAMBDA                         % Push over lambda
    PUSH_CTRL_DISPL                     % Push over displacement ctrl
    PUSH_LABEL                          % Push over label
    ARC_LENGTH_FLAG                     % Arc length flag
    ARC_LENGTH_U                        % U norm
    ARC_LENGTH_LAMBDA                   % Load factor
    ARC_LENGTH_NL_SOLVER                % Non linear solver
    MAX_ABS_ITER        {mustBeInteger} % Absolute max iteration
    AMPLF_CONV                          % Amplification factor
    CONV_RHS_NORMS                      
    CONV_ENE_NORMS
    end

    methods
        function self = Instanciate(self,file)

        Names = ["DRIVER_TYPE";"N_ITERATIONS";"CONV_STATUS";"SF";"PLOT_FLAG";"TIME";"STEP_COUNT";"PUSH_FLAG";...
         "NR_EIGEN_MODES";"PUSH_LAMBDA";"PUSH_CTRL_DISPL";"PUSH_LABEL";"ARC_LENGTH_FLAG";...
         "ARC_LENGTH_U";"ARC_LENGTH_LAMBDA";"ARC_LENGTH_NL_SOLVER";"MAX_ABS_ITER";"AMPLF_CONV";...
         "CONV_RHS_NORMS";"CONV_ENE_NORMS"];

        lines = readlines(file);
        count = 1;
        for i = 2:length(lines)
            temp = lines(i);
            temp = strtrim(temp);
            temp = strsplit(temp);
            his_mat(count,:) = temp;
            count = count + 1;
        end
        his_size = size(his_mat);
        
        % Remove the last empty line
        if strcmp(his_mat(end,:),"")
            his_mat(end,:) = [];
        end

        % Remove the last time step if t(end)<t(end-1)
        time = his_mat(:,6);
        time = arrayfun(@(x) str2double(x),time);
        try
            if time(end)<time(end-1)
                his_mat(end,:) = [];
            end
        end

        count = 1;
        for i = 1:length(Names)
            if strcmp(Names(i),"CONV_RHS_NORMS")
                temp = his_mat(:,count:count+5);
                temp = str2double(temp);
                self.(sprintf(Names(i))) = temp;
                count = count + 6;
            elseif strcmp(Names(i),"CONV_ENE_NORMS")
                temp = his_mat(:,count:count+3);
                temp = str2double(temp);
                self.(sprintf(Names(i))) = temp;
                count = count + 4;
            elseif strcmp(Names(i),"PUSH_LABEL")
                if his_size(2) == 27 % If Push label is empty
                    self.(sprintf(Names(i))) = "";
                else
                    self.(sprintf(Names(i))) = his_mat(:,count);
                    count = count + 1;
                end
            else
                temp = his_mat(:,count);
                temp = str2double(temp);
                try
                    self.(sprintf(Names(i))) = temp;
                catch
                    self.(sprintf(Names(i))) = fix(temp);
                end
                count = count + 1;
            end
    
        end


        end

        function step_number_index = get_TimeSteps(self,struct)
        %-------------------------------------------------------------------------------
        % Name:           get_TimeSteps
        % Purpose:        Check if user arguments are consistent and return
        %                 - all TimeStep or
        %                 - the selected time steps or
        %                 - abord if an error occurs
        % Last Update:    27.09.2023
        %-------------------------------------------------------------------------------
        
        % First check the arguments
        TS_exist = isfield(struct,'TimeStep');
        
        if TS_exist
            temp = struct.TimeStep;
            if strcmp(temp,'All')
                is_all = true;
            elseif isnumeric(temp)
                is_all = false;
            else
                error("TimeStep field must either be 'All' or be a vector ([T1,T2,...,Tn])")
            end
        else
            is_all = true;
        end
        
        if is_all
            TimeStep = self.TIME;
        else
            TimeStep = temp;
        end
        
        % Time step selection according to step number
        n_steps = length(self.TIME);
        step_number_index = zeros(n_steps,1);
        n_step_selected = length(TimeStep);
        
        for i = 1:n_step_selected
            temp = abs(self.TIME - TimeStep(i)) < 10^-10;
            step_number_index = step_number_index + double(temp);
        end
        
        step_number_index = (logical(step_number_index))';
            
        end

        function Driver_Label = get_drivers_Type(self,Driver_Name)
        %-------------------------------------------------------------------------------
        % Name:           get_drivers_Type
        % Purpose:        This function gives the number of a given driver
        %                 according to his name
        %
        % Author:         Minini Jocelyn
        %
        % Last Update:    17.08.2023
        % Version:        2023.01
        % Licence:        free
        %-------------------------------------------------------------------------------
        if strcmp(Driver_Name,"INITIAL_STATE")
            Driver_Label = 1;
        elseif strcmp(Driver_Name,"STABILITY")
            Driver_Label = 2;
        elseif strcmp(Driver_Name,"TIME_DEPENDENT")
            Driver_Label = 3;
        elseif strcmp(Driver_Name,"ARC_LENGTH")
            Driver_Label = 4;
        elseif strcmp(Driver_Name,"DYNAMICS")
            Driver_Label = 5;
        elseif strcmp(Driver_Name,"PUSHOVER")
            Driver_Label = 6;
        elseif strcmp(Driver_Name,"EIGENMODES")
            Driver_Label = 7;
        else
            error('The selected driver does not exist..')
        end
        end

        function Driver_index = get_Drivers(self,struct)
        %-------------------------------------------------------------------------------
        % Name:           get_Driver
        % Purpose:        Check if user arguments are consistent and return
        %                 - all Driver or
        %                 - the selected Driver or
        %                 - abord if an error occurs
        % Last Update:    27.09.2023
        %-------------------------------------------------------------------------------
        
        % First check the arguments
        TS_exist = isfield(struct,'Driver');
        
        if TS_exist
            temp = struct.Driver;
            if strcmp(temp,'All')
                is_all = true;
            elseif isstring(temp)
                is_all = false;
            else
                error("TimeStep field must either be 'All' or be a string vector ([Driver_1,Driver_2,...,Driver_n])")
            end
        else
            is_all = true;
        end
        
        if is_all
            Driver = self.DRIVER_TYPE;
        else
            Driver = arrayfun(@(x) self.get_drivers_Type(x),temp);
        end
        
        % Time step selection according to step number
        n_drivers = length(self.DRIVER_TYPE);
        drivers_index = zeros(n_drivers,1);
        n_drivers_selected = length(Driver);
        
        for i = 1:n_drivers_selected
            temp = self.DRIVER_TYPE == Driver(i);
            drivers_index = drivers_index + double(temp);
        end
        
        Driver_index = (logical(drivers_index))';
            
        end

        function diverged_step_index = get_DivergedSteps(self,struct)
        %-------------------------------------------------------------------------------
        % Name:           get_DivergedSteps
        % Purpose:        Check if user arguments are consistent and return
        %                 - keep the diverged steps or
        %                 - drop the diverged steps or
        %                 - abord if an error occurs
        % Last Update:    27.09.2023
        %-------------------------------------------------------------------------------
        
        % First check the arguments
        TS_exist = isfield(struct,'DivergedSteps');
        
        if TS_exist
            temp = struct.DivergedSteps;
            if strcmp(temp,'keep')
                is_keep = true;
            elseif strcmp(temp,'delete')
                is_keep = false;
            else
                error("DivergedSteps field must either be 'keep' or be 'delete'")
            end
        else
            is_keep = false;
        end
        
        n_steps = length(self.TIME);

        if is_keep
            diverged_step_index = logical(ones(1,n_steps));
        else
            diverged_step_index = (self.CONV_STATUS == -1)';
        end
            
        end

        function non_plot_index = get_non_plot_step(self)
        %-------------------------------------------------------------------------------
        % Name:           get_non_plot_step
        % Purpose:        Return the steps without any output during ZSoil
        %                 evaluation (PLOT_FLAG = 0)
        % Last Update:    18.12.2023
        %-------------------------------------------------------------------------------
        non_plot_index = (~logical(self.PLOT_FLAG))';
        end

        function BOOLE_HIS = get_his_selection(self,OPTS)
        %-------------------------------------------------------------------------------
        % Name:           get_his_selection
        % Purpose:        Create a logical array by intersecting :
        %                 - drivers indexes
        %                 - diverged steps strategy indexes
        %                 - time steps selection indexes
        %                 and return a logical array as well
        % Last Update:    15.10.2023
        %-------------------------------------------------------------------------------
        time_steps_index = self.get_TimeSteps(OPTS);
        drivers_index = self.get_Drivers(OPTS);
        diverged_step_index = self.get_DivergedSteps(OPTS);
        BOOLE_HIS = and(and(drivers_index,diverged_step_index),time_steps_index);

        % Remove the step where ZSoil did not return any results
        non_plot_index = self.get_non_plot_step;
        BOOLE_HIS(non_plot_index) = [];
        end


    end
    
end