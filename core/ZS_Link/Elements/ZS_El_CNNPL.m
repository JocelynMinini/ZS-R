classdef ZS_El_CNNPL    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "CNNPL"                         % Element class
    MAT_INDEX           {mustBeInteger}    % Material index
    NODES                                  % Nodes struct
    GP                                     % Gauss points struct
    L_REC_INDEX         {mustBeInteger}    % Index of the associated load record in the global list of load records
    L_REC_FACES         {mustBeInteger}    % Index of the element facet
    GROUP = "CONTACTS"                     % Element group
    RES_GROUP = ".s07"                     % File extension result group
    end

    methods

    function self = Instanciate(self,node_lst)
    %-------------------------------------------------------------------------------
    % Name:           Instanciate
    % Purpose:        Constructor.
    % Last Update:    11.10.2023
    %-------------------------------------------------------------------------------
    % Nodes
    self.NODES.N = length(node_lst);
    self.NODES.ID = node_lst;

    % Gauss points;
    self.GP.N = 1;
    self.GP.XYZ = [0 0 0]; % To be checked
    self.GP.W = 1;           
    end

    end
    
end