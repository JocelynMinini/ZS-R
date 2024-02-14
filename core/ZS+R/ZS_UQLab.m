classdef ZS_UQLab    

    properties
    N         double % Number of UQlab .m file 
    LOCATIONS string % Contain the location of uqlab
    VERSIONS  string % Contain all versions of uqlab on the current machine
    end
    
    methods

        function self = Instanciate(self)
        %-------------------------------------------------------------------------------
        % Name:           Instanciate
        % Purpose:        Class constructor + display
        % Last Update:    20.10.2023
        %-------------------------------------------------------------------------------
        fprintf('\n - Searching for UQLab dependencies.................');
        uq_path = self.search_uqlab;
        uq_path = string(uq_path);
        pause(0.2)
        fprintf('[OK]\n');
        pause(0.2)
        if all(~contains(uq_path,'uqlab.m'))
            error('No UQLab version found on this machine.')
        else
            index = contains(uq_path,'uqlab.m');
            self = get_path(self,uq_path(index));
            self = get_version(self,uq_path(index));
        end

        fprintf(['   ',num2str(self.N),' UQLab version(s) found :\n'])
        for i = 1:self.N
            pause(0.2)
            fprintf('   - ')
            fprintf(self.VERSIONS(i,:));
            fprintf('\n')
        end
        pause(1)
        end
        
        function self = get_path(self,path)
        %-------------------------------------------------------------------------------
        % Name:           get_paths
        % Purpose:        Extract the path to uqlab.m
        % Last Update:    20.10.2023
        %-------------------------------------------------------------------------------
        self.N = length(path);
        self.LOCATIONS = arrayfun(@(x) erase(x,'\uqlab.m'),path);
        end

        function self = get_version(self,path)
        %-------------------------------------------------------------------------------
        % Name:           get_version
        % Purpose:        Extract the version from uqlab
        % Last Update:    20.10.2023
        %-------------------------------------------------------------------------------
        version = string.empty;
        for i = 1:self.N
            temp_path = path{i};
            temp_path = erase(temp_path,'\core\uqlab.m');
            temp_path = [temp_path,'\modules\VERSION'];
            temp = readlines(temp_path);
            version = [version;temp(1)];
        end
        self.VERSIONS = version;
        end
    end

    methods(Static = true)
        
        function path = search_uqlab
        %-------------------------------------------------------------------------------
        % Name:           search_zsoil
        % Purpose:        Search for Z_Soil.exe in all hard disks on the
        %                 machine
        % Last Update:    20.10.2023
        %-------------------------------------------------------------------------------
        drives = upper(ZS_Softwares.getdrives);
        UQ_path = {};
        for i = 1:length(drives)
            cd(drives{i})

            [status,cmd_output] = system(['dir uqlab.m /b/s']);
            cmd_output = strsplit(cmd_output,'\n');
            boole = cellfun(@isempty, cmd_output);
            cmd_output = cmd_output(~boole);
            UQ_path = [UQ_path;cmd_output'];
        end
        path = UQ_path;
        cd([ZS_R_rootPath,'\core'])
        end

    end



end

