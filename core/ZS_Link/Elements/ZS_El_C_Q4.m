classdef ZS_El_C_Q4    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "C_Q4"                         % Element class
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
    self.GP.N = 4;
    ksi = sqrt(3)/3;
    self.GP.XYZ = [-ksi -ksi ; ksi -ksi ; ksi ksi ; -ksi ksi];
    self.GP.W = [1 1 1 1];           
    end

    end
    
end