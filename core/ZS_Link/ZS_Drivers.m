classdef ZS_Drivers

    properties
    DRIVER_ID                      % Driver ID
    SUBDRIVER_ID                   % Subdriver ID
    STANDARD_PARAMETERS            % Standard parameters
    ALGORITHMIC_PARAMETERS         % Algorithmic parameters
    EXTRA_PARAMETERS               % Extra parameters
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the LF data from the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);

        data = textscan(line,'%s');
        
        try
            self.DRIVER_ID = data{1}{1};
            self.SUBDRIVER_ID = data{1}{2};
        catch
            self.DRIVER_ID = data{1}{1};
        end

        % Iterator for extra parameters
        if strcmp(self.DRIVER_ID,"INI_STATE") | strcmp(self.DRIVER_ID,"TIME_DPNT") |...
           strcmp(self.DRIVER_ID,"STABILITY") | strcmp(self.DRIVER_ID,"__P_DELTA")
            EP_iterator = 0;
        elseif strcmp(self.DRIVER_ID,"S_PUSHOVER")
            EP_iterator = 2;
        elseif strcmp(self.DRIVER_ID,"DYNAMICS_T") | strcmp(self.DRIVER_ID,"EIGENMODES")
            EP_iterator = 3;
        else
            error('Unknow driver type in .dat file.')
        end

        % Standard parameters
        SP = []; 
        for i = 1:3
            line = fgetl(f);
            data = textscan(line,'%15.8f',8);
            SP = [SP,data{1}'];
        end
        self.STANDARD_PARAMETERS = SP;

        % Algorithmic parameters
        line = fgetl(f);
        AP = textscan(line,'%10u',10);
        self.ALGORITHMIC_PARAMETERS = AP{1};

        % Extra parameters
        EP = []; 
        for i = 1:EP_iterator
            line = fgetl(f);
            temp = textscan(line,'%15.8f',8);
            EP = [EP,temp{1}'];
        end
        self.EXTRA_PARAMETERS = EP;
        end

        function driver_index = get_driver_index(self,driver_label)
        %-------------------------------------------------------------------------------
        % Name:           get_driver_index
        % Purpose:        Give the position of the requested driver.
        % Last Update:    07.11.2023
        %-------------------------------------------------------------------------------
        driver_index = cellfun(@(x) strcmp(x,driver_label),{self.DRIVER_ID});
        end

        function modes_index = get_modes_index(self,struct)
        %-------------------------------------------------------------------------------
        % Name:           get_driver_index
        % Purpose:        Create a logical array with the selected modes.
        % Last Update:    07.11.2023
        %-------------------------------------------------------------------------------
        Mode_Exist = isfield(struct,"Mode");

        if Mode_Exist
            temp = struct.Mode;
            if strcmp(temp,'All')
                is_all = true;
            elseif isnumeric(temp)
                is_all = false;
            else
                error("Modes field must either be 'All' or be a vector ([M1,M2,...,Mn])")
            end
        else
            is_all = true;
        end
        
        index = self.get_driver_index("EIGENMODES");
        n_modes = self(index).STANDARD_PARAMETERS(1);

        if is_all
            Modes = ones(1,n_modes);
        else
            all_modes = 1:n_modes;
            Modes = zeros(1,n_modes);
            for i = 1:length(temp)
                if temp(i) == 0 | temp(i) > n_modes
                    error(['Requested mode must be greater than 0 and lower than ',num2str(n_modes)])
                end
                temp_boole = temp(i) == all_modes;
                Modes = Modes + temp_boole;
            end
        end
        modes_index = logical(Modes);
        end

    end    
end