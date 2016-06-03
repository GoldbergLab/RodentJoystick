function [theta_update] = update_contingency(dirlist,varargin)

default = {100,0.25};

numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 4 optional.');
end
[default{1:numvarargs}] = varargin{:};

[tau_thresh,rw_rate] = default{:};

stats = load_stats(dirlist,1,1);
stats = get_stats_with_len(stats,50);

[theta,tau] = tau_theta(stats,30*(6.35/100),45*(6.35/100),0,0,[],0, 'b');

theta = reshape(theta,numel(theta),1);
tau = reshape(tau,numel(tau),1);

tt_dist = hist2d([tau,theta],0:1:1000,-180:1:180);

tt_trials = sum(sum(tt_dist));
tt_dist = tt_dist/(numel(stats.traj_struct));

temp = sum(tt_dist(tau_thresh:end,:),1);
temp = cumsum(temp);

if (temp(end)-rw_rate)<0
    display(strcat('Current rate:',num2str(temp(end)),'lower than target rate:',num2str(rw_rate)));
    theta_update = [];
else
    [~,theta_ccw] = find(temp>0.25);
    [~,theta_cw] = find(temp>(temp(end)-0.25));
    theta_update = [theta_ccw(1) theta_cw(1)] - 180;
end
    theta_update(theta_update<0) = theta_update(theta_update<0)+360;
%[~,tau_out] = find(cumsum(sum(tt_dist,2))>0.75);
%tau_update = tau_out(1);