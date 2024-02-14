function Model = ZS_createModel(OPTIONS)
%-------------------------------------------------------------------------------
% Name:           ZS_createModel
% Purpose:        Call UQLab and create a UQLab model class object but with
%                 ZSoil uniquely
% Last Update:    27.08.2023
%-------------------------------------------------------------------------------
if ~isstruct(OPTIONS)
    error("ERROR : Argument must be a MATLAB data structure")
end

if ~isfield(OPTIONS,"Name")
    error("ERROR : OPTIONS must contain the field 'Name'")
end

UQ_OPTS.Type = 'UQLink';
UQ_OPTS.Name = OPTIONS.Name;

% Instanciate the class software
Softwares = ZS_Softwares;
Softwares = Softwares.read_software_file("ZSOIL");

%% Template options

possible_extansions = [".inp.tpl.inp",".dat.tpl.dat","_.inp.tpl.inp","_.dat.tpl.dat"];

% Template Path
if isfield(OPTIONS,'Template') & isfield(OPTIONS.Template,'Path')
    if isfield(OPTIONS.Template,'Path')
        template_path = OPTIONS.Template.Path;
    end
else
    template_path = pwd;
end

% Template name
if isfield(OPTIONS,'Template') & isfield(OPTIONS.Template,'Name')
    if isfield(OPTIONS.Template,'Name')
        template_name = OPTIONS.Template.Name;
    end
else
    file_exist = [];
    for i = 1:length(possible_extansions)
        temp_file_name = char(fullfile(template_path,strcat(OPTIONS.Name,possible_extansions(i))));
        file_exist = [file_exist,isfile(temp_file_name)];
    end
    file_exist = logical(file_exist);
    logical_index = find(file_exist);

    if length(logical_index) > 1
        error("File extansion (.dat or .inp) must be unique when using default 'Name'.")
    end

    if logical_index == 1 | logical_index == 2
        temp_file_name = fullfile(template_path,strcat(OPTIONS.Name,possible_extansions(logical_index)));
        temp_file_name_with_underscore = fullfile(template_path,strcat(OPTIONS.Name,'_',possible_extansions(logical_index)));
        movefile(temp_file_name,temp_file_name_with_underscore)
    end

    if logical_index == 1 | logical_index == 3
        extansion = 'inp';
    else
        extansion = 'dat';
    end

    template_name = [OPTIONS.Name,'_.',extansion,'.tpl.',extansion];

end

UQ_OPTS.Template = template_name;
UQ_OPTS.TemplatePath = template_path;

%% Check if the template exists
if ~isfile([template_path,'\',template_name])
    error('No valid template file found in the requested path.')
end

%% Command options
% Extract the version to use 
if isfield(OPTIONS,'ZSoil')
    if ~isfield(OPTIONS.ZSoil,'Version')
        user_version = Softwares.get_last_version("ZSOIL");
    else
        user_version = OPTIONS.ZSoil.Version;
    end
else
    user_version = Softwares.get_last_version("ZSOIL");
end
zsoil_path = Softwares.get_path("ZSOIL",user_version);


% Extract execution path
if isfield(OPTIONS,'ExecutionPath')
    execution_path = OPTIONS.ExecutionPath;
else
    execution_path = pwd;
end
UQ_OPTS.ExecutionPath = execution_path;

% Extract name of the output file (same as template)
extansion = template_name(end-2:end);
output_file_name = erase(template_name,['.tpl.',extansion]);

% Silent mode
if strcmp(extansion,'inp')
    silent_mode = ' /E';
elseif strcmp(extansion,'dat')
    silent_mode = '';
end
if isfield(OPTIONS,"ZSoil") & isfield(OPTIONS.ZSoil,"SilentMode")
    if strcmp(OPTIONS.ZSoil.SilentMode,'on')
        if strcmp(extansion,'inp')
            silent_mode = ' /S';
        elseif strcmp(extansion,'dat')
            silent_mode = '[#@QUIET_MODE@#]';
        end
    elseif strcmp(OPTIONS.ZSoil.SilentMode,'off')
        %
    else
        error("'SilentMode' option must be 'on' or 'off'.")
    end
end

% Make the command line
if strcmp(extansion,'inp')
    zsoil_path_with_exe = [char(zsoil_path),'\Z_Soil.exe'];
    command = strcat('"',zsoil_path_with_exe,'" "',execution_path,'\',output_file_name,'"',silent_mode);
elseif strcmp(extansion,'dat')
    zsoil_path_with_exe = [char(zsoil_path),'\Z_Calc.exe'];
    version_year = char(user_version);
    version_year = version_year(2:3);
    start_dir = [' [#@STARTDIR C:\ProgramData\ZSoil v20',version_year,'\FULL@#]'];
    dat_launcher_file_name = erase(output_file_name,['.',extansion]);
    prj = [' [#@PRJ ',execution_path,'\',dat_launcher_file_name,'@#]'];
    command = strcat('"',zsoil_path_with_exe,'"',start_dir,' ',prj,silent_mode);
end
UQ_OPTS.Command = command;

%% Output options
UQ_OPTS.Output.FileName = output_file_name;

if ~isfield(OPTIONS,'Parser')
    error("'Parser' field is mandatory.")
end

try 
    UQ_OPTS.Output.Parser = OPTIONS.Parser.Name;
catch
    error("'Parser.Name' field is mandatory.")
end

try 
    addpath(OPTIONS.Parser.Path);
end

%% Counter options
if ~isfield(OPTIONS,'Counter')
    UQ_OPTS.Counter.Digits = 1;
else
    UQ_OPTS.Counter.Digits = OPTIONS.Counter;
end

%% Archiving options
if ~isfield(OPTIONS,'Archiving')
    UQ_OPTS.Archiving.Action = 'delete';
else
    UQ_OPTS.Archiving.Action = OPTIONS.Archiving;
end

Model = uq_createModel(UQ_OPTS,'-private');
end