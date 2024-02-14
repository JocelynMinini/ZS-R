function ZS_createParser
%-------------------------------------------------------------------------------
% Name:           ZS_createParser
% Purpose:        Open a new script with some prewritten syntax for the
%                 parser
% Last Update:    17.11.2023
%-------------------------------------------------------------------------------
ZS_ROOT = ZS_R_rootPath;
str = ['function RES = Parser(OutputFile)\n\n',...
       'try\n\n',...
       '[file_path,file_name] = fileparts(regexprep(OutputFile,''\\.[^.]*$'',''''));\n\n',...
       'OPTS.Job.Name = file_name;\n',...
       'OPTS.Job.Path = file_path;\n\n',...
       '%% Call ZS_read and parse your results here : \n',...
       '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n',...
       '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n',...
       'catch\n\n',...
       'RES = [];\n\n',...
       'end'];

str = sprintf(str);
editorService = com.mathworks.mlservices.MLEditorServices;
editorApplication = editorService.getEditorApplication();
editorApplication.newEditor(str);
end