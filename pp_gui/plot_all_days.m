function [ handles ] = plot_all_days(handles, axnum)
%While pp_gui handles coordination and UI, plot_all_days does all the
%actual plotting work:
% - loads appropriate jstructs and stats files, and subsequently 
% - performs plotting routines on axes axnum (except for trajectory
% analysis, which does multiple);

%% Argument extraction and plotting information
% don't change this section if you just want to add a new function
    dirlist = handles.dirlist;
catch
    msgbox('Attempted plotting without any days selected.', 'Error','error');
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
arg1 = get(arg1s(axnum), 'String'); 
arg2 = get(arg2s(axnum), 'String'); 
arg3 = get(arg3s(axnum), 'String');
combineflag = get(handles.combinedays, 'Value');

if strcmp(plotname, 'Activity Heat Map') || strcmp(plotname, 'Angle Distribution (Linear)')
    statscombined = load_stats(dirlist, 1);
end
cla(axes(axnum), 'reset');
%% PLOTTING ROUTINES - EDIT HERE TO ADD NEW FUNCTIONS
% The following are available to 
% arg1, arg2, arg3 are left as strings from taking from the textboxes
%    makes it more flexible in case of string args in the future - and
%    sometimes arguments will be '' or '-';
%
if strcmp(plotname, 'Nosepoke Joystick Onset Distribution')
    arg1 = str2num(arg1);
    np_js_distribution(dirlist, arg1, combineflag, 1, axes(axnum));
elseif strcmp(plotname, 'Nosepoke Post Onset Distribution')
    arg1 = str2num(arg1);
    np_post_distribution(dirlist, arg1, combineflag, 1, axes(axnum));
elseif strcmp(plotname, 'Hold Length Distribution (Max)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'Normalize'; %whether to normalize distributions
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    arg2 = ~(~arg2);
    holdtime_firstcontact_distribution(dirlist, 150, arg1, combineflag, arg2, 1, axes(axnum));  
elseif strcmp(plotname, 'Hold Length Distribution (Threshold)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'Normalize'; %whether to normalize distributions
%   arg3label = 'Thresh'; %Distance threshold
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    arg3 = str2num(arg3);
    arg2 = ~(~arg2);
    holdtime_firstcontact_distribution(dirlist, arg3, arg1, combineflag, arg2, 1, axes(axnum)); 
elseif strcmp(plotname, 'Hold Time Distribution (Trajectories)')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    hold_time_distr(dirlist, arg1, arg2, combineflag, axes(axnum), []);
elseif strcmp(plotname, 'Rewarded Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    rewarded_time_distr(dirlist, arg1, arg2, combineflag, axes(axnum), []);
elseif strcmp(plotname, 'Reward Rate by Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    rewardrate_distr(dirlist, arg1, arg2, combineflag, axes(axnum), []);
elseif strcmp(plotname, 'Joystick Onset to Reward Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    joystick_to_reward_distr(dirlist, arg1, arg2, combineflag, axes(axnum), []);
elseif strcmp(plotname, 'Nosepoke/Reward Activity Distribution')
%   arg1label = 'Interv'; %Histogram interval (min)
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    multi_time_distr(dirlist, arg1, 'single', combineflag, arg2, inf, axes(axnum));
elseif strcmp(plotname, 'Activity Heat Map')
    activity_heat_map(statscombined, 1, [2 99], axes(axnum));
elseif strcmp(plotname, 'Velocity Heat Map')
    velocity_heat_map(dirlist, axes(axnum));
elseif strcmp(plotname, 'Velocity Variation Heat Map')
    velocityvar_heat_map(dirlist, axes(axnum));
elseif strcmp(plotname, 'Acceleration Heat Map')
    accel_heat_map(dirlist, axes(axnum));
elseif strcmp(plotname, 'Acceleration Variation Heat Map')
    accelvar_heat_map(dirlist, axes(axnum));
elseif strcmp(plotname, 'Angle Distribution (Linear)')
%     arg1label = 'Rew Rate'; %Desired reward rate
%     arg2label = 'Thresh'; %Histogram interval (ms)
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    multi_sector_analysis(dirlist, arg1, arg2, 1, axes(axnum));
elseif strcmp(plotname, 'Trajectory Analysis (4)')
%   arg1label = 'Start'; %start time;
%   arg2label = 'End'; %end time;
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    if axnum == 1 || axnum == 4
        axestoplot = [axes(1); axes(2); axes(4); axes(5)];
    else
        axestoplot = [axes(2); axes(3); axes(5); axes(6)];
    end
    info = 'Trajectory Analysis will overwrite 4 axes in a block pattern. Do you want to continue?';
    button = questdlg(info,'Warning: Trajectory Analysis','Yes','No','No');
    if strcmp(button, 'Yes')
        for i = 1:length(axestoplot)
            cla(axestoplot(i), 'reset');
        end
        multi_trajectory_analysis(dirlist, 4, [arg1 arg2], [0 0 0], combineflag, axestoplot);
    end
elseif strcmp(plotname, 'Trajectory Analysis (6)')
%   arg1label = 'Start'; %start time;
%   arg2label = 'End'; %end time;
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    info = 'Trajectory Analysis will plot over all 6 axes. Do you want to continue?';
    button = questdlg(info,'Warning: Trajectory Analysis','Yes','No','No');
    if strcmp(button, 'Yes')
        for i = 1:length(axes)
            cla(axes(i), 'reset');
        end
        multi_trajectory_analysis(dirlist, 6, [arg1 arg2], [0 0 0], combineflag, axes);
    end
end

end

