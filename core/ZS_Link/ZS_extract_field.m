function res_field = ZS_extract_field(field,name)

    field_names = fieldnames(field);
    n = length(field_names);
    
    for i = 1:n
        test = cellfun(@(x) strcmp(x,name),field_names);
        if sum(test) == 1
            res_field = field.(sprintf(name));
            return
        else
            res_field = ZS_extract_field(field.(sprintf(field_names{i})),name);
        end
        return
    end
end