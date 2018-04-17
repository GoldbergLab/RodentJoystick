function [ff] = failure_mode(stats,thresh_out,hold_time,hold_dist,dir1,dir2,ccw)
 
% dir1 = 0;
% dir2 = 360;
% ccw = 1;
 thresh_out = thresh_out*(6.35/100);
 hold_dist =  hold_dist*(6.35/100);
% min_time =100;



stats = get_stats_with_len(stats,50);
stats_fail = get_stats_rw(stats,0);

tstruct = stats_fail.traj_struct;

output_reach = arrayfun(@(y) (sum(y.magtraj>thresh_out)>0), tstruct);
%%
output = arrayfun(@(x) min(find((x.magtraj)>(hold_dist)))>hold_time,tstruct,'UniformOutput',false);
output_hold = zeros(1,numel(output))>0;
for i=1:length(output)
    if numel(output{i})>0
        output_hold(i) = output{i}>0;
    end
end
%%
[theta,~] = tau_theta(stats_fail,hold_dist,thresh_out,0,0,[],0);
theta = wrapTo360(theta);
if ccw
    output_theta = (theta>dir1 & theta<dir2);
else
    theta(theta<60) = theta(theta<60)+360;
    output_theta = (theta>dir2 & theta<(dir1+360));
end

ff(1) = 1-sum(output_hold)/numel(tstruct);
ff(2) = 1-sum(output_reach)/numel(tstruct);
ff(3) = 1-sum(output_theta)/numel(theta);
end

