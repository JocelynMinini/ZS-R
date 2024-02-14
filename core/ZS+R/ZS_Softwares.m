classdef ZS_Softwares 
    properties
    ZSOIL = ZS_ZSoil
    UQLAB = ZS_UQLab
    end

    methods
        function write_software_file(self)
        %-------------------------------------------------------------------------------
        % Name:           write_software_file
        % Purpose:        Write the file with the software dependencies
        % Last Update:    25.10.2023
        %-------------------------------------------------------------------------------
        f = 'DEPENDENCIES';
        if isfile(f)
            delete(f)
        end
        fileID = fopen(f,"w");
        fprintf(fileID,'%s','ZSOIL|');
        fprintf(fileID,'%u',self.ZSOIL.N);
        fprintf(fileID,'\n');
        for i = 1:self.ZSOIL.N
            line = strcat(self.ZSOIL.VERSIONS(i),"|",self.ZSOIL.LOCATIONS(i));
            fprintf(fileID,'%s',line);
            fprintf(fileID,'\n');
        end
        fprintf(fileID,'%s','UQLAB|');
        fprintf(fileID,'%u',self.UQLAB.N);
        fprintf(fileID,'\n');
        for i = 1:self.UQLAB.N
            line = strcat(self.UQLAB.VERSIONS(i),"|",self.UQLAB.LOCATIONS(i));
            fprintf(fileID,'%s',line);
            fprintf(fileID,'\n');
        end
        fclose('all');
        end

        function self = read_software_file(self,software)
        %-------------------------------------------------------------------------------
        % Name:           read_software_file
        % Purpose:        Read the file with the software dependencies
        % Last Update:    25.10.2023
        %-------------------------------------------------------------------------------
        ROOT = ZS_R_rootPath;
        f = fopen([ROOT,'\core\DEPENDENCIES']);

        done = false;
        while ~done
            line = fgetl(f);
            done  = contains(line,software);
        end

        N = strsplit(line,'|');
        N = str2double(N(2));
        self.(software).N = N;
        for i = 1:N
            line = fgetl(f);
            temp = strsplit(line,'|');
            self.(software).VERSIONS(i) = temp(1);
            self.(software).LOCATIONS(i) = temp(2);
        end

        end

        function last_version = get_last_version(self,software)
        %-------------------------------------------------------------------------------
        % Name:           get_last_version
        % Purpose:        Return the last version of ZSoil on the machine
        % Last Update:    25.10.2023
        %-------------------------------------------------------------------------------
        version = self.(software).VERSIONS;
        version_number = erase(version,'v');
        version_number = str2double(version_number);
        sorted_version_number = sort(version_number);
        sorted_version = string(sorted_version_number);
        sorted_version = arrayfun(@(x) strcat('v',x),sorted_version);
        last_version = sorted_version(end);
        end

        function path = get_path(self,software,version)
        %-------------------------------------------------------------------------------
        % Name:           get_last_version
        % Purpose:        Return the last version of ZSoil on the machine
        % Last Update:    25.10.2023
        %-------------------------------------------------------------------------------
        index = contains(self.(software).VERSIONS,version);
        if ~any(index)
            error(['The requested ZSOIL version (',version,') is not installed on the current machine.'])
        end
        path = self.(software).LOCATIONS(index);
        end

    end
    
    methods (Static = true)
        function ret = getdrives(varargin)
        %GETDRIVES  Get the drive letters of all mounted filesystems.
        %   F = GETDRIVES returns the roots of all mounted filesystems as a cell
        %   array of char arrays.
        %   
        %   On Windows systems, this is a list of the names of all single-letter 
        %   mounted drives.
        %
        %   On Unix systems (including Macintosh) this is the single root
        %   directory, /.
        % 
        %   F = GETDRIVES('-nofloppy') does not scan for the a: or b: drives on
        %   Windows, which usually results in annoying grinding sounds coming from
        %   the floppy drive.
        %   
        %   F = GETDRIVES('-twoletter') scans for both one- AND two-letter drive
        %   names on Windows.  While two-letter drive names are technically supported,
        %   their presence is in fact rare, and slows the search considerably.
        %
        %   Note that only the names of MOUNTED volumes are returned.  In 
        %   particular, removable media drives that do not have the media inserted 
        %   (such as an empty CD-ROM drive) are not returned.
        %
        %   See also EXIST, COMPUTER, UIGETFILE, UIPUTFILE.
        %   Copyright 2001-2009 The MathWorks, Inc.
        % Short-circut on non-Windows machines.
        if ~ispc
            ret = {'/'};
            return;
        end
        twoletter = false;
        nofloppy = false;
        % Interpret optional arguments
        for i = 1:nargin
            if strcmp('-nofloppy', varargin{i}), nofloppy = true; end
            if strcmp('-twoletter', varargin{i}), twoletter = true; end
        end
        % Initialize return cell array
        ret = {};
        % Handle -nofloppy flag, or lack thereof.
        startletter = 'a';
        if nofloppy
            startletter = 'c';
        end
        % Look for single-letter drives, starting at a: or c: as appropriate
        for i = double(startletter):double('z')
            if exist(['' i ':\'], 'dir') == 7
                ret{end+1} = [i ':\']; %#ok<AGROW>
            end
        end
        % Handle two-letter case.  The outer loop of this routine could have been
        % combined with the one above, but was left separate for clarity's sake.
        if twoletter
            for i = 'a':'z'
                for j = 'a':'z'
                    if exist([i j ':\'], 'dir') == 7
                        ret{end+1} = [i j ':\']; %#ok<AGROW>
                    end
                end
            end
        end
        end
    end

end

