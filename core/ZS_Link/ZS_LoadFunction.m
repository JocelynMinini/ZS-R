classdef ZS_LoadFunction < dynamicprops

    properties(SetAccess = protected)
    ID           % LF Number
    end

    properties
    %NP           % Number of characteristic points
    LTF     (:,2) % Matrix of the characteristic points
    end

    methods

        function self = read(self,f)
        %-------------------------------------------------------------------------------
        % Name:           read
        % Purpose:        Read the LF data from the .dat file.
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
            data = textscan(line,'%15.8f',3);
            data = cell2mat(data);
            temp(end+1,:) = data';
        end
        temp(:,3) = [];
        self.LTF = temp;
        end

        
    end


    methods (Static = true)

        function write(LF_obj,file_path)
        %-------------------------------------------------------------------------------
        % Name:           write
        % Purpose:        Write the LF data in the .dat file.
        % Last Update:    27.08.2023
        %-------------------------------------------------------------------------------
        f = fopen(file_path,"r+");
        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,"LOADTIME");
        end

        id = LF_obj.ID;
        lf_data = LF_obj.LTF;


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
        
        n_lf = size(lf_data);

        if n_lf(1) ~= np 
            error("The number of characteristic points in the load time function given by the user does not match the number of characteristic points in the .dat file.")
        end

        for i = 1:n_lf(1)
            for j = 1:n_lf(2)
                if contains(lf_data(i,j),'<')
                    fprintf(f,'%15s',lf_data(i,j));
                else
                    fprintf(f,'%15.8e',lf_data(i,j));
                end
            end
            fseek(f,15+2,0);
        end

        fclose(f);
        end
    end
    
end