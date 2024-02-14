function New_X = ZS_removeConstant(X)
%-------------------------------------------------------------------------------
% Name:           ZS_removeConstant
% Purpose:        This function will remove the constant variables in the X
%                 matrix according to the input object
% Last Update:    02.11.2023
%-------------------------------------------------------------------------------
N_X = size(X);

Cst = [];

for i = 1:N_X(2)
    Cst = [Cst, numel(unique(X(:,i))) == 1];
end

Cst = logical(Cst);

New_X = X(:,~Cst);
end