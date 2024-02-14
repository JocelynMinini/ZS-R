classdef ZS_El_BEL2    

    properties
    ID                  {mustBeInteger}    % Element number
    LABEL = "BEL2"                         % Element class
    MAT_INDEX           {mustBeInteger}    % Material index
    NODES                                  % Nodes struct
    GP                                     % Gauss points struct
    L_REC_INDEX         {mustBeInteger}    % Index of the associated load record in the global list of load records
    L_REC_FACES         {mustBeInteger}    % Index of the element facet
    GROUP = "BEAMS"                        % Element group
    RES_GROUP = ".s04"                     % File extension result group
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
        self.NODES.MASTER   = node_lst(1:2);
        self.NODES.CENTROID = node_lst(3:4);
        self.NODES.DIRECTOR = node_lst(5:6);
    end

    % Gauss points
    self.GP.N = 1;
    self.GP.XYZ = 0;
    self.GP.W = 2;           
    end

    end

    methods(Static)

    function beam_length = get_beam_length(BEL2_OBJ,NODES_OBJ)
    %-------------------------------------------------------------------------------
    % Name:           get_beam_length
    % Purpose:        Get the length of a BEL2 object in 2D or 3D
    % Last Update:    29.09.2023
    %-------------------------------------------------------------------------------
    beam_nodes = (BEL2_OBJ.NODES.MASTER(1:2))';
    XYZ = {NODES_OBJ(beam_nodes).XYZ};
    beam_length = norm(XYZ{1}-XYZ{2});
    end

    end
    
end