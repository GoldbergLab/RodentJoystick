%calling this script sets up the automated analysis timer - cleans
%workspace after it's done.

start_time = [17 20]; %time is currently set to 1AM (24 hour time)
period = 24*60; %minutes

time = now;
desired_seconds = start_time(1)*60*60 + start_time(2)*60;
actual_seconds = (time - floor(time))*24*60*60;
delay = desired_seconds-actual_seconds;
if delay<0; delay = delay+24*60*60; end;
automated_analysis_timer = timer('StartDelay', delay, 'Period', 60*period, 'ExecutionMode', 'fixedRate');
automated_analysis_timer.StartFcn = @(~,~)disp(['Beginning automated analysis every ', num2str(period),' minutes.']);
automated_analysis_timer.TimerFcn = @(~,~)scheduled_analysis;
start(automated_analysis_timer);
clear period;
clear start_time; clear desired_seconds; clear actual_seconds; clear delay; clear time;