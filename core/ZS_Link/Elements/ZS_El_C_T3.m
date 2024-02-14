classdef ZS_El_C_T3    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "C_T3"                          % Element class
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

    % Gauss points
    self.GP.N = 3;
    ksi = 1/6;
    self.GP.XYZ = [ksi ksi ; ksi 4*ksi ; 4*ksi ksi];
    self.GP.W = [ksi ksi ksi];           
    end

    end
    
end