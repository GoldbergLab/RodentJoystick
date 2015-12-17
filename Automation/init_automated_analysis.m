function automated_analysis_timer = init_automated_analysis(expt_dir, varargin)
%this script generates an automated analysis timer that will handle
%automatic automated analysis.

%% MODIFY THESE DEFAULT PARAMETERS TO SCHEDULE ANALYSIS
start_time = [01 00]; %time is currently set to 9AM (24 hour time)
period = 24*60; %minutes

default = {start_time, period};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[start_time, period] = default{:};

%% UNNECESSARY TO CHANGE ON A REGULAR BASIS
time = now;
desired_seconds = start_time(1)*60*60 + start_time(2)*60;
actual_seconds = (time - floor(time))*24*60*60;
delay = round(desired_seconds-actual_seconds);
if delay<0; delay = delay+24*60*60; end;
automated_analysis_timer = timer('StartDelay', delay, 'Period', 60*period, 'ExecutionMode', 'fixedRate');
automated_analysis_timer.StartFcn = @(~,~)disp(['Beginning automated analysis every ', num2str(period/60),' hours.']);
automated_analysis_timer.TimerFcn = @(~,~)scheduled_analysis(expt_dir);
automated_analysis_timer.StopFcn = @(~,~)disp('Automated analysis stopped.');
start(automated_analysis_timer);
clear period; clear start_time; clear desired_seconds; clear actual_seconds; clear delay; clear time;
end
