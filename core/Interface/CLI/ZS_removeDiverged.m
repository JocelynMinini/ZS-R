function [New_X,New_Y] = ZS_removeDiverged(X,Y)
%-------------------------------------------------------------------------------
% Name:           ZS_removeDiverged
% Purpose:        This function will remove the diverged samples according
%                 to the Y variables and adjust X 
% Last Update:    05.11.2023
%-------------------------------------------------------------------------------
is_empty = cellfun(@isempty,Y);
New_X = X(~is_empty,:);
New_Y = Y(~is_empty,:);
end