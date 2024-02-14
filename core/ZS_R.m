function ZS_R
ROOT = ZS_R_rootPath;
interface_path = [ROOT,'\core\Interface'];
addpath(genpath(interface_path));

fprintf('This is ZSOIL+R, version 1.0')
fprintf('\n')
fprintf('Copyright 2024, GeoDev Sàrl, Lausanne, Switzerland.')
fprintf('\n')
fprintf('Corresponding license available at:')
fprintf('\n')
disp([ROOT,'\LICENSE.'])
fprintf('\n')
disp('For any assistance, bug report or feature request, please fill the contact form online: <a href="https://zsoil.com/contact/">GeoDev.ch</a>.')
fprintf('\n')
user_manual_path = [char(39),ROOT,'\Documentation\Rep-ZS+R.pdf',char(39)];
disp(['Check the ZS+R documentation : <a href="matlab:winopen(',user_manual_path,')">ZS+R User manual</a>.'])
fprintf('\n');
end