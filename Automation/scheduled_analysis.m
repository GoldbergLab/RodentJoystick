function pp_report = scheduled_analysis( )
%Function to be called by a MATLAB timer object at a fixed rate to ensure
%that analysis is scheduled and executed regularly

%put the main directory containing experiment data here.
experiment_directory = 'K:\automationtest\0009';
%recipients of reports:
recipients={'nitin.shyamkumar@gmail.com', ...
            'glab.cornell@gmail.com', ...
            };%add new recipients of daily reports here
%log directory
logsdirloc = 'J:\Users\GLab\Documents\RodentProjectAutomatedLogs';
%normal pellet count - anything outside of this range is specificalyl
%highlighted in the mail notification
normal_pellets = [110 300];

time = now;
toprocesslist = directories_to_do(experiment_directory);
title = {'Analysis attempted on the following directories:','', ''};
%attempt all analysis here
[failure, actual, succeed] = multi_doAll(toprocesslist, 2);
pp_report = [title; failure];
[bhvr_summary, bhvr_report] = behavior_report(toprocesslist, normal_pellets(1), normal_pellets(2));

try
    title = ['Analysis_', datestr(time,'mm_dd_yyyy_HH_MM')];
    logname = [logsdirloc,'\',title,'.txt'];
    fileID = fopen(logname,'w');
    for i = 1:size(pp_report, 1)
        formatspec = '%s\r\n %s\r\n\r\n';
        fprintf(fileID, formatspec, pp_report{i, [1, 3]});
    end
    for i = 1:size(bhvr_report, 1)
        formatspec = '%s %s %s\r\n';
        fprintf(fileID, formatspec, bhvr_report{i, :});
    end
    fclose(fileID);
catch
    disp('failed log write');
end
pp_summary = ['Attempted processing on ', num2str(actual),...
                ' directories, succeeded on ', num2str(succeed),' of them.', ...
                ' Full report is attached.'];
summary = [pp_summary, bhvr_summary];
try
    matlabmail(recipients, summary, title, logname);
catch
    disp('failed mail log');
end



end

