function [] = get_cumpdfexittime(stats,dist1,dist2)

stats = get_stats_with_len(stats,50);
stats_reach = get_stats_with_reach(stats,dist2*(6.35/100));

stats_l = get_stats_with_trajid(stats_reach,1);
stats_nl = get_stats_with_trajid(stats_reach,2);



if numel(stats_nl.traj_struct)>0
[~,tau] = tau_theta(stats_nl,dist1*(6.35/100));
tau_dist = histc(tau,0:1:500);
tau_dist = tau_dist/(sum(tau_dist));
tau_cumdist = cumsum(tau_dist);
h = figure;
plot(0:1:500,tau_cumdist,'b');
end

if numel(stats_l.traj_struct)>0
[~,tau] = tau_theta(stats_l,dist1*(6.35/100));
tau_dist = histc(tau,0:1:500);
tau_dist = tau_dist/(sum(tau_dist));
tau_cumdist = cumsum(tau_dist);
figure(h)
hold on
plot(0:1:500,tau_cumdist,'r');
hold off;
end

