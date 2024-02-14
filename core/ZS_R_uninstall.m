function ZS_R_uninstall
clc
CORE = fileparts(which('ZS_R_install'));
ROOT = CORE;


try
    fprintf('Uninstalling ZS+R module, please wait...\n\n');
    
    pause(1)

    textprogressbar('Uninstalling ZS+R: ','Backward');
    for i=1:100
        textprogressbar(i,'Backward');
        pause(0.02);
    end
    textprogressbar('\n\n','Backward');
    pause(1)

    % Delete dependencies
    delete(fullfile(ROOT,'DEPENDENCIES'))

    % remove the path of ZSROOT

    rmpath(genpath(fullfile(ROOT)))
    savepath

    clc
   
    fprintf('ZS+R was successfully uninstalled.\n');

catch me
    fprintf('The installation was not successful!\nThe installer returned the following message: %s\n\n', me.message);
end
end