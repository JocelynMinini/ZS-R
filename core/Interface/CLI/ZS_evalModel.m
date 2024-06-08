function [Y,ExeSucess] = ZS_evalModel(modelToEvaluate,Input)
%-------------------------------------------------------------------------------
% Name:           ZS_evalModel
% Purpose:        This function allows to evaluate in sequential a third-party 
%                 software in in the same was as uq_evalModel do. Nevertheless 
%                 it's not designed for evaluating another model than uq_link 
%                 type models. 
% Last Update:    17.11.2023
%-------------------------------------------------------------------------------

t_Start = tic; % start a timer

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
    replacement = sprintf([FileName,'%d.inp'], i);
    replacement = [add_folder,replacement];
    
    parts = split(ExeCmd, pattern);
    ExeCmd = strjoin(parts, replacement);
    
    exeCmd_with_cd{i,1} = ['cd /d "', InputDirPath, '" && ', ExeCmd];
    clear replacement
end

% Prelocate Y and run Pool in parallel with parfor and command
%-------------------------------------------------------------------------------
ExeSucess = zeros(NFiles,1);
Y = cell(NFiles,1);
fprintf('\n');

for i = 1:NFiles
    
    disp(['Evaluation n° : ',num2str(i,'%d')])
    status_run = system(exeCmd_with_cd{i}); % Run command

    if status_run ~= 0 %Check success
        warning('Third party software returned an error for run #%d \n: Returning NaN in the corresponding output');
        ExeSucess(i) = false ;
    else
        ExeSucess(i) = true ;
    end    
    
    Y{i} = temp_parser([InputDirPath,'\',FileName,num2str(i),'.',Extension]); % read the output files with user parser and store the result in a cell
   
    if strcmp(modelToEvaluate.Internal.Archiving.Action,'delete')
        delete([InputDirPath,'\',FileName,num2str(i),'.*'])                % Delete the files in temp folder
        delete([InputDirPath,'\',upper(FileName),num2str(i),'.*'])         % Delete the files in temp folder (for uppercase)
    end
end
fprintf('\n');

try 
    if strcmp(modelToEvaluate.Internal.Archiving.Action,'delete')
        rmdir(InputDirPath,'s') % Delete the temp directory
    end
end

end
%-------------------------------------------------------------------------------

%save(fullfile(ExePath,[modelToEvaluate.Name,'.mat']),'X','Y'); % Save the files
disp('Done !')
Time = toc(t_Start);
[h,m,s] = hms(seconds(Time));
disp(['Total execution time : ',num2str(h,'%d'),'h ',num2str(m,'%d'),'m ',num2str(round(s),'%d'),'s'])

catch ER
try 
    rmdir(InputDirPath,'s')
end
error(['Error in execution - Error message : ',ER.message])
end