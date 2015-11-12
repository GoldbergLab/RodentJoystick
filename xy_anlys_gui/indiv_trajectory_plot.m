function [handles] = indiv_trajectory_plot(handles)
%plots 

[success, retrieval] = retrieve_data(handles);
if success
    handles = plot_data(retrieval.data, retrieval.ptype, handles);
end
end

function handles = plot_data(data, plottype, handles)
%plots desired data on axes 7 with appropriate limits according to plottype
multiplyradius = [1; 2; 3];
zerocenter = [2; 3; 4; 5; 6];
data = data*handles.RADIUS/100;
if sum(multiplyradius == plottype)
    LIMIT = handles.RADIUS*1.08;
else
    LIMIT = Inf;
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

function [success, retrieval] = retrieve_data(handles)
%retrieve desired data based on arguments in gui
retrieval.data = [];
retrieval.ptype = [];
success = 0;
traj_struct = handles.traj_struct;
plottype = get(handles.indivselectplot, 'Value');
working_dir = get(handles.working_dir_text,'String');
[thresh2, holdtime, thresh] = extract_contingency_info(working_dir);
thresh2 = thresh2*(handles.RADIUS)/100;
thresh = thresh*(handles.RADIUS)/100;
trajectory = traj_struct(handles.pl_index);
axes(handles.axes7); cla;
if numel(trajectory)>0
    if plottype == 1;
        gray = 0.6*[1 1 1];
        data = trajectory.magtraj;
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
    elseif plottype == 8;
        data = equi_affine_data(trajectory.vel_x, trajectory.vel_y, handles);
    else
        data = trajectory.magtraj;
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
    retrieval.data = data;
    retrieval.ptype = plottype;
    success = 1;
end

end

function data = equi_affine_data(vx, vy, handles)
vx = vx*handles.RADIUS/100;
vy = vy*handles.RADIUS/100;


ax = diff(vx);
ay = diff(vy);

x3dot = diff(ax);
y3dot = diff(ay);

vx = vx(2:end-1);
vy = vy(2:end-1);
ax = ax(1:end-1);
ay = ay(1:end-1);

secondterm = 1./(abs(vx.*ay - ax.*vy).^(2/3));
secondterm = diff(diff(secondterm));

firstterm = (ax.*y3dot - x3dot.*ay)./(abs(vx.*ay - ax.*vy).^(5/3));

data = firstterm(2:end-1)-0.5*secondterm;


%equi_affine_speed = (abs(vx.*ay - vy.*ax)).^(1/3);

end

