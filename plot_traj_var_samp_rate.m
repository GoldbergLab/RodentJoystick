function plot_traj_var_samp_rate(traj_struct,t_step,onset_index,offset_index,pl_index,subsamp_ratio)

k = pl_index;

traj_x=traj_struct(k).traj_x;
traj_y=traj_struct(k).traj_y;
if numel(traj_x) > 0
    start_p=traj_struct(k).start_p ;
    js_reward=traj_struct(k).rw;
    th_index=traj_struct(k).th_index;
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
            
            t_x = traj_x(1:subsamp_ratio:offset);
            t_y = traj_y(1:subsamp_ratio:offset);
            
            plot(t_x,t_y,properties);
            plot(t_x(js_post(20:(end-20))),t_y(js_post(20:(end-20))),'rx');
            plot(t_x(end),t_y(end),'rx','MarkerSize',5,'LineWidth',2);
            if t_step>1
                plot(traj_x(1:t_step:offset),traj_y(1:t_step:offset),'k.');
            end
        end
    else
        if numel(offset)>0
            
            t_x = traj_x(1:subsamp_ratio:offset);
            t_y = traj_y(1:subsamp_ratio:offset);
            if subsamp_ratio > 1
                plot(t_x,t_y,'b','LineWidth',2);
            else
                plot(t_x,t_y,'r')
            end
            if t_step>1
                plot(traj_x(1:t_step:offset),traj_y(1:t_step:offset),'k.');
            end
        end
    end
end