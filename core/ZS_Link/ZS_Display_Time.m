function ZS_Display_Time(TIME_TOC,PRINT_OPTS,WAIT_TIME,IS_ERROR)
%-------------------------------------------------------------------------------
% Name:           ZS_Display_Time
% Purpose:        Display the time elapsed according to last toc
% Last Update:    02.10.2023
%-------------------------------------------------------------------------------

if nargin == 3

    if PRINT_OPTS
        fprintf('[OK]        t = ')
        fprintf('%.2f', TIME_TOC)
        fprintf(' s')
        fprintf('\n')
        pause(WAIT_TIME)
    end

elseif nargin == 4

    if PRINT_OPTS
        fprintf('[Failed]')
        fprintf('\n')
        fprintf('   Please check the returned object (MExeption).\n')
        pause(WAIT_TIME)
    end

end

end