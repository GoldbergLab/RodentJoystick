function [angles,rwrate_fail] = get_contingency_change(stats,targ_rate,ccw,plot_flag)

angles = [];
rwrate_fail = 0;
try
stats = get_stats_with_len(stats,50);
stats = get_stats_with_reach(stats,63*(6.35/100));

stats_rw = get_stats_rw(stats,1);

rw_cnt = numel(stats_rw.traj_struct);

%stats_nl = get_stats_with_trajid(stats,2);
[theta,tau,real_time] = tau_theta(stats,30*(6.35/100),63*(6.35/100),0,0,[],0,'b');

theta_edges = -180:1:180;
theta = theta(tau>100);

theta_dist = histc(theta,theta_edges);
theta_dist_cum = cumsum(theta_dist)/sum(theta_dist);

tau_factor = sum(tau>100)/numel(tau);

if ccw
    tau_factor = 1-(targ_rate/tau_factor);
    [ind] = find(theta_dist_cum<tau_factor);
    if (tau_factor>1 || tau_factor <0)
         if rw_cnt>151
          [ind] = find(theta_dist_cum<0.85);
         else    
            rwrate_fail = 1;
            angles = [0 360 1];
            return
         end
    end
    angle1 = theta_edges(ind(end));
    angle2 = theta_edges(ind(end))+60;
        
else
    tau_factor = (targ_rate/tau_factor);
    [ind] = find(theta_dist_cum>tau_factor);
    if (tau_factor>1 || tau_factor <0) %&& (rw_cnt<100)
         if rw_cnt>151
          [ind] = find(theta_dist_cum>0.15);
         else    
            rwrate_fail = 1;
            angles = [0 360 1];
            return
         end
    end
    angle1 = theta_edges(ind(1))-60;
    angle2 = theta_edges(ind(1));
end


%covert angles to 0 to 360

angle1(angle1<0) = angle1(angle1<0)+360;
angle2(angle2<0) = angle2(angle2<0)+360;

angle1(angle1>360) = angle1(angle1>360)-360;
angle2(angle2>360) = angle1(angle1>360)-360;

if (angle1>300) || (angle2<60)
    ccw_flag = 0;
else
    ccw_flag = 1;
end

angles(1) = min(angle1,angle2);
angles(2) = max(angle1,angle2);
angles(3) = ccw_flag;
if plot_flag
    figure;
    stairs(theta_edges,theta_dist);
    figure;
    stairs(theta_edges,theta_dist_cum);
end
catch e
    display(strcat(e.message,': Failed Angle Distribution, using defaults'));
    angles = [0 360 1];
end