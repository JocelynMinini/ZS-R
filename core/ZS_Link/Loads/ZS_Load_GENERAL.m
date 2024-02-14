classdef ZS_Load_GENERAL    
%-------------------------------------------------------------------------------
% Concern:        All class of loads (common properties)
%-------------------------------------------------------------------------------
    properties
    ID                  {mustBeInteger}    % Element number
    EXF                 {mustBeInteger}    % Existence function index
    LABEL               string             % Element class
    LTF                 {mustBeInteger}    % Load time function index
    LOAD_MODE           {mustBeInteger}    % Flag for standard/variable load (std = 0, var = 1)
    LOCAL_BASE          {mustBeInteger}    % Index of the local base used
    ULF                 double             % Unloading function index
    end
    
end