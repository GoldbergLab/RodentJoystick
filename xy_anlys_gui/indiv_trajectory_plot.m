function [handles] = indiv_trajectory_plot(handles)
traj_struct = handles.traj_struct;
%   Detailed explanation goes here
plottype = get(handles.indivselectplot, 'Value');

trajectory = traj_struct(handles.pl_index);

if plottype == 1;
    data = trajectory.magtraj;
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

smoothwindow = get(handles.indivfilter, 'String');
smoothval = smoothwindow{get(handles.indivfilter, 'Value')};
smoothval = str2num(smoothval);
data = smooth(data, smoothval);
multiplyradius = [1; 2; 3];
zerocenter = [2; 3; 4; 5; 6; 7];
if sum(multiplyradius == plottype)
    data = data*handles.RADIUS/100;
    LIMIT = handles.RADIUS*1.08;
else
    data = data*handles.RADIUS*10;
    LIMIT = handles.RADIUS*10*2;
end
plot(handles.axes7, 1:1:length(data), data);
if sum(zerocenter == plottype)
    axis(handles.axes7, [0 trajectory.rw_or_stop -LIMIT LIMIT]);
else
    axis(handles.axes7, [0 trajectory.rw_or_stop 0 LIMIT]);
end

end

