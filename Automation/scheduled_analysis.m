%Function to be called by a MATLAB timer object at a fixed rate to ensure
%that analysis is scheduled and executed regularly
function pp_report = scheduled_analysis(varargin)
disp('Performing scheduled post processing analysis');
%Function to be called by a MATLAB timer object at a fixed rate to ensure
%that analysis is scheduled and executed regularly
default = {'K:\automationtest'};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 1), only one optional.');
end
[default{1:numvarargs}] = varargin{:};
[experiment_directory] = default{:};
%put the main directory containing experiment data here.
%recipients of reports:
recipients={'nitin.shyamkumar@gmail.com', ...
            'glab.cornell@gmail.com', ...
            };%add new recipients of daily reports here

%normal pellet count - anything outside of this range is specifically
%highlighted in the mail notification
normal_pellets = [100 300];

time = now;
toprocesslist = directories_to_do(experiment_directory);
title = {'Analysis attempted on the following directories within ','', [experiment_directory, ':']};
%attempt all analysis here
[failure, actual, newdirs] = multi_doAll(toprocesslist, 1);
pp_report = [title; failure];

try
    [bhvr_report] = behavior_report(newdirs);
catch 
end

try %attempting write of log report
    title = ['Analysis_', datestr(time,'mm_dd_yyyy_HH_MM')];
    direntries = strsplit(experiment_directory, '\');
    logdir = [celljoin(direntries{1:end-1}, '\'), '\AutomatedLogs'];
    if exist(logdir, 'dir') == 0
        mkdir(logdir);
    end
    logname = [logdir, '\', title, '.txt'];
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

