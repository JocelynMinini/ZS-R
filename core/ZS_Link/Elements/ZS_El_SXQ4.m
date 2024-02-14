classdef ZS_El_SXQ4    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "SXQ4"                         % Element class
    MAT_INDEX           {mustBeInteger}    % Material index
    NODES                                  % Nodes struct
    GP                                     % Gauss points struct
    L_REC_INDEX         {mustBeInteger}    % Index of the associated load record in the global list of load records
    L_REC_FACES         {mustBeInteger}    % Index of the element facet
    GROUP = "SHELLS"                       % Element group
    RES_GROUP = ".s02"                     % File extension result group
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

    % Gauss points
    self.GP.N = 1;
    self.GP.XYZ = [0,0];
    self.GP.W = 4;           
    end

    end
    
end