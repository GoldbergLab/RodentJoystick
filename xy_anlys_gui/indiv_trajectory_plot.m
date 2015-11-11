function [handles] = indiv_trajectory_plot(handles)
traj_struct = handles.traj_struct;
%   Detailed explanation goes here
plottype = get(handles.indivselectplot, 'Value');
working_dir = get(handles.working_dir_text,'String');
[thresh2, holdtime, thresh] = extract_contingency_info(working_dir);
thresh2 = thresh2*(handles.RADIUS)/100;
thresh = thresh*(handles.RADIUS)/100;
trajectory = traj_struct(handles.pl_index);
axes(handles.axes7);
cla;

if plottype == 1;
    gray = 0.6*[1 1 1];
    data = trajectory.magtraj;
    axes(handles.axes7);
    hold on;
    line([0 length(data)-1], [thresh thresh], 'Color', gray);
    line([0 length(data)-1], [thresh2 thresh2], 'Color', gray);
    line([holdtime holdtime], [0 100], 'Color', gray);
    hold off;
elseif plottype == 2;
    data = trajectory.traj_x;
elseif plottype == 3;
    data = trajectory.traj_y;
elseif plottype == 4
    data = trajectory.radvel;
elseif plottype == 5;
    data = trajectory.vel_x;
elseif plottype == 6;
    data = trajectory.vel_y;
elseif plottype == 7; 
    data = trajectory.velmag;
end
offset_index = get(handles.offset_menu,'Value');
switch offset_index
    case 1
        offset = length(data);
    case 2
        [~, max_value_ind] = max(trajectory.magtraj);
        offset = max_value_ind;
    otherwise
        offset = trajectory.rw_or_stop;
end
data = data(1:offset);

smoothwindow = get(handles.indivfilter, 'String');
smoothval = smoothwindow{get(handles.indivfilter, 'Value')};
smoothval = str2num(smoothval);
data = smooth(data, smoothval);
multiplyradius = [1; 2; 3];
zerocenter = [2; 3; 4; 5; 6];

if sum(multiplyradius == plottype)
    data = data*handles.RADIUS/100;
    LIMIT = handles.RADIUS*1.08;
else
    data = data*handles.RADIUS*10;
    LIMIT = handles.RADIUS*10*3;
end
axes(handles.axes7);
hold on;
plot(handles.axes7, 0:1:(length(data)-1), data);
if sum(zerocenter == plottype)
    axis(handles.axes7, [0 (length(data)-1) -LIMIT LIMIT]);
else
    axis(handles.axes7, [0 (length(data)-1) 0 LIMIT]);
end
hold off;

end

