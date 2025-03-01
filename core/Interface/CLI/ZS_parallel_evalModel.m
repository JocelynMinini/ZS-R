function [Y,ExeSucess] = ZS_parallel_evalModel(modelToEvaluate,Input,NThread,dispOpts,saveQ)
%-------------------------------------------------------------------------------
% Name:           uq_parallel_evalModel
% Purpose:        This function allows to evaluate in parallel a third-party 
%                 software in in the same was as uq_evalModel do. Nevertheless 
%                 it's not designed for evaluating another model than uq_link 
%                 type models. 
%
% Author:         Minini Jocelyn
%
% Last Update:    17.11.2023
% Version:        2023.05
% Licence:        free
%-------------------------------------------------------------------------------

tic % start a timer

% According to the number of available cores on the actual machine,
% the parallel pool is configured
%-------------------------------------------------------------------------------

if ~exist('NThread','var') % if third argument was not given, default threads = 10
    NThread = maxNumCompThreads;
end

if ~exist('dispOpts','var')
    dispOpts = true;
end

if ~exist('saveQ','var')
    saveQ = true;
end

try
    myCluster             = parcluster('local');
    myCluster.NumWorkers  = NThread;
    p                     = parpool(myCluster);
catch me
    %
end
%-------------------------------------------------------------------------------

try
% The function uq_generateINP will generate the N .inp files, see
% uq_generateINP documentation.
%-------------------------------------------------------------------------------
Template = modelToEvaluate.Internal.Template{1}; % Template name from taken from the model
Extension = strsplit(Template,'.');
Extension = Extension{end};

status = ZS_generateINP(modelToEvaluate,Input); % generate the inp files


if status == 0
    disp('### Calculation aborted by the user ###')
    fprintf('\n');
    Y = 'Aborted';
    delete(p); 
    return
else

pause(2)
%-------------------------------------------------------------------------------

% Load the parser and define it as a local function
%-------------------------------------------------------------------------------
temp_parser = modelToEvaluate.Internal.Output.Parser;
%-------------------------------------------------------------------------------

% Here the number of calculations, the execution path and the partitioning
% of the parallel pool is set
%-------------------------------------------------------------------------------
ExePath = modelToEvaluate.Internal.ExecutionPath;
InputDirPath = [ExePath,'\temp_Execution']; 
NFiles = size(dir(fullfile(InputDirPath, ['*.',Extension])),1); % count the number of .inp files
FileName = regexprep(modelToEvaluate.Internal.Output.FileName{1},'\.[^.]*$',''); 

add_folder = 'temp_Execution\\';
exeCmd_with_cd = cell(NFiles,1);
for i = 1:NFiles % generate a list with the string to be evaluate in windows command
    
    ExeCmd = modelToEvaluate.Internal.Command;
    pattern = [FileName,'.',Extension];
    replacement = sprintf([FileName,['%d.',Extension]], i);
    replacement = [add_folder,replacement];
    
    parts = split(ExeCmd, pattern);
    ExeCmd = strjoin(parts, replacement);
    
    exeCmd_with_cd{i,1} = ['cd /d "', InputDirPath, '" && ', ExeCmd];
    clear replacement
end

Blocks = fix(NFiles/NThread); % Number of blacks
remEl = rem(NFiles,NThread);  % Remainder files

if Blocks == 0
    Pool{1,1} = 1:remEl;            % if number of jobs < NThread (rare)
else
    it1 = 1;                          % if number of jobs > NThread (common)
    Pool = cell(Blocks,1);
    for i = 1:Blocks
        Pool{i,1} = it1:i*NThread;
        it1 = 1+NThread*i;
    end
    if  remEl>0                     % if number of jobs = NThread (common)
        Pool{i+1,1} = Pool{i}(end)+1:Pool{i}(end)+remEl;
    end

end
%-------------------------------------------------------------------------------

X = Input;

% Prelocate Y and run Pool in parallel with parfor and command
%-------------------------------------------------------------------------------
ExeSucess = zeros(NFiles,1);
Y = cell(NFiles,1);

if dispOpts
    fprintf('\n');
end

for j = 1:length(Pool)
parIndex = Pool{j};
if dispOpts
    disp(['Starting block n° : ',num2str(j,'%d'),'...'])
end
    parfor i = parIndex
        
        pause(randi([1,10]))
        if dispOpts
            disp(['Evaluation n° : ',num2str(i,'%d')])
        end
        status_run = system(exeCmd_with_cd{i}); % Run command

        if status_run ~= 0 %Check success
            warning('Third party software returned an error for run #%d \n: Returning NaN in the corresponding output');
            ExeSucess(i) = false ;
        else
            ExeSucess(i) = true ;
        end    
        
        Y{i} = temp_parser([InputDirPath,'\',FileName,num2str(i),['.',Extension]]); % read the output files with user parser and store the result in a cell
       
        if strcmp(modelToEvaluate.Internal.Archiving.Action,'delete')
            delete([InputDirPath,'\',FileName,num2str(i),'.*'])                % Delete the files in temp folder
            delete([InputDirPath,'\',upper(FileName),num2str(i),'.*'])         % Delete the files in temp folder (for uppercase)
        end
    end

    if saveQ
        save(fullfile(ExePath,['temp_',modelToEvaluate.Name,'.mat']),'X','Y');     % Save the current block iteration
    end

if dispOpts
    disp(['Block n° : ',num2str(j,'%d'),' - Saved !'])
    fprintf('\n');
end

end


try 
    if strcmp(modelToEvaluate.Internal.Archiving.Action,'delete')
        rmdir(InputDirPath,'s') % Delete the temp directory
    end
end

end
%-------------------------------------------------------------------------------

if saveQ
    save(fullfile(ExePath,[modelToEvaluate.Name,'.mat']),'X','Y'); % Save the files
end



if dispOpts
    disp('Done - File saved !')
    Time = toc;
    [h,m,s] = hms(seconds(Time));
    disp(['Total execution time : ',num2str(h,'%d'),'h ',num2str(m,'%d'),'m ',num2str(round(s),'%d'),'s'])
end

if isfile(fullfile(ExePath,['temp_',modelToEvaluate.Name,'.mat']))
    delete(fullfile(ExePath,['temp_',modelToEvaluate.Name,'.mat']))
end

catch ER
try 
    delete(p);
    rmdir(InputDirPath,'s')
end
error(['Error in execution - Error message : ',ER.message])
end