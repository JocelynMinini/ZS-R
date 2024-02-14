classdef ZS_ZSoil    

    properties
    N         double % Number of ZSoil .exe file 
    LOCATIONS string % Contain the location of ZSoil.exe
    VERSIONS  string % Contain all versions of ZSoil.exe on the current machine
    end
    
    methods

        function self = Instanciate(self)
        %-------------------------------------------------------------------------------
        % Name:           Instanciate
        % Purpose:        Class constructor + display
        % Last Update:    14.02.2024
        %-------------------------------------------------------------------------------
        fprintf('\n - Searching for ZSoil dependencies.................');
        zs_path = self.search_zsoil;
        zs_path = string(zs_path);
        pause(0.2)
        fprintf('[OK]\n');
        pause(0.2)
        if all(~contains(zs_path,'Z_Soil.exe'))
            error('No ZSoil version found on this machine.')
        else
            index = contains(zs_path,'Z_Soil.exe');
            self = get_path(self,zs_path(index));
            self = get_version(self,zs_path(index));
        end

        % Delete the path for ZSslopes and ZSwalls as ZS+R does not run on
        % this modules
        index = arrayfun(@(x) contains(x,'ZSslopes'),self.LOCATIONS);
        index = index + arrayfun(@(x) contains(x,'ZSwalls'),self.LOCATIONS);
        index = logical(index);

        self.LOCATIONS(index) = [];
        self.VERSIONS(index)  = [];
        self.N = self.N - sum(index);

        fprintf(['   ',num2str(self.N),' ZSoil version(s) found :\n'])
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
        % Purpose:        Extract the path to Z_Soil.exe
        % Last Update:    20.10.2023
        %-------------------------------------------------------------------------------
        self.N = length(path);
        self.LOCATIONS = arrayfun(@(x) erase(x,'\Z_Soil.exe'),path);
        end

        function self = get_version(self,path)
        %-------------------------------------------------------------------------------
        % Name:           get_version
        % Purpose:        Extract the version from Z_Soil.exe
        % Last Update:    08.02.2024
        %-------------------------------------------------------------------------------
        cd([ZS_R_rootPath,'\core\ZS+R'])
        version = string.empty;
        for i = 1:self.N
            [status, result] = system(sprintf('cscript -nologo FileProductVer.vbs "%s"', path(i)));
            if contains(result,'ProductVersion')
                result  = strsplit(result,'\n');
                result  = result{2};
                result  = erase(result,'ProductVersion: ');
                result  = strsplit(result,{'.',','});
                year    = str2double(result{1});
                v       = str2double(result{2});
                temp    = ['v',sprintf('%02d ',year),sprintf('%02d ',v)];
                temp    = strtrim(temp);
                version = [version;strrep(temp,' ','.')];
            end
        end
        self.VERSIONS = version;
        cd([ZS_R_rootPath,'\core'])
        end
    end

    methods(Static = true)
        
        function path = search_zsoil
        %-------------------------------------------------------------------------------
        % Name:           search_zsoil
        % Purpose:        Search for Z_Soil.exe in all hard disks on the
        %                 machine
        % Last Update:    08.02.2024
        %-------------------------------------------------------------------------------
        drives = upper(ZS_Softwares.getdrives);
        ZS_path = {};
        for i = 1:length(drives)
            cd(drives{i})

            [status,cmd_output] = system(['dir Z_Soil.exe /b/s']);
            cmd_output = strsplit(cmd_output,'\n');
            boole = cellfun(@isempty, cmd_output);
            cmd_output = cmd_output(~boole);
            ZS_path = [ZS_path;cmd_output'];
        end
        index = [];
        for i = 1:length(ZS_path)
            index = [index,contains(ZS_path{i},'$Recycle.Bin')];
        end
        ZS_path(logical(index)) = [];
        path = ZS_path;
        cd([ZS_R_rootPath,'\core'])
        end

    end


end

