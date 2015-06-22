function [ handles ] = plot_all_days(handles, axnum)
%While pp_gui handles coordination and UI, plot_all_days does all the
%actual plotting work:
% - loads appropriate jstructs and stats files, and subsequently 
% - performs plotting routines on axes axnum (except for trajectory
% analysis, which does multiple);

%% Argument extraction and plotting information
try
    dirlist = handles.dirlist;
    jslist = dirlist;
    for i = 1:length(jslist);
        jslist(i).isdir = 0;
        jslist(i).name = [jslist(i).name, '\jstruct.mat'];
    end
catch
    error('Attempted plotting without any days selected.');
end
axes = [handles.axes1; handles.axes2; handles.axes3; handles.axes4;
        handles.axes5; handles.axes6];
plotselectors = [handles.ax1plotselect; handles.ax2plotselect; handles.ax3plotselect;
                handles.ax4plotselect; handles.ax5plotselect;
                handles.ax6plotselect];
plotnames = get(plotselectors(axnum), 'String');
plotname = plotnames{get(plotselectors(axnum), 'Value')};

arg1s = [handles.ax1arg1; handles.ax2arg1; handles.ax3arg1; 
                handles.ax4arg1; handles.ax5arg1; handles.ax6arg1];
arg2s = [handles.ax1arg2; handles.ax2arg2; handles.ax3arg2; 
                handles.ax4arg2; handles.ax5arg2; handles.ax6arg2];
arg3s = [handles.ax1arg3; handles.ax2arg3; handles.ax3arg3; 
                handles.ax4arg3; handles.ax5arg3; handles.ax6arg3];
arg1 = arg1s(axnum); arg2 = arg2s(axnum); 
arg3 = arg3s(axnum);
combineflag = 0;

%% Plotting Routines - edit here to add new functions
% arg1, arg2, arg3 are left as strings from taking from the textboxes
%    makes it more flexible in case of string args in the future - and
%    sometimes arguments will be blank;
if strcmp(plotname, 'Nosepoke Joystick Onset Distribution')
    arg1 = str2num(arg1);
    cla(axes(axnum), 'reset');
    np_js_distribution(jslist, arg1, combineflag, 1, axes(axnum));
elseif strcmp(plotname, 'Nosepoke Post Onset Distribution')
    arg1 = str2num(arg1);
    cla(axes(axnum), 'reset');
    np_post_distribution(jslist, arg1, combineflag, 1, axes(axnum));
elseif strcmp(plotname, 'Hold Length Distribution (Max)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'Normalize'; %whether to normalize distributions
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    arg2 = ~(~arg2);
    cla(axes(axnum), 'reset');
    holdtime_firstcontact_distribution(jslist, 150, arg1, combineflag, arg2, 1, axes(axnum));  
elseif strcmp(plotname, 'Hold Length Distribution (Threshold)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'Normalize'; %whether to normalize distributions
%   arg3label = 'Thresh'; %Distance threshold
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    arg3 = str2num(arg3);
    arg2 = ~(~arg2);
    cla(axes(axnum), 'reset');
    holdtime_firstcontact_distribution(jslist, arg3, arg1, combineflag, arg2, 1, axes(axnum)); 
elseif strcmp(plotname, 'Hold Time Distribution (Trajectories)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
    hold_time_distr(jslist, arg1, arg2, combineflag, 1, axes(axnum));
elseif strcmp(plotname, 'Rewarded Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Reward Rate by Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Joystick Onset to Reward Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Nosepoke/Reward Activity Distribution')
%   arg1label = 'Interv'; %Histogram interval (min)
    arg1 = str2num(arg1);
    cla(axes(axnum), 'reset');

elseif strcmp(plotname, 'Activity Heat Map')
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Velocity Heat Map')
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Velocity Variation Heat Map')
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Acceleration Heat Map')
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Acceleration Variation Heat Map')
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Angle Distribution (Linear)')
%     arg1label = 'Rew Rate'; %Desired reward rate
%     arg2label = 'Thresh'; %Histogram interval (ms)
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Trajectory Analysis (4)')
%   arg1label = 'Start'; %start time;
%   arg2label = 'End'; %end time;
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
elseif strcmp(plotname, 'Trajectory Analysis (6)')
%   arg1label = 'Start'; %start time;
%   arg2label = 'End'; %end time;
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    cla(axes(axnum), 'reset');
end

end

