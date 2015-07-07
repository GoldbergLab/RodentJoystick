function scheduled_analysis( )
%Function to be called by a MATLAB timer object at a fixed rate to ensure
%that analysis is scheduled and executed regularly

%put the main directory containing experiment data here.
experiment_directory = 'C:\Users\GolderbergLab\Documents\MATLAB\RodentJoystick\SampleData\0002';
%recipients of reports:
recipients={'nitinshyamk@gmail.com', ...
            'glab.cornell@gmail.com', ...
            };%add new recipients of daily reports here
%log directory
logsdirloc = 'C:\Users\GolderbergLab\Documents\RodentProjectAutomatedLogs';


time = now;
toprocesslist = directories_to_do(experiment_directory);
title = {'Analysis attempted on the following directories:','', ''};
%attempt all analysis here
failure = multi_doAll(toprocesslist, 2);
pp_report = [title; failure];

title = ['Analysis_', datestr(time,'mm_dd_yyyy_HH_MM')];
logname = [logsdirloc,'\',title,'.txt'];
fileID = fopen(logname,'w');
for i = 1:size(failure, 1)
    formatspec = '%s %s %s\n';
    fprintf(fileID, formatspec, pp_report{i, :});
end
fclose(fileID);

matlabmail(recipients, pp_report, title);



end

