function OPTS = ZS_Exe_ToStruct(full_file)
%-------------------------------------------------------------------------------
% Name:           ZS_Exe_ToStruct (In progression)
% Purpose:        Convert a text file input to a MATLAB struct
% Last Update:    11.01.2024
%-------------------------------------------------------------------------------

if ~isstring(full_file) & ~ischar(full_file)
    error("Please provide the full path of the txt file as a string.")
end


txt = readlines(full_file);

for i = 1:length(txt)
    eval(txt(i));
end
end

