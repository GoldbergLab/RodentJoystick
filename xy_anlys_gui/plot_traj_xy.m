function plot_traj_xy(traj_struct,t_step,onset_index,offset_index,thresh,pl_index,handles)

fullplot_Axes = handles.axes6;
axes(fullplot_Axes);
cla
axis manual
hold on
%  thresh = 20;
windowSize =20;

x = thresh*cosd(0:1:360);
y = thresh*sind(0:1:360);
plot(x,y,'k','LineWidth',2);
axis([-100 100 -100 100])
axis square;

k=pl_index;

traj_x=traj_struct(k).traj_x;
traj_y=traj_struct(k).traj_y;
if numel(traj_x) > 0
    start_p=traj_struct(k).start_p ;
    js_reward=traj_struct(k).rw;
%     th_index=traj_struct(k).th_index;
    max_value = traj_struct(k).max_value;
    try
        js_post = traj_struct(k).js_post;
    catch
        js_post = ones(size(traj_x));
    end
    
    switch offset_index
        case 1
            offset = th_index;
        case 2
            offset = length(traj_x);
        case 3
            offset = max_value;
        otherwise
            offset = 0;
    end
    
    switch onset_index
        case 1
            onset = start_p;
        otherwise
            onset = 0;
    end
    
    
    
    
    if (js_reward)
        if numel(offset)>0
            
            t_x = traj_x(1:offset)*(6.35/100);
            t_y = traj_y(1:offset)*(6.35/100);
%             t_x = filter(ones(1,windowSize)/windowSize,1,t_x);
%             t_y = filter(ones(1,windowSize)/windowSize,1,t_y);
%             t_x = t_x(20:end-20);
%             t_y = t_y(20:end-20);
            
            
            plot(t_x,t_y,'k');
%             plot(t_x(js_post(20:(end-20))),t_y(js_post(20:(end-20))),'rx');
             plot(t_x(end),t_y(end),'rx','MarkerSize',5,'LineWidth',2);
            if t_step>1
                plot(t_x(1:t_step:offset),t_y(1:t_step:offset),'k.');
            end
            %         axes(handles.axes1)
            %         hold on
            %         plot((onset:(onset+offset-1))/10000,traj_x(1:offset),'r','LineWidth',2);
            %         axes(handles.axes2)
            %         hold on
            %         plot((onset:(onset+offset-1))/10000,traj_y(1:offset),'r','LineWidth',2);
            axes(fullplot_Axes);
        end
    else
        if numel(offset)>0
            
            t_x = traj_x(1:offset)*(6.35/100);
            t_y = traj_y(1:offset)*(6.35/100);
%             t_x = filter(ones(1,windowSize)/windowSize,1,t_x);
%             t_y = filter(ones(1,windowSize)/windowSize,1,t_y);
%             t_x = t_x(20:end-20);
%             t_y = t_y(20:end-20);

            plot(t_x,t_y,'k');
%             plot(t_x(js_post(20:(end-20))),t_y(js_post(20:(end-20))),'bx');
            plot(t_x(end),t_y(end),'rx','MarkerSize',5,'LineWidth',2);
            
            if t_step>1
                plot(t_x(1:t_step:offset),t_y(1:t_step:offset),'k.');
            end
            %         axes(handles.axes1)
            %         hold on
            %         plot((onset:(onset+offset-1))/10000,traj_x(1:offset),'b','LineWidth',2);
            %         axes(handles.axes2)
            %         hold on
            %         plot((onset:(onset+offset-1))/10000,traj_y(1:offset),'b','LineWidth',2);
            axes(fullplot_Axes);
        end
    end
    %axes(fullplot_Axes);
    
    
    
    % plot(traj_x(1),-1*traj_y(1),'rx');
    
    axis([-6.5 6.5 -6.5 6.5])
    hold off
end