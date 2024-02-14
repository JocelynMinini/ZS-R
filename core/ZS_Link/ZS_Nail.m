classdef ZS_Nail    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "NAIL"                         % Element class
    NB                  {mustBeInteger}    % Mumber of beam elements within the pile
    NAIL_DATA           {mustBeInteger}    % Pile discretization data [beam element index , shaft interface element index]
    GROUP = "TRUSS"                        % Element group
    RES_GROUP = [".s03",".nal"]            % File extension result group
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the nails data from the .dat file.
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);

        data = textscan(line,'%10u',3);
        self.ID = data{1}(1);
        self.NB = data{1}(2);

        temp = [];
        for i = 1:self.NB
            line = fgetl(f);
            data = textscan(line,'%10u',2);
            temp = [temp;data{1}'];
        end
        self.NAIL_DATA = temp;  

        end

        function BEAM_ELE = get_beam_ele_ID(self,NAIL_ID)
        %-------------------------------------------------------------------------------
        % Name:           get_truss_ele_ID
        % Purpose:        Return the list of the truss element associated
        %                 with the nail
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        IDs = [self.ID];
        BEAM_ELE = [];
        for i = 1:length(NAIL_ID)
            BOOLE_ID = NAIL_ID(i) == IDs;
            temp = self(BOOLE_ID).NAIL_DATA(:,1);
            BEAM_ELE = [BEAM_ELE,temp];
        end
        end

        function CONTACT_ELE = get_contact_ele_ID(self,NAIL_ID)
        %-------------------------------------------------------------------------------
        % Name:           get_contact_ele_ID
        % Purpose:        Return the list of the contact element associated
        %                 with the nail
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        IDs = [self.ID];
        CONTACT_ELE = [];
        for i = 1:length(NAIL_ID)
            BOOLE_ID = NAIL_ID(i) == IDs;
            temp = self(BOOLE_ID).NAIL_DATA(:,2);
            CONTACT_ELE = [CONTACT_ELE,temp];
        end
        end

        function IDs = get_ID(self,OPTS)
        %-------------------------------------------------------------------------------
        % Name:           get_nail_ID
        % Purpose:        Return the list of the contact element associated
        %                 with the nail
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        is_all = ~isfield(OPTS,"ID");

        if is_all
            IDs = [self.ID];
        else
            user_ID = OPTS.ID;
            NAIL_IDs = [self.ID];
            N_NAILS = length(NAIL_IDs);

            if length(user_ID) > N_NAILS
                error(strcat("The number of requested nails exceeds the total number of nails."))
            end
    
            if max(user_ID) > max(NAIL_IDs)
                error(strcat("One reqested element ID is out of the element IDs range."))
            end

            if ~(length(user_ID) == length(unique(user_ID)))
                error(strcat("There are some duplicates in the requested nails."))
            end
    
            if ~issorted(user_ID)
                error("Nail IDs must be given in ascending order.")
            end

            IDs = user_ID;
        end
        end
   end
    
end