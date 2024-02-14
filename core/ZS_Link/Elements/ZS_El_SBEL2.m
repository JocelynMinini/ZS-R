classdef ZS_El_SBEL2    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "SBEL2"                        % Element class
    MAT_INDEX           {mustBeInteger}    % Material index
    NODES                                  % Nodes struct
    GP                                     % Gauss points struct
    L_REC_INDEX         {mustBeInteger}    % Index of the associated load record in the global list of load records
    L_REC_FACES         {mustBeInteger}    % Index of the element facet
    GROUP = "BEAMS"                        % Element group
    RES_GROUP = [".s04",".L04"]            % File extension result group
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
    try
        self.NODES.MASTER = node_lst(1:2);
        self.NODES.CENTROID = node_lst(3:4);
        self.NODES.DIRECTOR = node_lst(5:6);
    end

    % Gauss points
    self.GP.N = 5;
    ksi = sqrt(21)/7;
    self.GP.XYZ = [-1;-ksi;0;ksi;1];
    self.GP.W = [1/10,49/90,32/45,49/90,1/10];
    end

    end
    
end