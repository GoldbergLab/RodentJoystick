function [tau_factor] = get_contingency_change(stats,targ_rate,cw)

stats = get_stats_with_len(stats,50);
stats = get_stats_with_reach(stats,63*(6.35/100));

stats_nl = get_stats_with_trajid(stats,2);
[theta,tau,real_time] = tau_theta(stats_nl,30*(6.35/100),63*(6.35/100),0,0,[],0,'b');

theta_edges = -180:1:180;
theta = theta(tau>100);

tau_factor = sum(tau>100)/numel(tau);
tau_factor = 1-(targ_rate/tau_factor);
theta_dist = histc(theta,theta_edges);

figure;
stairs(theta_edges,theta_dist);
figure;
stairs(theta_edges,cumsum(theta_dist)/sum(theta_dist));
