function [] = get_cumpdfexittime(stats,dist)

stats_new = get_stats_trialsendduetoexit(stats);
stats_l = get_stats_with_trajid(stats_new,1);
stats_nl = get_stats_with_trajid(stats_new,2);
stats_lt = get_stats_with_trajid(stats,1);
stats_nlt = get_stats_with_trajid(stats,2);

ratio2 = numel(stats_l.traj_struct)/numel(stats_lt.traj_struct);
ratio1 = numel(stats_nl.traj_struct)/numel(stats_nlt.traj_struct);
[a1,b1,c1,d1] = js_touch_dist(stats_nl,20,400,0.05,dist*(6.35/100));
[a2,b2,c2,d2] = js_touch_dist(stats_l,20,400,0.05,dist*(6.35/100));
figure;plot(cumsum(b1)*ratio1,'b');
hold on;plot(cumsum(b2)*ratio2,'r');