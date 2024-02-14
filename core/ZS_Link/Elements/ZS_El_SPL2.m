classdef ZS_El_SPL2    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "SPL2"                         % Element class
    MAT_INDEX           {mustBeInteger}    % Material index
    NODES                                  % Nodes struct
    GP                                     % Gauss points struct
    L_REC_INDEX         {mustBeInteger}    % Index of the associated load record in the global list of load records
    L_REC_FACES         {mustBeInteger}    % Index of the element facet
    GROUP = "SEEPAGES"                     % Element group
    RES_GROUP = "-"                     % File extension result group
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
    self.NODES.DOMAIN = node_lst(1:2);
    self.NODES.PRESSURE_BC = node_lst(3:4);

    % Gauss points
    ksi = sqrt(3)/3;
    self.GP.N = 2;
    self.GP.XYZ = [-ksi ksi];
    self.GP.W = [1/2 1/2];           
    end

    end
    
end