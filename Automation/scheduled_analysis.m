function pp_report = scheduled_analysis( )
%Function to be called by a MATLAB timer object at a fixed rate to ensure
%that analysis is scheduled and executed regularly

%put the main directory containing experiment data here.
experiment_directory = 'C:\Users\GolderbergLab\Documents\MATLAB\RodentJoystick\SampleData\0002';
%recipients of reports:
recipients={'nitin.shyamkumar@gmail.com', ...
            'glab.cornell@gmail.com', ...
            };%add new recipients of daily reports here
%log directory
logsdirloc = 'C:\Users\GolderbergLab\Documents\RodentProjectAutomatedLogs';


time = now;
toprocesslist = directories_to_do(experiment_directory);
title = {'Analysis attempted on the following directories:','', ''};
%attempt all analysis here
[failure, actual, succeed] = multi_doAll(toprocesslist, 2);
pp_report = [title; failure];

title = ['Analysis_', datestr(time,'mm_dd_yyyy_HH_MM')];
logname = [logsdirloc,'\',title,'.txt'];
fileID = fopen(logname,'w');
for i = 1:size(pp_report, 1)
    formatspec = '%s\r\n %s\r\n\r\n';
    fprintf(fileID, formatspec, pp_report{i, [1, 3]});
end
fclose(fileID);

pp_summary = ['Attempted processing on ', num2str(actual),...
                ' directories, succeeded on ', num2str(succeed),' of them.', ...
                ' Full report is attached.'];

matlabmail(recipients, pp_summary, title, logname);



end

