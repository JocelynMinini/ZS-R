function  status = ZS_generateINP(Link_Model,X_ED,DISP_OPTS)
%-------------------------------------------------------------------------------
% Name:           uq_generateINP
% Purpose:        This function allows to generate the .inp files according
%                 to the size and the elements of the input.
%                 This function is only applicable to .inp and .dat files (ZSoil)
%
% Author:         Minini Jocelyn
%
% Last Update:    17.11.2023
% Version:        2022.01
% Licence:        free
%-------------------------------------------------------------------------------

 if ~exist('DISP_OPTS','var')
      DISP_OPTS = false;
 end

Template = Link_Model.Internal.Template{1};
Template_path = Link_Model.Internal.TemplatePath;
Template_with_path = fullfile(Template_path,Template);
exe_path = Link_Model.Internal.ExecutionPath;

if ischar(Template) % check if template is a string
    FileName = Template;
    for i= 1:3 % cut the suffix (3x times because of .inp.tpl.inp)
        FileName=regexprep(FileName,'\.[^.]*$',''); 
    end

Extension = strsplit(Template,'.');
Extension = Extension{end};

% Construct lists according to the size of the input
%-------------------------------------------------------------------------------
    LX_ED = size(X_ED);
    Names = cell(1,LX_ED(2));
    NewFileNames = cell(1,LX_ED(1));
    
    Suffix_1 = "X000";
    Suffix_2 = "X00";
    
    for i = 1:LX_ED(2) % construct a cell containing the name of the random variables
        if i < 10
            Names{i} = strcat(Suffix_1,num2str(i));
        else
            Names{i} = strcat(Suffix_2,num2str(i));
        end
    end

    for i = 1:LX_ED(1) % construct a cell containing the name of the files to be generated
        NewFileNames{i} = strcat(FileName,num2str(i),['.',Extension]);
    end
%-------------------------------------------------------------------------------


% Message box and buttons
%-------------------------------------------------------------------------------
if DISP_OPTS
    promptMessage = sprintf(append('The size of the input is',' ',num2str(length(Names)),' x',num2str(length(NewFileNames)),'\n','Executing the command will generate',' ',num2str(LX_ED(1)),' ','INP files','\n','Do you want to Execute the command,\nor Abord to stop processing?'));
    button = questdlg(promptMessage, 'Execute', 'Execute', 'Abord', 'Execute');
    if strcmpi(button, 'Abord')
       status = 0;
       return
    end
    clear i button promptMessage Suffix_2 Suffix_1
end
%-------------------------------------------------------------------------------

% Message box for saving the input as a .mat file
%-------------------------------------------------------------------------------
if DISP_OPTS
     box_Title    = 'Save the input';
     box_Question = 'Do you want to save the input in a .mat file?';
     choice = questdlg(box_Question,box_Title,'Yes','No', 'Yes');
    if strcmpi(choice, 'Yes')
       save('Input.mat','X_ED');
    end
    clear i button promptMessage Suffix_2 Suffix_1
end
%-------------------------------------------------------------------------------

% Manage the temp_folder
%-------------------------------------------------------------------------------
    if isfolder(fullfile(exe_path,'temp_Execution'))
        try
            rmdir(fullfile(exe_path,'temp_Execution'),'s')
        catch
            close all
            rmdir(fullfile(exe_path,'temp_Execution'),'s')
        end
        mkdir(fullfile(exe_path,'temp_Execution')) % create the directory "InputFiles"
    else
        mkdir(fullfile(exe_path,'temp_Execution')) % create the directory "InputFiles"
    end
%-------------------------------------------------------------------------------


% Create the .inp files sequentially (may be parallelized...)
%-------------------------------------------------------------------------------
    S_Original = fileread(Template_with_path); % load the template

    for j = 1:LX_ED(1) % write the .inp files
        S = S_Original;
        X_Str_Mat = extractBetween(S,'<','>'); 

        for i = 1:LX_ED(2)
            eval(strcat(Names{i},'=',num2str(X_ED(j,i)),';'));
        end
  
            for i = 1:size(X_Str_Mat,1)
                try
                    X_Str_Mat{i,2} = eval(X_Str_Mat{i,1});
                catch ME
                    error(strcat("Error while evaluating the expression : '",X_Str_Mat{i,1},"'. Please check your syntax in the template file. ", "Returned message : ",ME.message))
                end
                X_Str_Mat{i,1} = append('<',X_Str_Mat{i,1},'>');
            end

        for k = 1:size(X_Str_Mat,1)
            X_Find = X_Str_Mat{k,1};
            if strcmp(Extension,'dat')
                X_Replace = num2str(X_Str_Mat{k,2},'%0.8e');
            else
                X_Replace = num2str(X_Str_Mat{k,2});
            end
            S = strrep(S, X_Find, X_Replace);
        end

        fid = fopen(fullfile(exe_path,'temp_Execution',NewFileNames{j}), 'w');
        fwrite(fid, S);
        fclose(fid);
    clear X_Str_Mat S
    status = -1;
    end
%-------------------------------------------------------------------------------


else   
    status = 0;
    error('First argument must be a string')
end
end