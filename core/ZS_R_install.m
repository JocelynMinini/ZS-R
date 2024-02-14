function ZS_R_install
clc
CORE = fileparts(which('ZS_R_install'));
ROOT = CORE;


try
    % Add the path of ZSROOT

    addpath(genpath(fullfile(ROOT)), '-BEGIN');
    rmpath(genpath(fullfile(ROOT,'Interface')))

    status = savepath;
    if status
        fprintf(['Warning: the ZS+R installer could not be save the MATLAB path.\n' ...
            'Please make sure that the MATLAB startup folder is set to a writable location in the MATLAB preferences:\n'...
            'Preferences->General->Initial Working Folder\n'
            ]);
    end

    fprintf('Installing ZS+R module, please wait...\n');
    pause(1)
    % Search for software dependencies
    Software = ZS_Softwares;
    Software.ZSOIL = Software.ZSOIL.Instanciate;
    Software.UQLAB = Software.UQLAB.Instanciate;
    Software.write_software_file

    if Software.ZSOIL.N < 0
        error('No ZSoil version found on this machine. Please install ZSoil first.') 
    end

    if Software.UQLAB.N < 0
        error('No UQLab version found on this machine. Please install UQLab first.')
    end

    fprintf('\nZS+R installation complete! \n\n');

    textprogressbar('Launching ZS+R: ','Forward');
    for i=1:100
        textprogressbar(i,'Forward');
        pause(0.02);
    end
    textprogressbar('\n\n','Forward');
    pause(1)
    clc
    ZS_R;
    
catch me
    fprintf('The installation was not successful!\nThe installer returned the following message: %s\n\n', me.message);
end
end