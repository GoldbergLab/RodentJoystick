function plot_traj_xy(traj_struct,t_step,offset_index,pl_index,handles)

%BOX CIRCLE RADIUS
RADIUS = 6.35;
fullplot_Axes = handles.axes6;
axes(fullplot_Axes);
cla; axis manual;
hold on;

actual_traj_time = traj_struct(pl_index).js_onset;
actual_traj_time = (actual_traj_time/1000)/(24*60*60)+handles.start_time;
set(handles.time_text, 'String', datestr(actual_traj_time, 'HH:MM:SS'));
set(handles.jsonset,'String', ...
            num2str(traj_struct(pl_index).js_onset));
        set(handles.actualht,'String', ...
            num2str(length(traj_struct(pl_index).traj_x)));
if traj_struct(pl_index).rw
    rwinfo = 'Yes';
else
    rwinfo = 'No';
end
set(handles.rewardinfo,'String', rwinfo);

%attempt getting contingency information from directory;
try
    working_dir = get(handles.working_dir_text,'String');
    stuff = strsplit(working_dir, '\');
    datecont = strsplit(stuff{end-1}, '_');
    thresh2 = str2num(datecont{2})*RADIUS/100;
    thresh = str2num(datecont{4})*RADIUS/100;
    holdtime = str2num(datecont{3});holddist_vect
    minangle = str2num(datecont{5});
    maxangle = str2num(datecont{6});
catch
    thresh = 0.5*RADIUS;
    thresh2 = 0.01*RADIUS;
    holdtime = 300;
    minangle = -180;
    maxangle = 180;
end
if pl_index == 1
    set(handles.innerthresh, 'String', num2str(thresh));
    set(handles.ht, 'String', num2str(holdtime));
    set(handles.outerthresh, 'String', num2str(thresh2));
    set(handles.minangle, 'String', num2str(minangle));
    set(handles.maxangle, 'String', num2str(maxangle));
end

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
rw_to = maxangle;
x = cosd(1:1:360); y = sind(1:1:360);

if abs(rw_fr-rw_to) < 360
    plot(thresh*x(rw_fr:rw_to),thresh*y(rw_fr:rw_to),'c','LineWidth',2);
    plot(thresh2*x(rw_fr:rw_to),thresh2*y(rw_fr:rw_to),'c','LineWidth',2);
end

%Plot Radius
x = RADIUS*cosd(0:1:360);
y = RADIUS*sind(0:1:360);
plot(x,y,'k','LineWidth',2);


axis([-100 100 -100 100])
axis square;
k=pl_index;

traj_x=traj_struct(k).traj_x;
traj_y=traj_struct(k).traj_y;
%Scaling from Percents and smoothing
t_x = smooth(traj_x*(RADIUS/100), 3);
t_y = smooth(traj_y*(RADIUS/100), 3);

end_color = hsv2rgb([1 1 1]);
marker_color = hsv2rgb([0.6 1 1]);
step_color = (end_color - marker_color)/(floor(length(traj_x)/t_step)+1);
if numel(traj_x) > 0
    max_value_ind = traj_struct(k).max_value_ind;
   
    switch offset_index
        case 1
            offset = length(traj_x);
        case 2
            offset = max_value_ind;
        otherwise
            offset = length(traj_x);
    end

    if numel(offset)>0
        t_x = t_x(1:offset); t_y = t_y(1:offset);
        plot(t_x,t_y,'k');
        plot(t_x(end),t_y(end),'rx','MarkerSize',10,'LineWidth',2);
        plot(t_x(1),t_y(1),'bx','MarkerSize',10,'LineWidth',2);
        if t_step>1
            for i = t_step:t_step:offset
                plot(t_x(i),t_y(i), 'MarkerFaceColor', marker_color, 'Marker', 'O', 'MarkerSize', 5);
                marker_color = marker_color + step_color;
            end
        end
        axes(fullplot_Axes);
    end
end

axis([-1 1 -1 1]*RADIUS*1.08);
hold off;
end