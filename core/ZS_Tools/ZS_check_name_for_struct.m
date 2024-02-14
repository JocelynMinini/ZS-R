function correct_field_name = check_name_for_struct(field_name)
%-------------------------------------------------------------------------------
% Name:           check_name_for_struct
% Purpose:        This function rewrite the string 'field_name' to an
%                 acceptable format for a struct field.
%
% Author:         Minini Jocelyn
%
% Last Update:    12.08.2023
% Version:        2023.01
% Licence:        free
%-------------------------------------------------------------------------------

if ~(isstring(field_name) | ischar(field_name))
    disp('Warning : The given field name is not a string.')
    try
        num2str(field_name);
    catch
        error('This field name could not be interpreted.')
    end
end

correct_field_name = field_name;
string_to_replace = {'.','-','$','/','\'};

for i = 1:length(string_to_replace)
    correct_field_name = strrep(correct_field_name,string_to_replace{i},'_');
end


end