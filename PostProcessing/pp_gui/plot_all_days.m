function [ handles ] = plot_all_days(handles, axnum)
%While pp_gui handles coordination and UI, plot_all_days does all the
%actual plotting work:
% - loads appropriate jstructs and stats files, and subsequently 
% - performs plotting routines on axes axnum (except for trajectory
% analysis, which does multiple);

%% Argument extraction and plotting information
% don't change this section if you just want to add a new function
try
    dirlist = handles.dirlist;
catch
    msgbox('Attempted plotting without any days selected.', 'Error','error');
    error('Attempted plotting without any days selected.');
end
axlist = [handles.axes1, handles.axes2, handles.axes3; ...
        handles.axes4, handles.axes5, handles.axes6]';
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
smoothps = cellstr(get(handles.smoothparam,'String'));
smoothparam = smoothps{get(handles.smoothparam,'Value')};
smoothparam = str2num(smoothparam);
normalize = get(handles.normalizecheck, 'Value');
rw_only = get(handles.rwtrial_check, 'Value');
lasercompareflag = get(handles.lasercomparemenu, 'Value');
to_stop = get(handles.checkbox_ts,'value');

if strcmp(plotname, 'Activity Heat Map')
    statscombined = load_stats(dirlist,1,to_stop);
end
cla(axlist(axnum), 'reset');
colnum = axnum;
if colnum > 3; colnum = colnum - 3; end;
%% PLOTTING ROUTINES - EDIT HERE TO ADD NEW FUNCTIONS
% The following are available to any function call
%
%   dirlist :: a list of directories to plot/analyze
%
%   arg1, arg2, arg3 :: 
%       strings from taking from the textboxes makes it more flexible 
%       in case of string args in the future - and sometimes arguments 
%       will be '' or '-';
%
%   combineflag :: 1/0 flag instructing whether to combine all days in 
%       dirlist or leave empty
%   
%   normalize :: 1/0 global flag declaring normalizing
% 
%   smoothparam :: desired smoothing - i.e. ` smooth(data, smoothparam)`
%
%   axes(axnum) :: axes available for plotting
%       see notes on wiki for accessing other axes
if strcmp(plotname, 'Nosepoke Joystick Onset Distribution')
    interv = str2num(arg1);
    np_js_distribution(dirlist, interv, normalize, combineflag, ...
        smoothparam, 1, axlist(axnum));
elseif strcmp(plotname, 'Nosepoke Post Onset Distribution')
    interv = str2num(arg1);
    np_post_distribution(dirlist, interv, normalize, combineflag,...
        smoothparam, 1, axlist(axnum));
elseif strcmp(plotname, 'Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    interv = str2num(arg1);
    endtime = str2num(arg2);
    ht_def = 0;
    hold_time_distr(dirlist, ht_def, interv, endtime, combineflag, normalize,...
        smoothparam, axlist(axnum));
elseif strcmp(plotname, 'Rewarded Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    interv = str2num(arg1);
    endtime = str2num(arg2);
    rewarded_time_distr(dirlist, interv, endtime, combineflag, ...
        normalize, smoothparam, axlist(axnum));
elseif strcmp(plotname, 'Reward Rate by Hold Time Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    rewardrate_distr(dirlist, arg1, arg2, combineflag, axlist(axnum), []);
elseif strcmp(plotname, 'Joystick Onset to Reward Distribution')
%   arg1label = 'Interv'; %Histogram interval (ms)
%   arg2label = 'End Time'; %what time range to plot
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    joystick_to_reward_distr(dirlist, arg1, arg2, combineflag, axlist(axnum), []);
elseif strcmp(plotname, 'Nosepoke/Reward Activity Distribution')
%   arg1label = 'Interv'; %Histogram interval (min)
    interv = str2num(arg1);
    norm = str2num(arg2);
    rewonly = str2num(arg3);
    multi_time_distr(dirlist, interv, 'single', combineflag, norm, rewonly, inf, axlist(axnum));
elseif strcmp(plotname, 'JS Touch Dist')
    traj_id = str2num(arg1); 
    holdtime = str2num(arg2); 
    thresh = str2num(arg3)*(6.35/100);
    
    rewrate = 0.1; interv = 10; plotflag = 1;
    if lasercompareflag>1
        [~, setdiststr] = multi_js_touch_dist_laser(dirlist, interv, rewrate, thresh, ...
            holdtime, plotflag, smoothparam, axlist(axnum), lasercompareflag-1,to_stop);
    else %normal call
        [~, setdiststr] = multi_js_touch_dist(dirlist, interv, rewrate, thresh, ...
            holdtime, combineflag, plotflag, smoothparam, axlist(axnum),traj_id,to_stop);
    end
        setdiststr = ['JS Touch Dist', setdiststr];
        setdiststr = setdiststr';
        handles = update_console(handles, setdiststr);
        
elseif strcmp(plotname, 'Activity Heat Map')
    if lasercompareflag>1
        cla(axlist(colnum, 1), 'reset');
        cla(axlist(colnum, 2), 'reset');
        activity_heat_map(statscombined, 1, [2 99], axlist(colnum, 1),[1 100], 1, rw_only);
        activity_heat_map(statscombined, 1, [2 99], axlist(colnum, 2),[1 100], lasercompareflag, rw_only);
    else
        trajid=str2num(arg2);
        activity_heat_map(statscombined, 1, [2 99], axlist(axnum),[1 100],trajid,rw_only);
    end
elseif strcmp(plotname, 'Velocity Heat Map')
    arg1 = str2num(arg1);
    velocity_heat_map(dirlist, axlist(axnum), [], arg1);
elseif strcmp(plotname, 'Velocity Variation Heat Map')
    arg1 = str2num(arg1);
    velocityvar_heat_map(dirlist, axlist(axnum), [], arg1);
elseif strcmp(plotname, 'Acceleration Heat Map')
    arg1 = str2num(arg1);
    accel_heat_map(dirlist, axlist(axnum), [], arg1);
elseif strcmp(plotname, 'Acceleration Variation Heat Map')
    arg1 = str2num(arg1);
    accelvar_heat_map(dirlist, axlist(axnum), [], arg1);
elseif strcmp(plotname, 'Angle Distribution (Linear)')
%     arg1label = 'Rew Rate'; %Desired reward rate
%     arg2label = 'Thresh'; %Histogram interval (ms)
    arg1 = str2num(arg1);
    arg2 = str2num(arg2);
    multi_sector_analysis(dirlist, arg1, arg2, combineflag, axlist(axnum));
elseif strcmp(plotname, 'Trajectory Analysis (4)') ||...
        strcmp(plotname, 'Trajectory Analysis (6)')
%   arg1label = 'Start'; %start time;
%   arg2label = 'End'; %end time;
    plotnum = str2num(plotname(end-1));
    
    start = str2num(arg1);
    endt = str2num(arg2);
    traj_id = str2num(arg3);
    if axnum == 1 || axnum == 4
        startcol = 1;
    else
        startcol = 2;
    end
    
    if plotnum == 4
        axestoplot = reshape(axlist(startcol:startcol+1, 1:2), [4 1]);
    else
        axestoplot = reshape(axlist, [6 1]);
    end

    info = sprintf(['Trajectory Analysis will overwrite %d axes in a block', ... 
        ' pattern. Do you want to continue?'], plotnum);

    button = questdlg(info,'Warning: Trajectory Analysis','Yes','No','No');
    
    if strcmp(button, 'Yes')
        for i = 1:length(axestoplot)
            cla(axestoplot(i), 'reset');
        end
      
            multi_trajectory_analysis(dirlist, 0, plotnum, [start endt], ...
                combineflag, smoothparam, traj_id, axestoplot,lasercompareflag);


    end
elseif strcmp(plotname,'Pathlength')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_pathlen(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Duration')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_duration(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Average Velocity')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_avgvel(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Maximum Velocity')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_maxvel(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Accleration Peaks')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_accpeaks(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Segments in Trajectory')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_traj_numseg(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Angle at Thresh')
    trajid = str2num(arg1);
    interv = str2num(arg2);
    thresh = str2num(arg3)*(6.35/100);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv';
%   arg3label = 'Thresh';
    plotflag=1;
    [consolestr] = multi_anglethreshcross(dirlist,thresh,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Angle at Thresh after Hold')
    trajid = str2num(arg1);
    thresh_in = str2num(arg2)*(6.35/100);
    thresh_out = str2num(arg3)*(6.35/100);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv';
%   arg3label = 'Thresh';
    hold_time = 200;
    interv = 20;
    plotflag=1;
    [consolestr] = multi_anglethreshcrosshold(dirlist,thresh_in,thresh_out,hold_time,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag);
    handles = update_console(handles, consolestr');   
elseif strcmp(plotname,'Segment Pathlen')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_seg_pathlen(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Segment Avg Vel')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_seg_avgvel(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Segment Peak Vel')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_seg_peakvel(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
elseif strcmp(plotname,'Segment Duration')
    trajid = str2num(arg1);
    interv = str2num(arg2);
%   arg1label = 'TrajID'; 
%   arg2label = 'Interv'; 
    plotflag=1;
    [consolestr] = multi_seg_dur(dirlist,trajid,rw_only,interv,axlist(axnum),plotflag,combineflag,lasercompareflag,to_stop);
    handles = update_console(handles, consolestr');
end

