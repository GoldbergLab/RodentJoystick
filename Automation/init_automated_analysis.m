%calling this function sets up the automated analysis timer - cleans
%workspace after it's done.

period = 5; %minutes

automated_analysis_timer = timer('StartDelay', 30, 'Period', 60*period, 'ExecutionMode', 'fixedRate');
automated_analysis_timer.StartFcn = @(~,~)disp(['Beginning automated analysis every ', num2str(period),' minutes.']);
automated_analysis_timer.TimerFcn = @(~,~)scheduled_analysis;
start(automated_analysis_timer);
clear period;