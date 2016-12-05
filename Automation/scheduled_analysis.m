% scheduled_analyis(experiment_directory)
%
%   runs the entire core analysis pipeline on any subdirectories of
%   experiment_directory containing raw, unprocessed data
%
% ARGUMENTS:
%
%   experiment_directory :: the desired experiment directory for running
%       automated analysis
%
function pp_report = scheduled_analysis(experiment_directory)
disp([datestr(now, 'HH:MM:SS'), ' Performing scheduled post processing analysis.']);

toprocesslist = directories_to_do(experiment_directory);


%attempt all analysis here
[report,newdirs, skipped_dats] = multi_doAll(toprocesslist, 1);
title = {'Analysis attempted on the following directories within ','',...
    experiment_directory};
pp_report = [title; report];

%after analysis - generate report of pellet counts and success rates of new
%data
try
    if length(newdirs)>0
        [bhvr_report] = behavior_report(newdirs);
    else
        bhvr_report = {'', '', ''};
    end
catch e
    bhvr_report = {getReport(e), '', ''};
end

%attempt to write data
try
    logname = write_analysis_log(experiment_directory, pp_report, bhvr_report, skipped_dats);
end
disp([datestr(now, 'HH:MM:SS'), ' Finished scheduled post processing analysis.']);
end

% Attempts to write a text log to the experiment_directory\AutomatedLogs
% folder
function logname = write_analysis_log(experiment_directory, pp_report, bhvr_report, skipped_data)
try %attempting write of log report
    title = ['Analysis_', datestr(now,'mm_dd_yyyy_HH_MM')];
    logdir = [experiment_directory, '\AutomatedLogs'];
    if exist(logdir, 'dir') == 0
        mkdir(logdir);
    end
    logname = [logdir, '\', title, '.txt'];
    fileID = fopen(logname,'w');
    for i = 1:size(pp_report, 1)
        formatspec = '%s\r\n %s\r\n %s\r\n\r\n';
        fprintf(fileID, formatspec, pp_report{i, [1, 3, 2]});
    end
    for i = 1:size(bhvr_report, 1)
        formatspec = '%s %s %s\r\n';
        fprintf(fileID, formatspec, bhvr_report{i, :});
    end
    for i = 1:length(skipped_data)
        formatspec = '%s\r\n';
        fprintf(fileID, formatspec, skipped_data{i});
    end
    fclose(fileID);
catch
    disp('Failed to write log');
end
end

% This function handles email delivery - edit the recipients list here to
% control who receives email notifications.
function attempt_email_delivery(summary, title, logname)
%% EDIT EMAIL RECIPIENTS HERE
%recipients of reports:
recipients={'nitin.shyamkumar@gmail.com', ...
            'glab.cornell@gmail.com', ...
            };%add new recipients of daily reports here
%% file processing
pp_summary = ['Attempted processing on ', num2str(actual),...
                ' directories within ', experiment_directory,...
                ' and succeeded on ', num2str(length(newdirs)),' of them.', ...
                ' Full report is attached.'];
%summary = [pp_summary, bhvr_summary];
try
    matlabmail(recipients, summary, title, logname);
catch
    disp('failed mail log');
end
end

