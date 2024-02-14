function root_path = ZS_R_rootPath
root_path = fileparts(which('ZS_R'));
root_path = root_path(1:end-5);
end