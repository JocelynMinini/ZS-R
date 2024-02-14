classdef ZS_Loads < dynamicprops    

    methods

        function self = read(self,f,n_Loads)
        %-------------------------------------------------------------------------------
        % Name:           read (Constructor)
        % Purpose:        Read the load data from the .dat file.
        % Last Update:    04.10.2023
        %-------------------------------------------------------------------------------
        for i = 1:n_Loads
            line = fgetl(f);
            data = textscan(line,'%10u%10u%10s%10u%10u%10u%10u');
            type = data{3}{1};
       
            type_with_ZS = ['ZS_Load_',type];
            type_empty = [type_with_ZS,'.empty()'];

            try 
                addprop(self,type);
            end

            if length(self.(type)) == 0
                self.(type) = eval(type_empty);
            end

            Load_class = eval(type_with_ZS);
            Load_class = Load_class.read(f,data);

            self.(type)(end+1,:) = Load_class;

        end

        end
   end
    
end