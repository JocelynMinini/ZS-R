    classdef ZS_Pile    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "PILE"                         % Element class
    NB                  {mustBeInteger}    % Mumber of beam elements within the pile
    PILE_DATA           {mustBeInteger}    % Pile discretization data [beam element index , shaft interface element index]
    TIP_INTERFACE_EL    {mustBeInteger}    % Index of the associated load record in the global list of load records
    GROUP = "BEAMS"                        % Element group
    RES_GROUP = [".s04",".ppl"]            % File extension result group
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read(Constructor)
        % Purpose:        Read the Piles data from the .dat file.
        % Last Update:    02.10.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);

        data = textscan(line,'%10u',3);
        self.ID = data{1}(1);
        self.NB = data{1}(2);
        self.TIP_INTERFACE_EL = data{1}(3);

        temp = [];
        for i = 1:self.NB
            line = fgetl(f);
            data = textscan(line,'%10u',2);
            temp = [temp;data{1}'];
        end
        self.PILE_DATA = temp;
        end

        function BEAM_ELE = get_beam_ele_ID(self,PILE_ID)
        %-------------------------------------------------------------------------------
        % Name:           get_beam_ele_ID
        % Purpose:        Return the list of the beam element associated
        %                 with the pile
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        IDs = [self.ID];
        BEAM_ELE = [];
        for i = 1:length(PILE_ID)
            BOOLE_ID = PILE_ID(i) == IDs;
            temp = self(BOOLE_ID).PILE_DATA(:,1);
            BEAM_ELE = [BEAM_ELE,temp];
        end
        end

        function CONTACT_ELE = get_contact_ele_ID(self,PILE_ID)
        %-------------------------------------------------------------------------------
        % Name:           get_contact_ele_ID
        % Purpose:        Return the list of the contact element associated
        %                 with the pile
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        IDs = [self.ID];
        CONTACT_ELE = [];
        for i = 1:length(PILE_ID)
            BOOLE_ID = PILE_ID(i) == IDs;
            temp = self(BOOLE_ID).PILE_DATA(:,2);
            CONTACT_ELE = [CONTACT_ELE,temp];
        end
        end

        function IDs = get_ID(self,OPTS)
        %-------------------------------------------------------------------------------
        % Name:           get_pile_ID
        % Purpose:        Return the list of the contact element associated
        %                 with the pile
        % Last Update:    16.10.2023
        %-------------------------------------------------------------------------------
        is_all = ~isfield(OPTS,"ID") || strcmp(OPTS.ID,'All');


        if is_all
            IDs = [self.ID];
        else
            user_ID = OPTS.ID;
            PILE_IDs = [self.ID];
            N_PILES = length(PILE_IDs);

            if length(user_ID) > N_PILES
                error(strcat("The number of requested piles exceeds the total number of piles."))
            end
    
            if ~(length(user_ID) == length(unique(user_ID)))
                error(strcat("There are some duplicates in the requested piles."))
            end
    
            if ~issorted(user_ID)
                error("Pile IDs must be given in ascending order.")
            end

            IDs = user_ID;
        end
        end

   end
    
end