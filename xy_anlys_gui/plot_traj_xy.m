function [handles] = plot_traj_xy(handles)
%This function plots the trajectory on x-y coordinate space on the large
%square center axis for xy_anlys_gui


axes(handles.axes6); cla; axis manual; axis square;
% only continue if actually if there are trajectories
if(numel(handles.traj_struct))>0

    %BOX CIRCLE RADIUS
    axis([-1 1 -1 1]*handles.RADIUS*1.08);
    hold on;

    %attempt displaying, getting contingency information from directory;
    try
        handles = display_text_info(handles);
    catch e
        throw(e);
    end

    try 
        handles = plot_trajectory(handles);
    catch e
        throw(e);
    end
end
end

function handles = plot_trajectory(handles)

%ensure time step information is valid
if get(handles.time_info_checkbox,'Value')
    try
        t_step = str2num(get(handles.timestep_edit,'String'));
        t_step = round(t_step);
    catch
        msgbox('Time Step (ms) not valid number');
        t_step=0;
    end
else
    t_step = 0;
end

%access fields
traj_struct = handles.traj_struct;
pl_index = handles.pl_index;
set(handles.trajectory_indexcount, 'String', ...
    [num2str(pl_index), '/',num2str(length(traj_struct))]);

t_x = (traj_struct(pl_index).traj_x);%*(handles.RADIUS/100));
t_y = (traj_struct(pl_index).traj_y);%*(handles.RADIUS/100));

if numel(t_x) > 0
    end_color = hsv2rgb([1 1 1]); marker_color = hsv2rgb([0.6 1 1]);
    step_color = (end_color - marker_color)/(floor(length(t_x)/t_step)+1);

    max_value_ind = traj_struct(pl_index).max_value_ind;
    
    offset_index = get(handles.offset_menu,'Value');
    switch offset_index
        case 1
            offset = length(t_x);
        case 2
            offset = max_value_ind;
        otherwise
            offset = traj_struct(pl_index).rw_or_stop;
    end
    
    t_x = t_x(1:offset); t_y = t_y(1:offset);
    
    %Plot all raw data
    hold on; plot(t_x,t_y,'k');
    plot(t_x(end),t_y(end),'rx','MarkerSize',10,'LineWidth',2);
    plot(t_x(1),t_y(1),'bx','MarkerSize',10,'LineWidth',2);
    
    %Plot time markers
    if t_step>=1
        for i = t_step:t_step:offset
            plot(t_x(i),t_y(i), 'MarkerFaceColor', marker_color, ...
                'Marker', 'O', 'MarkerSize', 5);
            marker_color = marker_color + step_color;
        end
    end
    hold off;
end
end

function handles = display_text_info(handles)
% text information about the trajectory, including contingency information
%% Trajectory Information (Time)
traj_struct = handles.traj_struct;
pl_index = handles.pl_index;
% Display information in the text boxes
actual_traj_time = traj_struct(pl_index).js_onset;
actual_traj_time = (actual_traj_time/1000)/(24*60*60)+handles.start_time;
set(handles.time_text, 'String', datestr(actual_traj_time, 'HH:MM:SS'));
set(handles.jsonset,'String', num2str(traj_struct(pl_index).js_onset));
set(handles.actualht,'String', num2str(length(traj_struct(pl_index).traj_x)));

if traj_struct(pl_index).rw
    rwinfo = 'Yes';
else
    rwinfo = 'No';
end
set(handles.rewardinfo,'String', rwinfo);

%% Contingency Information
working_dir = get(handles.working_dir_text,'String');
[thresh2, holdtime, thresh, minangle, maxangle] = extract_contingency_info(working_dir);
thresh2 = thresh2*handles.RADIUS/100;
thresh = thresh*handles.RADIUS/100;
if pl_index == 1
    set(handles.innerthresh, 'String', num2str(thresh));
    set(handles.ht, 'String', num2str(holdtime));
    set(handles.outerthresh, 'String', num2str(thresh2));
    set(handles.minangle, 'String', num2str(minangle));
    set(handles.maxangle, 'String', num2str(maxangle));
end
handles = plot_contingency_information(thresh, thresh2, minangle, maxangle, ...
    handles.RADIUS, handles);
end

function handles = plot_contingency_information(thresh, thresh2, minangle, maxangle, RADIUS, handles)
%Plots all the contingency information on the main plotting axis.

axes(handles.axes6);
%Plot Inner Thresh
x = thresh*cosd(0:1:360);
y = thresh*sind(0:1:360);
plot(x,y,'Color', [0.2 0.2 0.2],'LineWidth',2);

%Plot Outer Thresh
x = thresh2*cosd(0:1:360);
y = thresh2*sind(0:1:360);
plot(x,y,'Color', [0 0 0],'LineWidth',2);

%Plot Sector
rw_fr = minangle;
rw_fr(sign(rw_fr)==-1) = 360 + rw_fr(sign(rw_fr)==-1);

rw_to = maxangle;
rw_to(sign(rw_to)==-1) = rw_fr(sign(rw_to)==-1) + 360;

x = cosd(1:1:360); y = sind(1:1:360);

if abs(rw_fr-rw_to) < 360
    plot(thresh*x(rw_fr:rw_to),thresh*y(rw_fr:rw_to),'c','LineWidth',2);
    plot(thresh2*x(rw_fr:rw_to),thresh2*y(rw_fr:rw_to),'c','LineWidth',2);
end

%Plot Radius
x = RADIUS*cosd(0:1:360);
y = RADIUS*sind(0:1:360);
plot(x,y,'k','LineWidth',2);
end

