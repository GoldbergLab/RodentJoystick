function plot_traj_xy(traj_struct,t_step,onset_index,offset_index,thresh,pl_index,handles)

%BOX CIRCLE RADIUS
RADIUS = 6.35;
fullplot_Axes = handles.axes6;
axes(fullplot_Axes);
cla; axis manual;
hold on
%  thresh = 20;

%Plot Inner Thresh
x = thresh*cosd(0:1:360);
y = thresh*sind(0:1:360);
plot(x,y,'k','LineWidth',2);

%Plot Radius
x = RADIUS*cosd(0:1:360);
y = RADIUS*sind(0:1:360);
plot(x,y,'k','LineWidth',2);


axis([-100 100 -100 100])
axis square;
k=pl_index;

traj_x=traj_struct(k).traj_x;
traj_y=traj_struct(k).traj_y;
%Scaling from Percents
t_x = traj_x*(RADIUS/100);
t_y = traj_y*(RADIUS/100); 

end_color = hsv2rgb([1 1 1]);
marker_color = hsv2rgb([2/3 1 1]);
step = (end_color - marker_color)/(floor(length(traj_x)/t_step));
if numel(traj_x) > 0
    start_p = traj_struct(k).start_p ;
    js_reward=traj_struct(k).rw;
    max_value = traj_struct(k).max_value;
    try
        js_post = traj_struct(k).js_post;
    catch
        js_post = ones(size(traj_x));
    end
    
    switch offset_index
        case 1
            offset = max_value;
        case 2
            offset = length(traj_x);
        case 3
            offset = max_value;
        otherwise
            offset = 0;
    end

    if (js_reward)
        if numel(offset)>0
            t_x = t_x(1:offset); t_y = t_y(1:offset);
            plot(t_x,t_y,'k');
            plot(t_x(end),t_y(end),'rx','MarkerSize',5,'LineWidth',2);
            if t_step>1
                plot(t_x(1:t_step:offset),t_y(1:t_step:offset),'b.');
            end
            axes(fullplot_Axes);
        end
    else
        if numel(offset)>0
            t_x = t_x(1:offset); t_y = t_y(1:offset);
            plot(t_x,t_y,'k');
            plot(t_x(end),t_y(end),'rx','MarkerSize',5,'LineWidth',2);
            if t_step>1
                for i = 1:t_step:offset
                    plot(t_x(i),t_y(i), 'Color', marker_color, 'Marker', '.', 'MarkerSize', 5);
                end
            end
            axes(fullplot_Axes);
        end
    end
   
    axis([-6.5 6.5 -6.5 6.5])
    hold off
end