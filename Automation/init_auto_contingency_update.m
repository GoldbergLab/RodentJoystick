%autotimer = init_auto_contingency_update(handles, [start_time, period]);
%This function returns a timer that handles automatically updating the
%automated contingency update feature on the GUI. The GUI must be running
%for this function to work (note the handles argument). This function has a
%subfunction that contains a list of items to do - it updates the GUI based
%on desired targets, then writes out the contingency information.
%ARGUMENTS
%   handles :: valid set of handles from auto_anlys_gui
%   start_time :: initially scheduled time for running automated
%       contingency updates (format: [hours min], 24 hour time);
%       DEFAULT  - [01 00] (1 AM)
%   period :: period (interval between) scheduled analysis in minutes
%       DEFAULT: 1440 minutes (24 hours)
function auto_contingency_timer = init_auto_contingency_update(handles, varargin)

%% MODIFY THESE DEFAULT PARAMETERS TO SCHEDULE ANALYSIS
start_time = [01 00]; %time is currently set to 1AM (24 hour time)
period = 24*60; %minutes
recipients={'nitin.shyamkumar@gmail.com', ...
            'glab.cornell@gmail.com'...
            }; %add recipients here

default = {start_time, period};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[start_time, period] = default{:};

%% UNNECESSARY TO CHANGE ON A REGULAR BASIS
time = now;
desired_seconds = start_time(1)*60*60 + start_time(2)*60;
actual_seconds = (time - floor(time))*24*60*60;
delay = round(desired_seconds-actual_seconds);

if delay<0; delay = delay+24*60*60; end;
auto_contingency_timer = timer('StartDelay', delay, 'Period', 60*period, 'ExecutionMode', 'fixedRate');
auto_contingency_timer.StartFcn = @(~,~)disp(['Beginning automated contingency updates every ', num2str(period/60),' hours.']);
auto_contingency_timer.TimerFcn = @(~,~)regular_contingency_updates(handles, recipients);
auto_contingency_timer.StopFcn = @(~,~)disp('Automated contingency updates stop.');
start(auto_contingency_timer);
clear period; clear start_time; clear desired_seconds; clear actual_seconds; clear delay; clear time;
end

%% If you want to make changes to how scheduled analysis is done, edit here.
function regular_contingency_updates(handles, recipients)
    exptdir = get(handles.exptdirlabel, 'String');
    update_all_boxes_anlys_gui(handles);
    [~, failures, attachments] = write_out_all_contingencies_anlys_gui(handles, 0);
    try
    logdir = [exptdir, '\AutomatedLogs'];
    if exist(logdir, 'dir') == 0
        mkdir(logdir);
    end
    title = ['AutoContingencyUpdate_', datestr(now, 'mm_dd_yyyy_HH_MM')];
    logname = [logdir,'\', title, '.txt'];

    fid = fopen(logname, 'w');
    for i = 1:size(failures, 1)
         fprintf(fid, '%s\n', failures{i});
    end
    fclose(fid);
    matlabmail(recipients, failures, title, attachments);
    catch e
        disp(getReport(e));
    end
end
