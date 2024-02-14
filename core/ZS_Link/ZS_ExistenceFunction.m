classdef ZS_ExistenceFunction

    properties(SetAccess=protected)
    ID           % EF Number
    end

    properties
    %NR           % Number of time periods of activity
    EXF    (:,2) % Matrix of the time periods activity
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read
        % Purpose:        Read the EF data from the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        line = fgetl(f);
        data = textscan(line,'%10d',2);
        data = cell2mat(data);

        self.ID = data(1);
        NP = data(2);

        temp = [];
        for i = 1:NP
            line = fgetl(f);
            data = textscan(line,'%15.8f',2);
            data = cell2mat(data);
            temp(end+1,:) = data';
        end
        self.EXF = temp;
        end
    end

    methods (Static = true)

        function write(EF_obj,file_path)
        %-------------------------------------------------------------------------------
        % Name:           write
        % Purpose:        Write the EF data in the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file_path,"r+");
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"EXISTFUN");
        end

        id = EF_obj.ID;
        ef_data = EF_obj.EXF;


        done = false;
        while ~done
            line = fgetl(f);
            data = textscan(line,'%10d',2);
            data = cell2mat(data);
            dat_id = data(1);
            np = data(2);
            done = id == dat_id;
            if ~done
                for i = 1:np
                    fgetl(f);
                end
            end
        end
        
        n_ef = size(ef_data);

        if n_ef(1) ~= np 
            error("The number of characteristic points in the existence function given by the user does not match the number of characteristic points in the .dat file.")
        end

        for i = 1:n_ef(1)
            for j = 1:n_ef(2)
                if contains(ef_data(i,j),'<')
                    fprintf(f,'%15s',ef_data(i,j));
                else
                    fprintf(f,'%15.8e',ef_data(i,j));
                end
            end
            fseek(f,2,0);
        end

        fclose(f);
        end
    end
    
end